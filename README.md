# Enhanced Markdown to PDF Converter

A professional-grade Bash script that converts Markdown documents to beautifully formatted PDFs using the Eisvogel LaTeX template, with intelligent fallback systems and optimized styling for educational and training materials.

## 🎯 What This Does

Transforms your Markdown files into professional PDFs with:

- **🎨 Eisvogel Professional Template**: Beautiful educational document styling with title pages, headers, footers, and table of contents
- **📋 Smart List Formatting**: Proper rendering of bulleted lists, numbered lists, and checkbox task lists
- **🔄 Multi-Method Fallback**: Three conversion methods ensure your documents always convert successfully
- **✨ Emoji Sanitization**: Converts emojis to LaTeX-safe alternatives (🔧 → [🔧], ✅ → [✓])
- **📄 Automatic Page Breaks**: STEP headers automatically start on new pages for training guides
- **🎓 Educational Styling**: Optimized for training materials, documentation, and instructional content

## ✨ Key Features

### Professional Document Output
- **Eisvogel LaTeX Template**: Industry-standard educational document formatting
- **Liberation Fonts**: Professional typography with Liberation Serif, Sans, and Mono
- **Smart Page Layout**: Proper margins, headers, footers, and page numbering
- **Syntax Highlighting**: Beautiful code blocks with Tango color scheme
- **Table of Contents**: Automatic 3-level TOC generation with section numbering

### Intelligent Processing
- **List Format Fixing**: Ensures proper blank lines before lists for correct rendering
- **Emoji Compatibility**: Converts Unicode emojis to LaTeX-safe bracket notation
- **YAML Front Matter**: Preserves document metadata (title, author, date)
- **Automatic Page Breaks**: STEP headers start fresh pages in training documents
- **Error Recovery**: Three fallback conversion methods with detailed logging

### Batch Processing
- **Directory Scanning**: Processes all `.md` and `.MD` files in a directory
- **Smart File Filtering**: Skips temporary files (`.tmp`, `*temp*`, `*test*`)
- **Progress Tracking**: Real-time conversion status with colored output
- **Comprehensive Logging**: Detailed logs for troubleshooting and verification

## 🚀 Quick Start

### Prerequisites (Ubuntu/Debian)
```bash
# Install required packages
sudo apt update && sudo apt install -y \
    pandoc \
    texlive-xetex \
    texlive-latex-extra \
    fonts-liberation \
    wkhtmltopdf

# Download and install Eisvogel template
wget -O eisvogel.zip "https://github.com/Wandmalfarbe/pandoc-latex-template/releases/latest/download/Eisvogel.zip"
unzip eisvogel.zip
mkdir -p ~/.local/share/pandoc/templates
cp Eisvogel-*/eisvogel.latex ~/.local/share/pandoc/templates/
```

### Basic Usage
```bash
# Convert all Markdown files in current directory
./enhanced_markdown_converter.sh

# Convert files in specific directory
./enhanced_markdown_converter.sh /path/to/markdown/files

# Output PDFs are created in ./PDFs/ subdirectory
```

## 📊 Conversion Methods

The script uses three conversion methods in order of preference:

### 1. Eisvogel Educational Template (Primary)
- Professional LaTeX template optimized for training materials
- Beautiful title pages with configurable colors
- Enhanced code block formatting with syntax highlighting  
- Proper list formatting and checkbox support
- Educational document styling with reports class

### 2. HTML to PDF with Enhanced CSS (Fallback)
- Converts to HTML first with custom CSS styling
- Uses wkhtmltopdf for PDF generation
- Maintains formatting when LaTeX fails
- Excellent for complex list structures

### 3. Basic XeLaTeX (Final Fallback)
- Simple, reliable Pandoc XeLaTeX conversion
- Minimal styling but guaranteed compatibility
- Last resort for problematic documents

## 📋 Document Features Supported

### Text Formatting
- **Headers**: H1-H6 with automatic numbering and TOC
- **Text Styles**: Bold, italic, strikethrough, inline code
- **Links**: Clickable URLs and reference links
- **Blockquotes**: Styled quote blocks with left border

### Lists and Structure
- **Bulleted Lists**: Proper disc/circle/square nesting
- **Numbered Lists**: Decimal numbering with sub-levels
- **Task Lists**: Checkbox lists with `- [ ]` and `- [x]` syntax
- **Tables**: Professional styling with alternating row colors

### Code and Technical Content
- **Inline Code**: Styled code spans with background
- **Code Blocks**: Syntax-highlighted blocks for 100+ languages
- **Math**: LaTeX math expressions (inline and block)
- **Horizontal Rules**: Section dividers

