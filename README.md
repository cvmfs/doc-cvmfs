### CernVM-FS Documentation

This repository contains the canonical MkDocs sources and static assets for the CernVM-FS user documentation.

[![Documentation Status](https://readthedocs.org/projects/cvmfs/badge/?version=latest)](http://cvmfs.readthedocs.org/en/latest/?badge=latest)

#### Building the documentation locally

Install the Python dependencies:

```bash
pip install -r requirements.txt
```

Build the site from the repository root:

```bash
mkdocs build
```

or:

```bash
make build
```

Serve the site locally for editing:

```bash
mkdocs serve
```

or:

```bash
make serve
```

The generated HTML output is written to `site/`.

PDF/EPUB automation is not currently provided by the root MkDocs setup. Read the Docs only offers built-in offline formats for Sphinx projects, and this repository does not yet define a separate MkDocs-compatible PDF/EPUB toolchain.

