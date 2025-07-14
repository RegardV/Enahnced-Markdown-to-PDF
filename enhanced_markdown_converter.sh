#!/bin/bash
# Created by Regard Vermeulen realandworks.com - inkypyrus 2025-07-14
# Enhanced Eisvogel Markdown to PDF Converter - FIXED VERSION
# Version: 7.0 - Fixes list formatting and double header issues

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INPUT_DIR="${1:-$SCRIPT_DIR}"
OUTPUT_DIR="${INPUT_DIR}/PDFs"
LOG_FILE="${OUTPUT_DIR}/conversion.log"
TEMPLATE_DIR="$HOME/.local/share/pandoc/templates"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Create directories
mkdir -p "$OUTPUT_DIR" "$TEMPLATE_DIR"

# Initialize log
cat > "$LOG_FILE" << LOGEOF
=== Fixed Eisvogel Markdown to PDF Conversion Log ===
Started: $(date)
Pandoc Version: $(pandoc --version | head -n1)
System: $(uname -a)

LOGEOF

# FIXED: Enhanced preprocessing that addresses both list formatting and header duplication
preprocess_document() {
    local input_file="$1"
    local temp_file="${input_file}.tmp"
    
    echo "Preprocessing: $input_file" >> "$LOG_FILE"
    
    # Step 1: Fix list formatting by ensuring blank lines before lists
    # This is crucial for proper list rendering in Pandoc
    awk '
    BEGIN { 
        first_step = 1 
        in_yaml = 0
        yaml_ended = 0
        prev_line = ""
        in_list = 0
    }
    
    # Track YAML front matter
    /^---$/ {
        if (!yaml_ended) {
            if (in_yaml) {
                yaml_ended = 1
                in_yaml = 0
            } else {
                in_yaml = 1
            }
        }
        print $0
        prev_line = $0
        next
    }
    
    # Handle STEP headers with page breaks (but avoid duplication)
    /^# STEP [0-9]+:/ {
        if (yaml_ended && first_step) {
            first_step = 0
            print $0
        } else if (yaml_ended) {
            print "\\newpage"
            print ""
            print $0
        } else {
            print $0
        }
        prev_line = $0
        next
    }
    
    # Detect start of lists and ensure blank line before them
    /^[[:space:]]*[-*+][[:space:]]/ || /^[[:space:]]*[0-9]+\.[[:space:]]/ || /^[[:space:]]*- \[[ x]\]/ {
        # If previous line was not blank and we are starting a list
        if (prev_line != "" && prev_line !~ /^[[:space:]]*$/ && !in_list) {
            print ""  # Add blank line before list
            in_list = 1
        }
        print $0
        prev_line = $0
        next
    }
    
    # Reset list tracking when we encounter non-list lines
    !/^[[:space:]]*[-*+][[:space:]]/ && !/^[[:space:]]*[0-9]+\.[[:space:]]/ && !/^[[:space:]]*- \[[ x]\]/ && !/^[[:space:]]*$/ {
        if (in_list && $0 !~ /^[[:space:]]*/) {
            in_list = 0
        }
    }
    
    # Handle all other lines
    {
        if ($0 !~ /^# STEP [0-9]+:/ && $0 !~ /^---$/) {
            print $0
            prev_line = $0
        }
    }
    ' "$input_file" > "${temp_file}.list_fixed"
    
    # Step 2: Sanitize emojis for LaTeX compatibility (keep minimal set)
    sed -e 's/✅/[✓]/g' \
        -e 's/❌/[✗]/g' \
        -e 's/⚠️/[!]/g' \
        -e 's/🔄/[↻]/g' \
        -e 's/📋/[📋]/g' \
        -e 's/🔍/[🔍]/g' \
        -e 's/💡/[💡]/g' \
        -e 's/🎯/[🎯]/g' \
        -e 's/🚀/[🚀]/g' \
        -e 's/📱/[📱]/g' \
        -e 's/💻/[💻]/g' \
        -e 's/🌐/[🌐]/g' \
        -e 's/📁/[📁]/g' \
        -e 's/🎉/[🎉]/g' \
        -e 's/💰/[💰]/g' \
        -e 's/📞/[📞]/g' \
        -e 's/🛠️/[🛠]/g' \
        -e 's/⭐/[⭐]/g' \
        "${temp_file}.list_fixed" > "$temp_file"
    
    # Clean up intermediate file
    rm -f "${temp_file}.list_fixed"
    
    echo "Preprocessing completed successfully" >> "$LOG_FILE"
    echo "$temp_file"
}

