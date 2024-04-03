#Save the script to a file (e.g., keyboard_shortcuts.sh).
#Make the script executable: chmod +x keyboard_shortcuts.sh.
#Run the script: ./keyboard_shortcuts.sh

#!/bin/bash

# Define output filenames
TXT_OUTPUT="keyboard_shortcuts.txt"
MD_OUTPUT="keyboard_shortcuts.md"

# Function to display shortcuts for a specific schema
display_shortcuts() {
    schema=$1
    output_file=$2
    echo "Shortcuts for $schema:" >> $output_file  # Print schema name
    echo "---------------------------" >> $output_file
    gsettings list-recursively $schema >> $output_file  # List shortcuts for the schema
    echo "" >> $output_file
}

# Function to list custom shortcuts
list_custom_shortcuts() {
    output_file=$1
    echo "Custom Shortcuts:" >> $output_file  # Header for custom shortcuts
    echo "---------------------------" >> $output_file
    gsettings list-recursively org.gnome.settings-daemon.plugins.media-keys | grep custom-keybindings >> $output_file  # List custom shortcuts
    echo "" >> $output_file
}

# Function to list built-in shortcuts
list_builtin_shortcuts() {
    output_file=$1
    echo "Built-in Shortcuts:" >> $output_file  # Header for built-in shortcuts
    echo "---------------------------" >> $output_file
    gsettings list-recursively org.gnome.desktop.wm.keybindings >> $output_file  # List built-in shortcuts
    gsettings list-recursively org.gnome.desktop.wm.preferences >> $output_file
    gsettings list-recursively org.gnome.settings-daemon.plugins.media-keys >> $output_file
    echo "" >> $output_file
}

# Create and display shortcuts in .txt file
echo "Generating keyboard shortcuts..."
echo "Keyboard Shortcuts:" > $TXT_OUTPUT  # Header for keyboard shortcuts
echo "---------------------------" >> $TXT_OUTPUT
display_shortcuts org.gnome.desktop.wm.keybindings $TXT_OUTPUT  # Display shortcuts for each schema
display_shortcuts org.gnome.desktop.wm.preferences $TXT_OUTPUT
display_shortcuts org.gnome.settings-daemon.plugins.media-keys $TXT_OUTPUT
list_custom_shortcuts $TXT_OUTPUT  # List custom shortcuts
list_builtin_shortcuts $TXT_OUTPUT  # List built-in shortcuts
echo "Keyboard shortcuts saved to $TXT_OUTPUT"

# Convert .txt to .md
echo "Converting to Markdown..."
pandoc -o $MD_OUTPUT $TXT_OUTPUT  # Convert .txt to .md
echo "Markdown file generated: $MD_OUTPUT"
