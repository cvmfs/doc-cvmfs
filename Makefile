
.PHONY: clean draft preview open 
SOURCES = cvmfstech.tex packages.tex apx-rpms.tex cpt-install.tex apx-crowdcache.tex cpt-overview.tex cpt-quickstart.tex cpt-details.tex cpt-benchmarks.tex apx-releasemgr.tex install.tex comparsion.tex concept.tex cvmfs-scvmfs.tex cvmfs-blocks.tex cernlogo.tex buildserver.pdf reposerver.pdf webserver.pdf infra.pdf cvmfs.pdf cvmfs-wo-memcached.pdf cvmfs-wi-memcached.pdf switch.pdf memcached-step1.tex memcached-step2.tex memcached-step3.tex mem.pdf crowdcache.tex vfsfilter.tex warmcache.tex references.bib cdrom-orange.pdf releasemanager.pdf memcache.png sqlite.pdf cache.pdf cernvm.png fingerprint.pdf sign-cert.pdf sign.pdf

all: cvmfstech.pdf

cvmfstech.pdf: $(SOURCES) 
	pdflatex -interaction=batchmode cvmfstech > /dev/null
	bibtex cvmfstech | grep -i warning || true
	makeindex cvmfstech.idx
	pdflatex -interaction=batchmode cvmfstech > /dev/null
	pdflatex -interaction=batchmode cvmfstech | grep -i 'overful|underful' || true
	#thumbpdf cvmfstech
	#pdflatex -interaction=batchmode cvmfstech > /dev/null
	#pdfopt cvmfstech.pdf cvmfstech.pdf.opt
	#rm -f cvmfstech.pdf
	#mv cvmfstech.pdf.opt cvmfstech.pdf

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

	
open: cvmfstech.pdf
	open cvmfstech.pdf

clean:
	rm -f cvmfstech.pdf cvmfstech.synctex.gz cvmfstech.tpt cvmfstech.aux cvmfstech.bbl cvmfstech.blg cvmfstech.log cvmfstech.out cvmfstech.toc cvmfstech.idx cvmfstech.ind cvmfstech.ilg packages.aux packages.log flow-mount.aux flow-mount.log flow-mount.out flow-mount.synctex.gz flow-mount.pdf cvmfstech.rai
	rm -f cvmfstech.draft.tex cvmfstech.draft.aux cvmfstech.draft.log cvmfstech.draft.out cvmfstech.draft.toc cvmfstech.draft.blg cvmfstech.draft.bbl cvmfstech.draft.idx cvmfstech.draft.ind cvmfstech.draft.ilg cvmfstech.draft.pdf cvmfstech.draft.rai
	rm -f cvmfstech.preview.tex cvmfstech.preview.synctex.gz cvmfstech.preview.tpt cvmfstech.preview.aux cvmfstech.preview.bbl cvmfstech.preview.blg cvmfstech.preview.log cvmfstech.preview.out cvmfstec.preview.toc cvmfstech.preview.idx cvmfstech.preview.ind cvmfstech.preview.ilg cvmfstech.preview.rai
	rm -f bandwidth.tex latency.tex
	rm -f *.aux
	