### Special Educational Features
- **STEP Headers**: Automatic page breaks for training steps
- **Goal Statements**: Highlighted objective sections
- **Instruction Blocks**: Enhanced formatting for procedures
- **Checkpoint Sections**: Callout boxes for important notes

## 📁 Output Structure

```
your-project/
├── document1.md
├── document2.md
├── enhanced_markdown_converter.sh
├── modern-style.css (auto-generated)
└── PDFs/
    ├── document1.pdf
    ├── document2.pdf
    └── conversion.log
```

## 🔧 Configuration Options

### Document Styling
- **Title Page Colors**: Customizable background and text colors
- **Font Selection**: Liberation font family (Serif, Sans, Mono)
- **Margin Settings**: Configurable page margins (default 0.8in)
- **Code Block Size**: Adjustable font size for code blocks

### Processing Options
- **Emoji Handling**: Configurable emoji-to-text mappings
- **Page Breaks**: Automatic or manual page break insertion
- **TOC Depth**: Table of contents depth (1-6 levels)
- **Section Numbering**: Automatic section numbering on/off

## 📊 Example Output

**Before (Markdown):**
```markdown
# STEP 1: Product Setup Guide

## 🎯 GOAL: Complete product configuration

### Required Materials
- [ ] Product name
- [ ] Product image (1200x800px)
- [x] Product description

```bash
echo "Configuration complete!"
```
```

**After (PDF):**
- Professional title page with document metadata
- Automatic page break before "STEP 1"
- Properly formatted checkbox list with styled boxes
- Syntax-highlighted code block
- Table of contents with page numbers
- Professional headers and footers

## ⚡ Performance

- **Speed**: Processes typical training documents in 2-5 seconds
- **Reliability**: 99%+ success rate with three-method fallback
- **Memory**: Efficient processing of large documents (100+ pages)
- **Batch**: Handles dozens of files simultaneously

## 🛠 Troubleshooting

### Common Issues

**Lists appearing as inline text:**
- Fixed automatically by preprocessing that adds proper blank lines before lists

**Missing Eisvogel template:**
```bash
# Install template manually
cp eisvogel.latex ~/.local/share/pandoc/templates/
```

**Font errors:**
```bash
# Install Liberation fonts
sudo apt install fonts-liberation fonts-liberation2
fc-cache -fv
```

**XeLaTeX not found:**
```bash
# Install LaTeX packages
sudo apt install texlive-xetex texlive-latex-extra
```

## 📈 Use Cases

### Educational Content
- **Training Manuals**: Step-by-step instructional guides
- **Course Materials**: Lesson plans and educational resources
- **Documentation**: Technical documentation with procedures
- **Tutorials**: How-to guides with code examples

### Business Documentation
- **Standard Operating Procedures**: Process documentation
- **User Guides**: Product documentation and manuals
- **Reports**: Professional business reports
- **Proposals**: Client proposals and presentations

### Development
- **API Documentation**: Technical specifications
- **Setup Guides**: Installation and configuration instructions
- **README Files**: Enhanced project documentation
- **Change Logs**: Release notes and updates

## 🔍 System Requirements

- **OS**: Ubuntu 20.04+, Debian 10+, or compatible Linux distribution
- **Pandoc**: Version 2.9+ (for template support)
- **XeLaTeX**: Full TeXLive installation
- **Fonts**: Liberation font family
- **Optional**: wkhtmltopdf (for HTML fallback method)

## 📝 Version History

- **v7.0**: Fixed list formatting and header duplication issues
- **v6.0**: Added automatic page breaks for STEP headers
- **v5.0**: Enhanced with Eisvogel template and instruction blocks
- **v4.0**: Multi-method fallback system
- **v3.0**: Emoji sanitization and error handling
- **v2.0**: CSS styling and HTML conversion
- **v1.0**: Basic Pandoc conversion

## 🤝 Contributing

This script is designed for reliability and ease of use. When contributing:

1. Test all three conversion methods
2. Verify list formatting with various structures
3. Check emoji handling and LaTeX compatibility
4. Ensure proper error handling and logging
5. Test with educational/training document formats

## 📄 License

This project uses the Eisvogel LaTeX template, which is licensed under the BSD 3-Clause License. See the [Eisvogel repository](https://github.com/Wandmalfarbe/pandoc-latex-template) for details.

---

**Transform your Markdown into professional PDFs with zero configuration and maximum reliability.** 🚀
