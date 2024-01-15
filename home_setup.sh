#!/bin/bash

# Ask the user for a custom setup root directory or use the user's home directory as default
echo "Enter the setup root directory or press Enter to use the default ($HOME):"
read setup_root
setup_root="${setup_root:-$HOME}"

# Function to create a directory if it doesn't exist
create_dir_if_not_exists() {
    local dir_path="$setup_root/$1"
    if [ ! -d "$dir_path" ]; then
        mkdir -p "$dir_path"
        echo "Created directory: $dir_path"
    else
        echo "Directory already exists: $dir_path"
    fi
}

# Function to check if an item is in an array
contains_element () {
    local element
    for element in "${@:2}"; do
        [[ "$element" == "$1" ]] && return 0
    done
    return 1
}


# Create directories
create_dir_if_not_exists "libraries"
create_dir_if_not_exists "scripts"
create_dir_if_not_exists "softwares"
create_dir_if_not_exists "jupyter-notebooks"
create_dir_if_not_exists "works"

# Create subdirectories inside the "works" folder
create_dir_if_not_exists "works/code-dev"
create_dir_if_not_exists "works/projects"
create_dir_if_not_exists "works/website-dev"
create_dir_if_not_exists "works/notes"
create_dir_if_not_exists "works/latex-works"


sudo apt install -y git gcc gfortran g++ filezilla


# Change to the scripts directory
cd "$setup_root/scripts"

# Step 4: # Define the list of scripts to be downloaded and executed
SCRIPTS=( 
    "install-OpenMpi.sh"
    "install-hdf5.sh"
    "install-PETSc.sh"
)

# Define the list of scripts to be executed with bash
SCRIPTS_with_bash=(
    #"install-PETSc.sh"
    # Add other scripts here that need to be executed with bash
)
SCRIPTS_with_source=(
    "install-PETSc.sh"
    # Add other scripts here that need to be executed with bash
)
# Download and execute the scripts
REPO_URL="https://raw.githubusercontent.com/somdeb1987/bkup_scripts/main"

for script in "${SCRIPTS[@]}"; do
    if [ ! -f "$script" ]; then
        wget "${REPO_URL}/${script}" # Download the script if it doesn't exist
        chmod +x "${script}"        # Make the script executable
        
        # Check if the script should be executed with bash
        if contains_element "$script" "${SCRIPTS_with_bash[@]}"; then
            bash "./${script}"      # Execute the script with bash
        elif contains_element "$script" "${SCRIPTS_with_source[@]}"; then
            (
            source "./${script}"
            # ... use the variables or environment settings here ...
            )
        else
            ./"${script}"           # Execute the script normally
        fi
    else
        echo "Script already exists, skipping: $script"
    fi
done


echo "Setup completed."
