#!/bin/bash

# Output file
output_file="gnome_extensions.md"

# Print header
echo "Extension Name | Status" > "$output_file"
echo "--------------|-------" >> "$output_file"

# Find all metadata.json files to get exact paths to extensions
extension_paths=$(find / -name metadata.json 2>/dev/null)

# Function to check if an extension is enabled
is_enabled() {
    local extension_dir="$1"
    local config_file="$HOME/.config/gnome-shell/extensions.json"
    
    if [ -f "$config_file" ] && grep -q "\"$extension_dir\"" "$config_file"; then
        echo "Enabled"
    else
        echo "Disabled"
    fi
}

# Iterate over each extension path
while IFS= read -r extension_path; do
    extension_dir=$(dirname "$extension_path")
    extension_name=$(basename "$extension_dir")
    status=$(is_enabled "$extension_dir")
    echo "$extension_name | $status" >> "$output_file"
done <<< "$extension_paths"

echo "Output saved to $output_file"
