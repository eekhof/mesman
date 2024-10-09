#!/bin/bash

set -e # Crash on fail

# if there is a .git directory in INLISTS, pull the latest changes
if [ -d "INLISTS/.git" ]; then
    cd INLISTS
    git pull
    cd ..
fi

# Use 'find' to collect all .in files in the INLISTS directory and subdirectories
inlist_files=($(find INLISTS -type f -name "*.in"))

# Check if any .in files were found
if [ ${#inlist_files[@]} -eq 0 ]; then
    echo "No .in files found in the INLISTS directory."
    exit 1
fi

# Strip the "INLISTS/" prefix from the filenames for display purposes
# This creates a new array for display
display_files=()
for file in "${inlist_files[@]}"; do
    display_files+=("$(basename "$file")")
done

# List available inlists and prompt the user to select one
echo "Available inlists:"
select index in "${display_files[@]}"; do
    # Check if the selection is valid
    if [[ -n "$index" ]]; then
        # Get the corresponding full path from inlist_files using the index
        inlist_file="${inlist_files[$REPLY - 1]}"

        # Create a new symlink
        echo "You selected: $inlist_file"
        ln -sf "$inlist_file" ./inlist
        echo "Symlink updated: 'inlist' -> '$inlist_file'"
        break
    else
        echo "Invalid selection. Please try again."
    fi
done

# Run the slurm job after setting the symlink
./clean
./mk
# Check if a .lock file is in the current directory, if so, refuse to run because other run is still going on. If not, create .lock file
if [ -f ".lock" ]; then
    echo "Another run is still going on. Please wait until it finishes."
    exit 1
else
    touch .lock
fi
echo ""
echo "---------------------"
echo "Compilation finished."
echo "Commencing slurmjob."
echo "---------------------"
sbatch sjobrun.sh