# FIXED: Optimized Eisvogel conversion with proper list support
convert_with_eisvogel() {
    local input_file="$1"
    local output_file="$2"
    
    echo "Starting Eisvogel conversion..." >> "$LOG_FILE"
    
    # Use optimized Eisvogel parameters that work better with lists
    pandoc "$input_file" \
        -o "$output_file" \
        --template=eisvogel \
        --pdf-engine=xelatex \
        --from=markdown+yaml_metadata_block \
        --listings \
        -V documentclass=report \
        -V classoption=oneside \
        -V code-block-font-size='\footnotesize' \
        -V geometry:margin=0.8in \
        -V mainfont="Liberation Serif" \
        -V sansfont="Liberation Sans" \
        -V monofont="Liberation Mono" \
        -V mainfontoptions="Numbers=OldStyle,Numbers=Proportional" \
        -V colorlinks=true \
        -V linkcolor="blue!80!black" \
        -V urlcolor="blue!80!black" \
        -V toccolor="blue!80!black" \
        -V titlepage=true \
        -V titlepage-color="F8F9FA" \
        -V titlepage-text-color="2C3E50" \
        -V titlepage-rule-color="34495E" \
        -V titlepage-rule-height=2 \
        -V logo="" \
        -V header-left="" \
        -V header-center="" \
        -V header-right="\rightmark" \
        -V footer-left="\leftmark" \
        -V footer-center="" \
        -V footer-right="\thepage" \
        -V book=true \
        -V chapters=true \
        -V disable-header-and-footer=false \
        --toc \
        --toc-depth=3 \
        --number-sections \
        --highlight-style=tango \
        --standalone \
        --metadata date="$(date '+%B %d, %Y')" \
        2>>"$LOG_FILE"
        
    local exit_code=$?
    echo "Eisvogel conversion exit code: $exit_code" >> "$LOG_FILE"
    return $exit_code
}

# Main conversion function with improved error handling
convert_file_enhanced() {
    local input_file="$1"
    local filename=$(basename "$input_file")
    filename="${filename%.md}"
    filename="${filename%.MD}"
    local output_file="$OUTPUT_DIR/${filename}.pdf"
    
    echo -e "${BLUE}🔄 Converting:${NC} $(basename "$input_file")"
    echo "Processing: $input_file" >> "$LOG_FILE"
    
    # Preprocess file (fix lists and sanitize emojis)
    local processed_file=$(preprocess_document "$input_file")
    
    if [ ! -f "$processed_file" ]; then
        echo -e "${RED}❌ Preprocessing failed:${NC} $input_file"
        echo "ERROR: Preprocessing failed - $input_file" >> "$LOG_FILE"
        return 1
    fi
    
    # Method 1: Fixed Eisvogel conversion
    echo -e "${YELLOW}   📚 Method 1: Eisvogel template (with list fixes)...${NC}"
    if convert_with_eisvogel "$processed_file" "$output_file"; then
        if [ -f "$output_file" ] && [ -s "$output_file" ]; then
            echo -e "${GREEN}✅ Eisvogel conversion successful:${NC} ${filename}.pdf"
            echo "SUCCESS: Eisvogel method - $input_file -> ${filename}.pdf" >> "$LOG_FILE"
            rm -f "$processed_file"
            return 0
        else
            echo -e "${RED}❌ Output file not created or empty${NC}"
            echo "ERROR: Output file not created or empty - $output_file" >> "$LOG_FILE"
        fi
    else
        echo -e "${RED}❌ Eisvogel conversion failed${NC}"
        echo "ERROR: Eisvogel conversion failed - $input_file" >> "$LOG_FILE"
    fi
    
    echo -e "${RED}❌ Conversion failed:${NC} $input_file"
    echo "FAILED: $input_file" >> "$LOG_FILE"
    rm -f "$processed_file"
    return 1
}

