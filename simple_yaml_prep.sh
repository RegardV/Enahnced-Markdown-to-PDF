#!/bin/bash
# YAML Preparer with Edit Functionality - Fixed Input Handling
# Version: 1.3 - Keeps all requested features but fixes hanging

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INPUT_DIR="${1:-$SCRIPT_DIR}"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}🎯 YAML Preparer with Edit Functionality${NC}"
echo -e "${CYAN}=========================================${NC}"
echo "Looking for .md files in: $INPUT_DIR"
echo ""

# Function to get color description
get_color_description() {
    case "${1^^}" in
        # PROFESSIONAL LIGHT BACKGROUNDS (for title pages)
        "F8F9FA") echo "Light Gray (very light, almost white)" ;;
        "FFFFFF") echo "White (pure white)" ;;
        "F0F8FF") echo "Alice Blue (very pale blue)" ;;
        "E8F4FD") echo "Light Blue (pale blue tint)" ;;
        "F5F5F5") echo "White Smoke (light gray)" ;;
        "FFF8DC") echo "Cornsilk (warm off-white)" ;;
        "F0FFF0") echo "Honeydew (very pale green)" ;;
        "FFFAF0") echo "Floral White (warm white)" ;;
        "F0F0F0") echo "Light Gray (neutral)" ;;
        "E0E0E0") echo "Silver (light gray)" ;;
        
        # PROFESSIONAL DARK COLORS (for text - high readability)
        "2C3E50") echo "Dark Blue-Gray (professional dark)" ;;
        "000000") echo "Black (maximum contrast)" ;;
        "333333") echo "Very Dark Gray (almost black)" ;;
        "1F4E79") echo "Dark Blue (corporate style)" ;;
        "5F5F5F") echo "Dark Gray (softer than black)" ;;
        "2F4F4F") echo "Dark Slate Gray (sophisticated)" ;;
        "191970") echo "Midnight Blue (deep professional)" ;;
        "1C1C1C") echo "Dark Charcoal (modern)" ;;
        "2E2E2E") echo "Granite Gray (neutral dark)" ;;
        "0F0F0F") echo "Near Black (subtle)" ;;
        
        # PROFESSIONAL ACCENT COLORS (for rules and highlights)
        "3498DB") echo "Blue (bright professional blue)" ;;
        "4CAF50") echo "Green (success/positive)" ;;
        "435488") echo "Dark Blue-Purple (sophisticated)" ;;
        "2E75B6") echo "Corporate Blue (business style)" ;;
        "FF9800") echo "Orange (energetic)" ;;
        "9C27B0") echo "Purple (creative)" ;;
        "607D8B") echo "Blue Gray (neutral)" ;;
        "E91E63") echo "Pink (modern accent)" ;;
        "00BCD4") echo "Cyan (tech/modern)" ;;
        "795548") echo "Brown (warm professional)" ;;
        "FF5722") echo "Deep Orange (bold)" ;;
        "8BC34A") echo "Light Green (fresh)" ;;
        "FFC107") echo "Amber (attention)" ;;
        "673AB7") echo "Deep Purple (luxury)" ;;
        "009688") echo "Teal (calm professional)" ;;
        
        # CLASSIC WEB COLORS
        "FF0000") echo "Red (classic)" ;;
        "00FF00") echo "Green (classic)" ;;
        "0000FF") echo "Blue (classic)" ;;
        "FFD700") echo "Gold (luxury)" ;;
        "800080") echo "Purple (classic)" ;;
        "FFA500") echo "Orange (classic)" ;;
        "008080") echo "Teal (classic)" ;;
        "0066CC") echo "Blue (web safe)" ;;
        "FFEB3B") echo "Yellow (bright)" ;;
        "CDDC39") echo "Lime (vibrant)" ;;
        
        # SPECIAL PURPOSE COLORS
        "D8DE2C") echo "Yellow-Green (bright lime)" ;;
        "87CEEB") echo "Sky Blue (soft)" ;;
        "DDA0DD") echo "Plum (soft purple)" ;;
        "F0E68C") echo "Khaki (warm neutral)" ;;
        "98FB98") echo "Pale Green (soft)" ;;
        "FFB6C1") echo "Light Pink (soft)" ;;
        "20B2AA") echo "Light Sea Green (aqua)" ;;
        "778899") echo "Light Slate Gray (cool)" ;;
        "B0C4DE") echo "Light Steel Blue (cool)" ;;
        "FAFAD2") echo "Light Goldenrod (warm)" ;;
        
        *) echo "Custom Color" ;;
    esac
}

