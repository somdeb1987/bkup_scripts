#!/bin/bash

# Step 1: Create the main directories
mkdir -p ~/libraries ~/scripts ~/jupyter-notebooks ~/works

# Step 2: Create subdirectories inside the "works" folder
mkdir -p ~/works/code-dev ~/works/projects ~/works/website-dev ~/works/notes ~/works/latex-works

# Step 3: Change to the scripts directory
cd ~/scripts

# Step 4: Define the list of scripts to be downloaded and executed
SCRIPTS=(
    "install-OpenMpi.sh"
    "install-hdf5.sh"
    "install-PETSc.sh"
)

# Step 5: Download and execute the scripts
REPO_URL="https://raw.githubusercontent.com/somdeb1987/bkup_scripts/main"

for script in "${SCRIPTS[@]}"; do
    wget "${REPO_URL}/${script}" # Download the script
    chmod +x "${script}"          # Make the script executable
    ./"${script}"                # Execute the script
done

echo "Setup completed."
