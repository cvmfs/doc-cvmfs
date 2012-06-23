
.PHONY: clean draft preview 

BIBSRC = references.bib
PKGSRC = packages.tex
TEXSRC = cvmfstech.tex \
  cpt-overview.tex \
  cpt-quickstart.tex \
  cpt-install.tex \
  cpt-squid.tex \
  cpt-repo.tex \
  cpt-details.tex \
  apx-rpms.tex
FIGSRC = figures/cernlogo.tex \
  figures/cvmfs.pdf \
  figures/cdrom-orange.pdf \
  figures/webserver.pdf \
  figures/releasemanager.pdf \
  figures/sqlite.pdf \
  figures/cache.pdf \
  figures/memcache.png \
  figures/cernvm.png \
  figures/fingerprint.pdf \
  figures/sign-cert.pdf \
  figures/sign.pdf
TIKZSRC = figures/concept-generic.tex \
  figures/comparison.tex \
  figures/fuse.tex \
  figures/install.tex \
  figures/cvmfs-blocks.tex \
  figures/nestedcatalogs.tex \
  figures/security.tex \
  figures/cvmfs-keepalive.tex \
  figures/vfsfilter.tex
SOURCES = $(TEXSRC) $(BIBSRC) $(TIKZSRC) $(FIGSRC)
MAINFILE = cvmfstech

all: cvmfstech.pdf

cvmfstech.pdf: $(SOURCES) 
	pdflatex -interaction=batchmode $(MAINFILE) > /dev/null
	bibtex $(MAINFILE) | grep -i warning || true
	makeindex $(MAINFILE).idx
	pdflatex -interaction=batchmode $(MAINFILE) > /dev/null
	pdflatex -interaction=batchmode $(MAINFILE) | grep -i 'overful|underful' || true
	thumbpdf $(MAINFILE)
	pdflatex -interaction=batchmode $(MAINFILE) > /dev/null

draft: $(SOURCES) 
	head -n 1 cvmfstech.tex | sed s/final/draft/ > cvmfstech.draft.tex
	tail +2 cvmfstech.tex | sed 's/%_DRAFT//' >> cvmfstech.draft.tex
	pdflatex -interaction=batchmode cvmfstech.draft.tex > /dev/null 
	bibtex cvmfstech.draft | grep -i warning || true
	makeindex cvmfstech.draft.idx
	pdflatex -interaction=batchmode cvmfstech.draft.tex > /dev/null
	pdflatex -interaction=batchmode cvmfstech.draft.tex | grep -i 'overful|underful' || true
	mv cvmfstech.draft.pdf cvmfstech.pdf
	open cvmfstech.pdf
	
preview: $(SOURCES) 
	cat cvmfstech.tex | sed 's/%_DRAFT//' >> cvmfstech.preview.tex
	pdflatex -interaction=batchmode cvmfstech.preview.tex > /dev/null 
	bibtex cvmfstech.preview | grep -i warning || true
	makeindex cvmfstech.preview.idx
	pdflatex -interaction=batchmode cvmfstech.preview > /dev/null
	pdflatex -interaction=batchmode cvmfstech.preview | grep -i 'overful|underful' || true
	#thumbpdf cvmfstech.preview
	#pdflatex -interaction=batchmode cvmfstech.preview > /dev/null
	pdfopt cvmfstech.preview.pdf cvmfstech.preview.pdf.opt
	rm -f cvmfstech.preview.pdf
	mv cvmfstech.preview.pdf.opt cvmfstech.preview.pdf

	
clean:
	rm -f *.aux
	rm -f $(MAINFILE).pdf \
  $(MAINFILE).synctex.gz \
  $(MAINFILE).rai \
  $(MAINFILE).tpt \
  $(MAINFILE).aux \
  $(MAINFILE).bbl \
  $(MAINFILE).blg \
  $(MAINFILE).log \
  $(MAINFILE).out \
  $(MAINFILE).toc \
  $(MAINFILE).idx \
  $(MAINFILE).ind \
  $(MAINFILE).ilg	
	