# Function to show color palette
show_color_palette() {
    echo -e "${CYAN}🎨 Complete Professional Color Palette:${NC}"
    echo ""
    
    echo -e "${BLUE}📄 TITLE PAGE BACKGROUNDS (Light Colors - Good Contrast with Dark Text):${NC}"
    echo -e "  F8F9FA - Light Gray (almost white, very clean) ⭐ RECOMMENDED"
    echo -e "  FFFFFF - White (pure white, classic)"
    echo -e "  F0F8FF - Alice Blue (very pale blue, subtle)"
    echo -e "  E8F4FD - Light Blue (pale blue tint, modern)"
    echo -e "  F5F5F5 - White Smoke (light gray, neutral)"
    echo -e "  FFF8DC - Cornsilk (warm off-white, friendly)"
    echo -e "  F0FFF0 - Honeydew (very pale green, fresh)"
    echo -e "  FFFAF0 - Floral White (warm white, elegant)"
    echo -e "  F0F0F0 - Light Gray (neutral, safe)"
    echo -e "  E0E0E0 - Silver (light gray, modern)"
    echo ""
    
    echo -e "${BLUE}✏️  TEXT COLORS (Dark Colors - Maximum Readability on Light Backgrounds):${NC}"
    echo -e "  2C3E50 - Dark Blue-Gray (professional, easy to read) ⭐ RECOMMENDED"
    echo -e "  000000 - Black (maximum contrast, classic)"
    echo -e "  333333 - Very Dark Gray (almost black, softer)"
    echo -e "  1F4E79 - Dark Blue (corporate style, trustworthy)"
    echo -e "  5F5F5F - Dark Gray (softer than black, modern)"
    echo -e "  2F4F4F - Dark Slate Gray (sophisticated, cool)"
    echo -e "  191970 - Midnight Blue (deep professional, rich)"
    echo -e "  1C1C1C - Dark Charcoal (modern, sleek)"
    echo -e "  2E2E2E - Granite Gray (neutral dark, stable)"
    echo -e "  0F0F0F - Near Black (subtle, refined)"
    echo ""
    
    echo -e "${BLUE}📏 RULE/ACCENT COLORS (Brand Colors - For Decorative Elements):${NC}"
    echo -e "  3498DB - Blue (bright professional blue) ⭐ RECOMMENDED"
    echo -e "  4CAF50 - Green (success/positive, growth)"
    echo -e "  435488 - Dark Blue-Purple (sophisticated, premium)"
    echo -e "  2E75B6 - Corporate Blue (business style, reliable)"
    echo -e "  FF9800 - Orange (energetic, creative)"
    echo -e "  9C27B0 - Purple (creative, innovative)"
    echo -e "  607D8B - Blue Gray (neutral, balanced)"
    echo -e "  E91E63 - Pink (modern accent, friendly)"
    echo -e "  00BCD4 - Cyan (tech/modern, fresh)"
    echo -e "  795548 - Brown (warm professional, stable)"
    echo -e "  FF5722 - Deep Orange (bold, attention)"
    echo -e "  8BC34A - Light Green (fresh, natural)"
    echo -e "  FFC107 - Amber (attention, important)"
    echo -e "  673AB7 - Deep Purple (luxury, premium)"
    echo -e "  009688 - Teal (calm professional, balanced)"
    echo ""
    
    echo -e "${YELLOW}💡 Color Combination Tips:${NC}"
    echo -e "  • SAFE COMBO: F8F9FA (background) + 2C3E50 (text) + 3498DB (accent)"
    echo -e "  • CORPORATE: FFFFFF (background) + 1F4E79 (text) + 2E75B6 (accent)"
    echo -e "  • MODERN: F0F8FF (background) + 333333 (text) + 00BCD4 (accent)"
    echo -e "  • CREATIVE: E8F4FD (background) + 2C3E50 (text) + 9C27B0 (accent)"
    echo -e "  • NATURE: F0FFF0 (background) + 2F4F4F (text) + 4CAF50 (accent)"
    echo ""
    echo -e "${CYAN}📋 Usage Guidelines:${NC}"
    echo -e "  • Background colors should be LIGHT for readability"
    echo -e "  • Text colors should be DARK for high contrast"
    echo -e "  • Accent colors can be BRIGHT for visual interest"
    echo -e "  • Colors are HEX codes without the # symbol"
    echo -e "  • Test combinations for accessibility and professional appearance"
    echo ""
}

# Function to get input using /dev/tty to avoid hanging
safe_read() {
    local prompt="$1"
    local default="$2"
    local result
    
    echo -n -e "${CYAN}$prompt${NC} [${YELLOW}$default${NC}]: " > /dev/tty
    
    # Use /dev/tty for input to avoid pipeline issues
    if read result < /dev/tty; then
        if [ -z "$result" ]; then
            echo "$default"
        else
            echo "$result"
        fi
    else
        # Fallback if /dev/tty fails
        echo "$default"
    fi
}

