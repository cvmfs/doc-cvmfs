#!/usr/bin/env bash
# Open cherry-pick (backport) PRs for a merged PR, or clean up merged backport branches.
#
# Usage:
#   add-ons/backport.sh [-r owner/repo] [-R remote] [-n] <pr|url> [branch...]
#   add-ons/backport.sh [-r owner/repo] [-R remote] [-n] --cleanup
#
# Without branches, targets the highest numeric version branch (e.g. 2.14).
# Branch names are pick-<pr>-<target>; each PR gets the "backport" label.
# Uses gh if available, otherwise git + curl with $GITHUB_TOKEN (or $GH_TOKEN).

set -euo pipefail

REPO=cvmfs/doc-cvmfs
REMOTE=origin
LABEL=backport
DRY=
CLEANUP=

die() { echo "error: $*" >&2; exit 1; }
run() { if [ -n "$DRY" ]; then echo "+ $*"; else "$@"; fi; }
# Help text is the header comment block, up to the first non-comment line.
usage() { awk 'NR > 1 && !/^#/ { exit } NR > 1 { sub(/^# ?/, ""); print }' "$0"; exit "${1:-0}"; }

while [ $# -gt 0 ]; do
  case "$1" in
    -r|--repo) REPO=$2; shift 2 ;;
    -R|--remote) REMOTE=$2; shift 2 ;;
    -n|--dry-run) DRY=1; shift ;;
    --cleanup) CLEANUP=1; shift ;;
    -h|--help) usage ;;
    -*) die "unknown option $1" ;;
    *) break ;;
  esac
done

if command -v gh >/dev/null && gh auth status >/dev/null 2>&1; then
  USE_GH=1
else
  USE_GH=
  TOKEN=${GITHUB_TOKEN:-${GH_TOKEN:-}}
  [ -n "$TOKEN" ] || die "need an authenticated gh or GITHUB_TOKEN"
  command -v jq >/dev/null || die "fallback mode needs jq"
fi

api() {  # api METHOD PATH [JSON]
  curl -fsS -X "$1" -H "Authorization: Bearer $TOKEN" \
    -H "Accept: application/vnd.github+json" \
    ${3:+-d "$3"} "https://api.github.com/repos/$REPO/$2"
}

# Prints "merged" if the branch's PR was merged, nothing otherwise.
pr_merged_for_branch() {
  local owner=${REPO%%/*}
  if [ -n "$USE_GH" ]; then
    gh pr list -R "$REPO" --head "$1" --state merged --json number -q 'if length > 0 then "merged" else empty end'
  else
    api GET "pulls?state=closed&head=$owner:$1" | jq -r 'if any(.[]; .merged_at != null) then "merged" else empty end'
  fi
}

if [ -n "$CLEANUP" ]; then
  git fetch --prune "$REMOTE"
  current=$(git branch --show-current)
  for b in $(git for-each-ref --format='%(refname:short)' 'refs/heads/pick-*'); do
    [ "$(pr_merged_for_branch "$b")" = merged ] || continue
    [ "$b" = "$current" ] && { echo "skip $b (checked out)"; continue; }
    run git branch -D "$b"
    if git show-ref -q --verify "refs/remotes/$REMOTE/$b"; then
      run git push "$REMOTE" --delete "$b"
    fi
  done
  exit 0
fi

[ $# -ge 1 ] || usage 1
PR=$1; shift
if [[ $PR =~ github\.com/([^/]+/[^/]+)/pull/([0-9]+) ]]; then
  REPO=${BASH_REMATCH[1]}
  PR=${BASH_REMATCH[2]}
fi
[[ $PR =~ ^[0-9]+$ ]] || die "not a PR number or URL: $PR"
TARGETS=("$@")

git fetch "$REMOTE"
if [ ${#TARGETS[@]} -eq 0 ]; then
  latest=$(git for-each-ref --format='%(refname:lstrip=3)' "refs/remotes/$REMOTE/" |
    grep -E '^[0-9]+\.[0-9]+$' | sort -t. -k1,1n -k2,2n | tail -1)
  [ -n "$latest" ] || die "no version branch found on $REMOTE"
  TARGETS=("$latest")
fi

if [ -n "$USE_GH" ]; then
  read -r TITLE < <(gh pr view "$PR" -R "$REPO" --json title -q .title)
  SHA=$(gh pr view "$PR" -R "$REPO" --json mergeCommit -q '.mergeCommit.oid // empty')
  NCOMMITS=$(gh pr view "$PR" -R "$REPO" --json commits -q '.commits | length')
else
  json=$(api GET "pulls/$PR")
  TITLE=$(jq -r .title <<<"$json")
  SHA=$(jq -r '.merge_commit_sha // empty' <<<"$json")
  NCOMMITS=$(jq -r .commits <<<"$json")
  [ "$(jq -r .merged <<<"$json")" = true ] || SHA=
fi
[ -n "$SHA" ] || die "PR #$PR is not merged"
git cat-file -e "$SHA" 2>/dev/null || git fetch "$REMOTE" "$SHA"

patch_id() { git show "$1" | git patch-id --stable | cut -d' ' -f1; }

# The merge commit is the whole PR for a merge or squash merge, but only the
# last commit for a rebase merge. A rebase merge is recognized by the merge
# commit having the same patch as the PR head.
if [ "$(git rev-list --parents -n1 "$SHA" | wc -w)" -gt 2 ]; then
  pick=(-m 1 "$SHA")
elif [ "$NCOMMITS" -gt 1 ] && git fetch -q "$REMOTE" "refs/pull/$PR/head" &&
     [ "$(patch_id "$SHA")" = "$(patch_id FETCH_HEAD)" ]; then
  pick=("$SHA~$NCOMMITS..$SHA")
else
  pick=("$SHA")
fi

start=$(git branch --show-current)
for tgt in "${TARGETS[@]}"; do
  branch="pick-$PR-$tgt"
  echo "== #$PR -> $tgt ($branch)"
  git show-ref -q --verify "refs/remotes/$REMOTE/$tgt" || die "no branch $REMOTE/$tgt"
  run git switch -c "$branch" "$REMOTE/$tgt"
  if ! run git cherry-pick -x "${pick[@]}"; then
    echo "Cherry-pick conflict on $branch. Resolve, 'git cherry-pick --continue'," >&2
    echo "then rerun with the remaining branches." >&2
    exit 1
  fi
  run git push -u "$REMOTE" "$branch"
  title="$TITLE ($tgt)"
  body="Cherry-pick #$PR to $tgt"
  if [ -n "$USE_GH" ]; then
    run gh pr create -R "$REPO" --base "$tgt" --head "$branch" \
      --title "$title" --body "$body" --label "$LABEL"
  else
    payload=$(jq -n --arg t "$title" --arg b "$body" --arg base "$tgt" --arg h "$branch" \
      '{title:$t, body:$b, base:$base, head:$h}')
    if [ -n "$DRY" ]; then echo "+ POST pulls $payload"; else
      num=$(api POST pulls "$payload" | jq -r .number)
      api POST "issues/$num/labels" "{\"labels\":[\"$LABEL\"]}" >/dev/null
      echo "https://github.com/$REPO/pull/$num"
    fi
  fi
done
[ -n "$start" ] && run git switch "$start"