# Check system requirements with detailed feedback
check_requirements() {
    echo -e "${CYAN}🔍 Checking system requirements...${NC}"
    
    local missing_count=0
    local issues=()
    
    # Check Pandoc
    if ! command -v pandoc >/dev/null 2>&1; then
        echo -e "${RED}❌ pandoc not found${NC}"
        issues+=("pandoc not installed")
        missing_count=$((missing_count + 1))
    else
        local pandoc_version=$(pandoc --version | head -n1)
        echo -e "${GREEN}✅ pandoc found:${NC} $pandoc_version"
    fi
    
    # Check XeLaTeX
    if ! command -v xelatex >/dev/null 2>&1; then
        echo -e "${RED}❌ xelatex not found${NC}"
        issues+=("xelatex not installed")
        missing_count=$((missing_count + 1))
    else
        echo -e "${GREEN}✅ xelatex found${NC}"
    fi
    
    # Check Eisvogel template
    local template_found=false
    if [ -f "$HOME/.local/share/pandoc/templates/eisvogel.latex" ]; then
        template_found=true
        echo -e "${GREEN}✅ Eisvogel template found:${NC} ~/.local/share/pandoc/templates/eisvogel.latex"
    elif [ -f "/usr/share/pandoc/data/templates/eisvogel.latex" ]; then
        template_found=true
        echo -e "${GREEN}✅ Eisvogel template found:${NC} /usr/share/pandoc/data/templates/eisvogel.latex"
    else
        echo -e "${RED}❌ Eisvogel template not found${NC}"
        issues+=("Eisvogel template not installed")
        missing_count=$((missing_count + 1))
    fi
    
    # Check fonts
    if fc-list | grep -q "Liberation"; then
        echo -e "${GREEN}✅ Liberation fonts found${NC}"
    else
        echo -e "${YELLOW}⚠️  Liberation fonts not found (will use defaults)${NC}"
    fi
    
    if [ $missing_count -gt 0 ]; then
        echo -e "${RED}❌ Missing essential requirements:${NC}"
        for issue in "${issues[@]}"; do
            echo -e "${RED}  - $issue${NC}"
        done
        echo ""
        echo -e "${BLUE}To fix these issues:${NC}"
        echo -e "${BLUE}  sudo apt install pandoc texlive-xetex texlive-latex-extra fonts-liberation${NC}"
        echo -e "${BLUE}  # Download eisvogel.latex from: https://github.com/Wandmalfarbe/pandoc-latex-template${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✅ All requirements met${NC}"
    return 0
}

# Main execution
main() {
    echo -e "${CYAN}🚀 Fixed Eisvogel Markdown to PDF Converter${NC}"
    echo -e "${CYAN}===========================================${NC}"
    echo -e "${BLUE}Version 7.0 - Fixes list formatting and header duplication${NC}"
    echo ""
    
    # Check requirements
    if ! check_requirements; then
        echo -e "${RED}Please install missing requirements first${NC}"
        exit 1
    fi
    
    echo ""
    
    # Process all markdown files (excluding temporary and test files)
    local count=0
    local success=0
    
    for file in "$INPUT_DIR"/*.md "$INPUT_DIR"/*.MD; do
        # Skip if file doesn't exist or is a temporary/test file
        if [ ! -f "$file" ] || [[ "$file" == *.tmp ]] || [[ "$file" == *temp* ]] || [[ "$file" == *test* ]]; then
            continue
        fi
        
        count=$((count + 1))
        if convert_file_enhanced "$file"; then
            success=$((success + 1))
        fi
    done
    
    if [ $count -eq 0 ]; then
        echo -e "${YELLOW}⚠️  No markdown files found in $INPUT_DIR${NC}"
        echo -e "${BLUE}Usage: $0 [directory_with_md_files]${NC}"
        return 1
    fi
    
    echo ""
    echo -e "${CYAN}📊 Conversion Summary:${NC}"
    echo -e "${GREEN}✅ Successful: $success${NC}"
    echo -e "${RED}❌ Failed: $((count - success))${NC}"
    echo -e "${BLUE}📁 Output directory: $OUTPUT_DIR${NC}"
    echo -e "${PURPLE}📝 Log file: $LOG_FILE${NC}"
    
    # Show success rate
    if [ $success -eq $count ]; then
        echo -e "${GREEN}🎉 Perfect! All documents converted successfully!${NC}"
        echo -e "${BLUE}✅ Lists now render properly as actual lists${NC}"
        echo -e "${BLUE}✅ No more double header printing${NC}"
        echo -e "${BLUE}✅ STEP headers start on new pages${NC}"
        echo -e "${BLUE}✅ Professional Eisvogel styling applied${NC}"
    elif [ $success -gt 0 ]; then
        echo -e "${YELLOW}✨ Partial success: $success out of $count documents converted${NC}"
        echo -e "${BLUE}Check the log file for details: $LOG_FILE${NC}"
    else
        echo -e "${RED}💥 No documents were converted successfully${NC}"
        echo -e "${BLUE}Check the log file for errors: $LOG_FILE${NC}"
    fi
    
    # List created PDFs
    if [ $success -gt 0 ]; then
        echo ""
        echo -e "${CYAN}📚 Created PDFs:${NC}"
        ls -la "$OUTPUT_DIR"/*.pdf 2>/dev/null | while read -r line; do
            echo -e "${GREEN}✓${NC} $line"
        done
    fi
}

# Run main function
main "$@"
