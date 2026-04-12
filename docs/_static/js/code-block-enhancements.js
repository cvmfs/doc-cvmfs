window.addEventListener("DOMContentLoaded", function () {
  var selector = ".rst-content .codehilite, .rst-content div.highlight, .rst-content pre.highlight";
  var cvmfsPathPattern = /(^|[^A-Za-z0-9._~\/-])(\/cvmfs(?:\/[^\s"'`<>()\[\]{}]*)?)/g;

  function detectLanguage(elements) {
    for (var i = 0; i < elements.length; i += 1) {
      var element = elements[i];
      if (!element) {
        continue;
      }

      for (var j = 0; j < element.classList.length; j += 1) {
        var className = element.classList[j];
        var match = className.match(/(?:lang(?:uage)?-)([A-Za-z0-9_+-]+)/);
        if (match) {
          return match[1].toLowerCase();
        }
      }
    }

    return "";
  }

  function copyText(text) {
    if (navigator.clipboard && navigator.clipboard.writeText) {
      return navigator.clipboard.writeText(text);
    }

    return new Promise(function (resolve, reject) {
      var textarea = document.createElement("textarea");
      textarea.value = text;
      textarea.setAttribute("readonly", "readonly");
      textarea.style.position = "absolute";
      textarea.style.left = "-9999px";
      document.body.appendChild(textarea);
      textarea.select();

      try {
        document.execCommand("copy");
        resolve();
      } catch (error) {
        reject(error);
      } finally {
        document.body.removeChild(textarea);
      }
    });
  }

  function wrapCvmfsPathsInNode(textNode) {
    var text = textNode.nodeValue;
    var fragment = document.createDocumentFragment();
    var lastIndex = 0;
    var match;
    var pathIndex;
    var pathText;

    cvmfsPathPattern.lastIndex = 0;

    while ((match = cvmfsPathPattern.exec(text))) {
      pathIndex = match.index + match[1].length;
      pathText = match[2];

      if (pathIndex > lastIndex) {
        fragment.appendChild(document.createTextNode(text.slice(lastIndex, pathIndex)));
      }

      var marker = document.createElement("span");
      marker.className = "cvmfs-inline-path";
      marker.textContent = pathText;
      fragment.appendChild(marker);
      lastIndex = pathIndex + pathText.length;
    }

    if (lastIndex < text.length) {
      fragment.appendChild(document.createTextNode(text.slice(lastIndex)));
    }

    textNode.parentNode.replaceChild(fragment, textNode);
  }

  function enhanceCvmfsPaths(root) {
    var walker;
    var current;
    var textNodes = [];

    if (!root) {
      return;
    }

    walker = document.createTreeWalker(root, NodeFilter.SHOW_TEXT, null);

    while ((current = walker.nextNode())) {
      if (!current.nodeValue || current.nodeValue.indexOf("/cvmfs") === -1) {
        continue;
      }

      if (!current.parentElement) {
        continue;
      }

      if (current.parentElement.closest(".cvmfs-inline-path, .code-copy-button")) {
        continue;
      }

      textNodes.push(current);
    }

    textNodes.forEach(wrapCvmfsPathsInNode);
  }

  document.querySelectorAll(".rst-content code").forEach(function (code) {
    if (code.closest("pre") || code.classList.contains("cvmfs-inline-path")) {
      return;
    }

    if (/^\s*\/cvmfs(?:\/|$)/.test(code.textContent.trim())) {
      code.classList.add("cvmfs-inline-path");
      return;
    }

    enhanceCvmfsPaths(code);
  });

  document.querySelectorAll(selector).forEach(function (node) {
    if (node.dataset.codeEnhanced === "true") {
      return;
    }

    var block = node;
    var pre = node;

    if (node.tagName !== "PRE") {
      pre = node.querySelector("pre");
    }

    if (node.tagName === "PRE") {
      block = document.createElement("div");
      block.className = "code-block";
      node.parentNode.insertBefore(block, node);
      block.appendChild(node);
    }

    var code = pre && pre.querySelector("code");
    if (!pre || !code) {
      return;
    }

    node.dataset.codeEnhanced = "true";
    block.dataset.codeEnhanced = "true";
    block.classList.add("code-block");

    var wrapper = document.createElement("div");
    wrapper.className = "code-block-wrap";
    block.parentNode.insertBefore(wrapper, block);
    wrapper.appendChild(block);

    var sourceText = code.textContent.replace(/\u00a0/g, " ").replace(/\n$/, "");
    enhanceCvmfsPaths(code);

    var copyButton = document.createElement("button");
    copyButton.type = "button";
    copyButton.className = "code-copy-button";
    copyButton.setAttribute("aria-label", "Copy code to clipboard");
    copyButton.setAttribute("title", "Copy code to clipboard");

    copyButton.addEventListener("click", function () {
      copyText(sourceText)
        .then(function () {
          copyButton.setAttribute("data-copied", "true");
          copyButton.setAttribute("aria-label", "Copied to clipboard");
          copyButton.setAttribute("title", "Copied to clipboard");

          window.setTimeout(function () {
            copyButton.removeAttribute("data-copied");
            copyButton.setAttribute("aria-label", "Copy code to clipboard");
            copyButton.setAttribute("title", "Copy code to clipboard");
          }, 1800);
        })
        .catch(function () {
          copyButton.setAttribute("aria-label", "Copy failed");
          copyButton.setAttribute("title", "Copy failed");
          window.setTimeout(function () {
            copyButton.setAttribute("aria-label", "Copy code to clipboard");
            copyButton.setAttribute("title", "Copy code to clipboard");
          }, 1800);
        });
    });

    wrapper.appendChild(copyButton);
  });
});