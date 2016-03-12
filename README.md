### CernVM-FS Documentation

This contains the rST sources and image assets for the CernVM-FS user documentation.

[![Documentation Status](https://readthedocs.org/projects/cvmfs/badge/?version=latest)](http://cvmfs.readthedocs.org/en/latest/?badge=latest)

#### Building the HTML documentation

The [official CernVM-FS documentation](http://cvmfs.readthedocs.org/en/latest/) is built automatically by [readthedocs.org](https://readthedocs.org). Nevertheless, one can easily build it locally for editing purposes or different output formats. 

The build requirements for the documentation are [Sphinx](http://sphinx-doc.org) and the [Sphinx RTD theme](https://github.com/snide/sphinx_rtd_theme). Both of which can be conveniently installed via `pip`:

```bash
pip install Sphinx sphinx_rtd_theme
```

Afterwards a simple `make html` in this repository's root directory generates the documentation in `_build/html/`. Opening `_build/html/index.html` in any browser is enough.