# Function to extract existing YAML values
extract_existing_yaml() {
    local file="$1"
    local temp_yaml="/tmp/yaml_extract_$$"
    
    # Extract YAML between --- markers
    awk '/^---$/{flag=!flag; if(!flag) exit} flag && !/^---$/' "$file" > "$temp_yaml" 2>/dev/null
    
    # Extract values
    local title=$(grep "^title:" "$temp_yaml" 2>/dev/null | sed 's/^title: *//; s/^"//; s/"$//' || echo "")
    local author=$(grep "^author:" "$temp_yaml" 2>/dev/null | sed 's/^author: *//; s/^"//; s/"$//' || echo "")
    local date_val=$(grep "^date:" "$temp_yaml" 2>/dev/null | sed 's/^date: *//; s/^"//; s/"$//' || echo "")
    local subtitle=$(grep "^subtitle:" "$temp_yaml" 2>/dev/null | sed 's/^subtitle: *//; s/^"//; s/"$//' || echo "")
    local titlepage_color=$(grep "^titlepage-color:" "$temp_yaml" 2>/dev/null | sed 's/^titlepage-color: *//; s/^"//; s/"$//' || echo "")
    local text_color=$(grep "^titlepage-text-color:" "$temp_yaml" 2>/dev/null | sed 's/^titlepage-text-color: *//; s/^"//; s/"$//' || echo "")
    local rule_color=$(grep "^titlepage-rule-color:" "$temp_yaml" 2>/dev/null | sed 's/^titlepage-rule-color: *//; s/^"//; s/"$//' || echo "")
    
    rm -f "$temp_yaml"
    echo "$title|$author|$date_val|$subtitle|$titlepage_color|$text_color|$rule_color"
}

