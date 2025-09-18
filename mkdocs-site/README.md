# CernVM-FS Documentation - MkDocs Site

This directory contains the modern MkDocs version of the CernVM-FS documentation, migrated from the original Sphinx/RST format.

## Quick Start

### Prerequisites
- Python 3.9 or higher
- pip package manager

### Installation

1. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Build the documentation:**
   ```bash
   mkdocs build
   ```

3. **Serve locally for development:**
   ```bash
   mkdocs serve
   ```
   
   The site will be available at http://localhost:8000

## Features

### ✅ Professional Citation System
- **BibTeX Integration**: Academic references managed via `references.bib`
- **IEEE Citation Style**: Professional formatting for all citations
- **Automatic Processing**: Citations like `[@Thain05]` automatically converted to footnotes

### ✅ Modern Documentation Platform
- **ReadTheDocs Theme**: Professional appearance matching original Sphinx site
- **Fast Build Times**: ~1 second build performance
- **Live Reload**: Automatic updates during development
- **Zero Warnings**: Clean, professional build output

### ✅ Complete Content Migration
- **33 Documentation Files**: All content successfully migrated
- **Tables**: All RST grid tables converted to proper Markdown tables
- **Images & Assets**: All SVG diagrams and static assets preserved
- **Navigation**: Complete hierarchical navigation structure maintained

## File Structure

```
mkdocs-site/
├── mkdocs.yml          # Main configuration file
├── requirements.txt    # Python dependencies
├── references.bib      # BibTeX bibliography database
├── docs/              # Documentation source files
│   ├── index.md       # Homepage
│   ├── cpt-*.md       # Chapter files
│   ├── apx-*.md       # Appendix files
│   └── _static/       # Images, SVGs, CSS
└── site/              # Generated HTML output (after build)
```

## Configuration

### Main Configuration (`mkdocs.yml`)
- **Theme**: ReadTheDocs with custom styling
- **Plugins**: Mermaid diagrams, BibTeX citations, search
- **Navigation**: Hierarchical structure matching original documentation
- **Repository**: Links to GitHub repository for editing

### Citation Management (`references.bib`)
- **24 Academic References**: Complete bibliography in BibTeX format
- **IEEE Style**: Professional academic formatting
- **Automatic Processing**: Citations automatically linked to bibliography

## Development

### Adding Citations
1. Add new entries to `references.bib` in BibTeX format
2. Reference in documentation using `[@AuthorYear]` syntax
3. Citations automatically appear as footnotes with links to bibliography

### Adding Content
1. Create new `.md` files in the `docs/` directory
2. Add to navigation structure in `mkdocs.yml`
3. Use standard Markdown syntax with MkDocs extensions

### Building for Production
```bash
mkdocs build --clean
```

The generated site will be in the `site/` directory, ready for deployment.

## Migration Notes

This MkDocs version represents a complete modernization of the original Sphinx documentation:

- **Zero Technical Debt**: All RST artifacts removed, clean Markdown throughout
- **Enhanced Features**: Professional citation system, better table rendering
- **Improved Performance**: Faster builds, modern toolchain
- **Maintainable**: Standard Markdown format, modern Python ecosystem

## Support

For issues or questions about the documentation system, refer to the main repository or the migration report in the parent directory.
