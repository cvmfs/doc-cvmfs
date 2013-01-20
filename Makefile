
.PHONY: clean draft preview 

VERSION = 2.1-0

BIBSRC = references.bib
PKGSRC = packages.tex
TEXSRC = cvmfstech.tex \
  cpt-overview.tex \
  cpt-quickstart.tex \
  cpt-configure.tex \
  cpt-squid.tex \
  cpt-repo.tex \
  cpt-details.tex \
  apx-rpms.tex \
  apx-parameters.tex
FIGSRC = figures/cernlogo.tex \
  figures/cvmfs.pdf \
  figures/webserver.pdf \
  figures/releasemanager.pdf \
  figures/sqlite.pdf \
  figures/cache.pdf \
  figures/memcache.png \
  figures/cernvm.png \
  figures/fingerprint.pdf \
  figures/sign-cert.pdf \
  figures/sign.pdf
TIKZSRC = gnuplot-lua-tikz.tex gnuplot-lua-tikz.sty gnuplot-lua-tikz-common.tex \
  figures/concept-generic.tex \
  figures/fuse.tex \
  figures/install.tex \
  figures/cvmfs-blocks.tex \
  figures/nestedcatalogs.tex \
  figures/security.tex \
  figures/cvmfs-keepalive.tex \
  figures/vfsfilter.tex
SOURCES = $(TEXSRC) $(PKGSRC) $(BIBSRC) $(TIKZSRC) $(FIGSRC)
MAINFILE = cvmfstech

all: $(MAINFILE)-$(VERSION).pdf

$(MAINFILE)-$(VERSION).pdf: $(SOURCES)
	sed 's/---VERSION---/$(VERSION)/' $(MAINFILE).tex > $(MAINFILE).tmp.tex
	pdflatex -interaction=batchmode $(MAINFILE).tmp > /dev/null
	bibtex $(MAINFILE).tmp | grep -i warning || true
	makeindex $(MAINFILE).tmp.idx
	pdflatex -interaction=batchmode $(MAINFILE).tmp > /dev/null
	pdflatex -interaction=batchmode $(MAINFILE).tmp | grep -i 'overful|underful' || true
	thumbpdf $(MAINFILE).tmp
	pdflatex -interaction=batchmode $(MAINFILE).tmp > /dev/null
	mv $(MAINFILE).tmp.pdf $(MAINFILE)-$(VERSION).pdf

clean:
	rm -f *.aux *.log figures/*.log
	rm -f $(MAINFILE).tmp* $(MAINFILE)*.pdf \
  $(MAINFILE)*.synctex.gz \
  $(MAINFILE)*.rai \
  $(MAINFILE)*.tpt \
  $(MAINFILE)*.aux \
  $(MAINFILE)*.bbl \
  $(MAINFILE)*.blg \
  $(MAINFILE)*.log \
  $(MAINFILE)*.out \
  $(MAINFILE)*.toc \
  $(MAINFILE)*.idx \
  $(MAINFILE)*.ind \
  $(MAINFILE)*.ilg	
	