# Function to process a single file
process_file() {
    local file="$1"
    local backup_file="${file}.backup"
    local has_yaml=false
    
    echo -e "${YELLOW}📝 Processing:${NC} $(basename "$file")"
    
    # Check for existing YAML
    if head -n1 "$file" | grep -q "^---$" 2>/dev/null; then
        has_yaml=true
        echo -e "${BLUE}📄 DETECTED: This file already has YAML front matter${NC}"
        echo -e "${CYAN}   (Professional PDF settings are already configured)${NC}"
        echo ""
        
        local edit_choice=$(safe_read "Do you want to edit/replace the existing settings?" "N")
        if [[ ! "$edit_choice" =~ ^[Yy]$ ]]; then
            echo -e "${BLUE}⏭️  SKIPPED: Keeping existing YAML settings unchanged${NC}"
            echo ""
            return 0
        fi
        echo ""
        echo -e "${YELLOW}🔄 PROCEEDING: Will update existing YAML settings...${NC}"
    else
        echo -e "${YELLOW}📝 DETECTED: New file without YAML front matter${NC}"
        echo -e "${CYAN}   (Will add professional PDF settings to this document)${NC}"
    fi
    
    # Extract title from first heading or use filename
    local default_title
    local first_heading=$(grep -m1 "^# " "$file" 2>/dev/null | sed 's/^# *//' | sed 's/[🔧📝✅❌⚠️🔄📋🔍✏️📏🖊️📧💡📊🎯🚀📱💻🌐📁🎉💰📞🛠️⭐]*//g' | sed 's/^ *//' | sed 's/ *$//')
    
    if [ -n "$first_heading" ]; then
        default_title="$first_heading"
    else
        default_title=$(basename "$file" .md)
    fi
    
    # Set default values
    local title="$default_title"
    local author="Regard Vermeulen"
    local date_val="$(date '+%B %d, %Y')"
    local subtitle="Professional Training Guide"
    local titlepage_color="F8F9FA"
    local text_color="2C3E50"
    local rule_color="3498DB"
    
    # Extract existing values if file has YAML
    if [ "$has_yaml" = true ]; then
        local existing_values=$(extract_existing_yaml "$file")
        if [ -n "$existing_values" ]; then
            IFS='|' read -r existing_title existing_author existing_date existing_subtitle existing_bg existing_text existing_rule <<< "$existing_values"
            
            [ -n "$existing_title" ] && title="$existing_title"
            [ -n "$existing_author" ] && author="$existing_author"
            [ -n "$existing_date" ] && date_val="$existing_date"
            [ -n "$existing_subtitle" ] && subtitle="$existing_subtitle"
            [ -n "$existing_bg" ] && titlepage_color="$existing_bg"
            [ -n "$existing_text" ] && text_color="$existing_text"
            [ -n "$existing_rule" ] && rule_color="$existing_rule"
        fi
    fi
    
    echo ""
    if [ "$has_yaml" = true ]; then
        echo -e "${BLUE}📋 Current YAML values found in this file:${NC}"
        echo -e "${CYAN}   (These are the values already in your document's front matter)${NC}"
    else
        echo -e "${BLUE}📋 Suggested values for this new document:${NC}"
        echo -e "${CYAN}   (Extracted from your document content and smart defaults)${NC}"
    fi
    echo -e "  📖 Title: ${GREEN}$title${NC}"
    echo -e "  👤 Author: ${GREEN}$author${NC}"
    echo -e "  📅 Date: ${GREEN}$date_val${NC}"
    echo -e "  📄 Subtitle: ${GREEN}$subtitle${NC}"
    echo -e "  🎨 Background: ${GREEN}$titlepage_color${NC} ($(get_color_description "$titlepage_color"))"
    echo -e "  🎨 Text: ${GREEN}$text_color${NC} ($(get_color_description "$text_color"))"
    echo -e "  🎨 Rule: ${GREEN}$rule_color${NC} ($(get_color_description "$rule_color"))"
    echo ""
    echo -e "${YELLOW}❓ STEP 1: Do you want to customize any of these values?${NC}"
    echo -e "${CYAN}   (Answer 'y' to edit individual fields, or 'N' to use these values as-is)${NC}"
    
    local customize=$(safe_read "Edit these values?" "N")
    if [[ "$customize" =~ ^[Yy]$ ]]; then
        echo ""
        echo -e "${CYAN}📝 STEP 2: Customizing document metadata${NC}"
        echo -e "${CYAN}   (Press Enter to keep current value, or type new value)${NC}"
        echo ""
        
        echo -e "${BLUE}📖 Document Information:${NC}"
        title=$(safe_read "Document Title" "$title")
        author=$(safe_read "Author Name" "$author")
        date_val=$(safe_read "Publication Date" "$date_val")
        subtitle=$(safe_read "Document Subtitle" "$subtitle")
        
        echo ""
        echo -e "${BLUE}🎨 STEP 3: PDF Cover Page Colors${NC}"
        echo -e "${CYAN}   (These control how your PDF title page will look)${NC}"
        echo -e "${YELLOW}   💡 TIP: Type 'help' for any color to see the full color palette${NC}"
        echo ""
        
        echo -e "${BLUE}Background Color (the main title page background):${NC}"
        local bg_input=$(safe_read "Background Color" "$titlepage_color")
        if [ "$bg_input" = "help" ]; then
            echo ""
            show_color_palette
            echo ""
            titlepage_color=$(safe_read "Background Color" "$titlepage_color")
        else
            titlepage_color="$bg_input"
        fi
        
        echo -e "${BLUE}Text Color (for the title and author text):${NC}"
        local text_input=$(safe_read "Text Color" "$text_color")
        if [ "$text_input" = "help" ]; then
            echo ""
            show_color_palette
            echo ""
            text_color=$(safe_read "Text Color" "$text_color")
        else
            text_color="$text_input"
        fi
        
        echo -e "${BLUE}Rule Color (decorative line on title page):${NC}"
        local rule_input=$(safe_read "Rule Color" "$rule_color")
        if [ "$rule_input" = "help" ]; then
            echo ""
            show_color_palette
            echo ""
            rule_color=$(safe_read "Rule Color" "$rule_color")
        else
            rule_color="$rule_input"
        fi
        
        echo ""
        echo -e "${GREEN}✅ Customization complete!${NC}"
    else
        echo ""
        echo -e "${GREEN}✅ Using suggested values without changes${NC}"
    fi
    
    echo ""
    echo -e "${BLUE}📋 STEP 4: Final Review - Your PDF Cover Page Will Have:${NC}"
    echo -e "${CYAN}   (This is what will appear on your professional PDF cover)${NC}"
    echo ""
    echo -e "  📖 Document Title: ${GREEN}$title${NC}"
    echo -e "  👤 Author Name: ${GREEN}$author${NC}"
    echo -e "  📅 Publication Date: ${GREEN}$date_val${NC}"
    echo -e "  📄 Document Subtitle: ${GREEN}$subtitle${NC}"
    echo ""
    echo -e "  🎨 Title Page Colors:"
    echo -e "     Background: ${GREEN}$titlepage_color${NC} ($(get_color_description "$titlepage_color"))"
    echo -e "     Text Color: ${GREEN}$text_color${NC} ($(get_color_description "$text_color"))"
    echo -e "     Accent Rule: ${GREEN}$rule_color${NC} ($(get_color_description "$rule_color"))"
    echo ""
    echo -e "${YELLOW}❓ STEP 5: Save these settings to your markdown file?${NC}"
    echo -e "${CYAN}   (This adds YAML front matter to make professional PDFs)${NC}"
    
    local confirm=$(safe_read "Save YAML settings to file?" "Y")
    if [[ "$confirm" =~ ^[Nn]$ ]]; then
        echo -e "${RED}❌ CANCELLED: No changes made to your file${NC}"
        echo ""
        return 1
    fi
    
    echo ""
    echo -e "${CYAN}💾 STEP 6: Writing YAML front matter to your file...${NC}"
    echo -e "${CYAN}   (Adding professional PDF metadata to: $(basename "$file"))${NC}"
    
    # Backup original
    cp "$file" "$backup_file"
    
    # Get content without YAML
    local content_file="/tmp/content_$$"
    if [ "$has_yaml" = true ]; then
        awk '/^---$/{flag=!flag; if(!flag) flag=2; next} flag==2' "$file" > "$content_file"
    else
        cp "$file" "$content_file"
    fi
    
    # Write new file with YAML
    cat > "$file" << YAMLEOF
---
title: "$title"
author: "$author"
date: "$date_val"
subtitle: "$subtitle"

# Eisvogel Template Settings
titlepage: true
titlepage-color: "$titlepage_color"
titlepage-text-color: "$text_color"
titlepage-rule-color: "$rule_color"
book: true
chapters: true
toc: true
geometry: margin=0.8in
colorlinks: true
linkcolor: "blue!80!black"
highlight-style: tango
---

YAMLEOF
    
    # Add original content
    cat "$content_file" >> "$file"
    rm -f "$content_file"
    
    if [ "$has_yaml" = true ]; then
        echo -e "${GREEN}✅ SUCCESS: YAML front matter updated successfully!${NC}"
        echo -e "${CYAN}   Your existing YAML has been replaced with new settings${NC}"
    else
        echo -e "${GREEN}✅ SUCCESS: YAML front matter added successfully!${NC}"
        echo -e "${CYAN}   Professional PDF metadata has been added to your document${NC}"
    fi
    echo -e "${BLUE}   📁 Original backup saved as: $(basename "$backup_file")${NC}"
    echo -e "${YELLOW}   🎯 Ready for PDF conversion with ./enhanced_markdown_converter.sh${NC}"
    echo ""
    
    return 0
}

