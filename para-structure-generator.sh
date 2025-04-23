#!/bin/bash

# ===================================================
# PARA Structure Generator
# Compatible with Debian 12 GNOME
# ===================================================
# This script reads a markdown file containing the PARA structure
# and creates the corresponding directory structure with placeholder files
# ===================================================

# Text formatting for terminal output
BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
RESET='\033[0m'

# Check if input file is provided
if [ $# -lt 1 ]; then
    echo -e "${RED}Error: Input file not provided${RESET}"
    echo -e "Usage: $0 <para_structure.md> [output_directory]"
    exit 1
fi

INPUT_FILE="$1"

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo -e "${RED}Error: File '$INPUT_FILE' not found${RESET}"
    exit 1
fi

# Set the base output directory
if [ $# -ge 2 ]; then
    BASE_DIR="$2"
else
    BASE_DIR="$HOME/PARA_System"
fi

# Function to create directories and placeholder files
create_directory_with_placeholder() {
    local dir_path="$1"
    local placeholder_name="README.md"
    local placeholder_content="# $(basename "$dir_path" | tr '_' ' ')\n\n$2"
    
    # Create the directory
    mkdir -p "$dir_path"
    
    # Create the placeholder file
    echo -e "$placeholder_content" > "$dir_path/$placeholder_name"
    
    echo -e "  Created: ${BLUE}$dir_path/${placeholder_name}${RESET}"
}

# Function to sanitize directory names
sanitize_dirname() {
    # Replace spaces with underscores, remove special characters
    echo "$1" | tr ' ' '_' | tr -d ',:;()[]*&^%$#@!~`"\|<>/?' | tr -s '_'
}

# Start script execution
echo -e "${BOLD}Starting PARA System Generator...${RESET}"
echo -e "${GREEN}Reading structure from: $INPUT_FILE${RESET}"
echo -e "${GREEN}Creating directories in: $BASE_DIR${RESET}"

# Create the base directory
mkdir -p "$BASE_DIR"

# Variables to track current section and hierarchy level
current_main_section=""
current_category=""
current_subcategory=""

# Process the markdown file line by line
line_number=0
while IFS= read -r line || [ -n "$line" ]; do
    ((line_number++))
    
    # Skip empty lines
    if [[ -z "${line// /}" ]]; then
        continue
    fi
    
    # Determine the line's hierarchy level based on indentation and formatting
    if [[ "$line" =~ ^"#"[[:space:]] ]]; then
        # This is a heading, likely the file title - skip
        continue
    elif [[ "$line" =~ ^"##"[[:space:]] ]]; then
        # This is a main PARA section (Projects, Areas, Resources, Archive)
        section_name=$(echo "$line" | sed 's/^##[[:space:]]*//g')
        current_main_section=$(sanitize_dirname "$section_name")
        current_category=""
        current_subcategory=""
        
        # Create the main section directory and README
        section_dir="$BASE_DIR/$current_main_section"
        create_directory_with_placeholder "$section_dir" "Main section for $section_name in the PARA system."
        
        echo -e "\n${BOLD}Creating $section_name structure...${RESET}"
    elif [[ "$line" =~ ^[[:space:]]*[0-9]+\.[[:space:]] && -n "$current_main_section" ]]; then
        # This is a category under a main section
        category_name=$(echo "$line" | sed 's/^[[:space:]]*[0-9]\+\.[[:space:]]*//g' | sed 's/\*\*//g')
        current_category=$(sanitize_dirname "$category_name")
        current_subcategory=""
        
        # Create the category directory and README
        category_dir="$BASE_DIR/$current_main_section/$current_category"
        create_directory_with_placeholder "$category_dir" "Category for $category_name in the $current_main_section section."
    elif [[ "$line" =~ ^[[:space:]]*-[[:space:]] && -n "$current_category" ]]; then
        # This is a subcategory
        subcategory_name=$(echo "$line" | sed 's/^[[:space:]]*-[[:space:]]*//g')
        current_subcategory=$(sanitize_dirname "$subcategory_name")
        
        # Create the subcategory directory and README
        if [[ -n "$current_subcategory" ]]; then
            subcategory_dir="$BASE_DIR/$current_main_section/$current_category/$current_subcategory"
            create_directory_with_placeholder "$subcategory_dir" "Subcategory for $subcategory_name in the $current_category category."
            
            # Create a sample placeholder file specific to this subcategory
            placeholder_filename=$(echo "$subcategory_name" | tr ' ' '_' | tr '[:upper:]' '[:lower:]')
            echo -e "# $subcategory_name\n\nThis file contains information related to $subcategory_name." > "$subcategory_dir/${placeholder_filename}.md"
            echo -e "  Created: ${BLUE}$subcategory_dir/${placeholder_filename}.md${RESET}"
        fi
    fi
done < "$INPUT_FILE"

# Create main README file
main_readme="# PARA System\n\nPersonal Knowledge Management System based on the PARA method.\n\n## Structure\n\n- Projects: Time-bound undertakings with specific outcomes\n- Areas: Ongoing responsibilities requiring regular maintenance\n- Resources: Reference materials organized by interest domains\n- Archive: Completed or inactive items\n\n## Generated\n\nThis structure was automatically generated from $INPUT_FILE on $(date)"

echo -e "$main_readme" > "$BASE_DIR/README.md"
echo -e "  Created: ${BLUE}$BASE_DIR/README.md${RESET}"

echo -e "\n${GREEN}✓ PARA System directory structure successfully created!${RESET}"
echo -e "${BOLD}Total directories created: $(find "$BASE_DIR" -type d | wc -l)${RESET}"
echo -e "${BOLD}Total files created: $(find "$BASE_DIR" -type f | wc -l)${RESET}"
echo -e "\nYour PARA System is ready at: ${YELLOW}$BASE_DIR${RESET}"