# Main execution
count=0
processed=0
skipped=0

# Count files
for file in "$INPUT_DIR"/*.md "$INPUT_DIR"/*.MD; do
    if [ -f "$file" ] && [[ "$file" != *.backup ]] && [[ "$file" != *.tmp ]]; then
        count=$((count + 1))
    fi
done

if [ $count -eq 0 ]; then
    echo -e "${RED}❌ No markdown files found in $INPUT_DIR${NC}"
    exit 1
fi

echo -e "${CYAN}📁 Found $count markdown file(s)${NC}"
echo ""

# Process each file
for file in "$INPUT_DIR"/*.md "$INPUT_DIR"/*.MD; do
    if [ ! -f "$file" ] || [[ "$file" == *.backup ]] || [[ "$file" == *.tmp ]]; then
        continue
    fi
    
    if process_file "$file"; then
        processed=$((processed + 1))
    else
        skipped=$((skipped + 1))
    fi
    
    # Ask to continue if more files
    current_total=$((processed + skipped))
    if [ $current_total -lt $count ]; then
        echo -e "${CYAN}📄 FILES REMAINING: $((count - current_total)) more files to process${NC}"
        local continue_choice=$(safe_read "Continue with next file?" "Y")
        if [[ "$continue_choice" =~ ^[Nn]$ ]]; then
            echo -e "${YELLOW}⏹️  STOPPED: Processing halted by user choice${NC}"
            break
        fi
        echo ""
        echo -e "${CYAN}▶️  CONTINUING: Moving to next file...${NC}"
        echo ""
    fi
done

echo ""
echo -e "${CYAN}📊 Summary:${NC}"
echo -e "${BLUE}📁 Files found: $count${NC}"
echo -e "${GREEN}✅ Processed: $processed${NC}"
echo -e "${YELLOW}⏭️  Skipped: $skipped${NC}"

if [ $processed -gt 0 ]; then
    echo ""
    echo -e "${GREEN}🎉 Ready for enhanced converter!${NC}"
    echo -e "${BLUE}Run: ./enhanced_markdown_converter.sh${NC}"
fi