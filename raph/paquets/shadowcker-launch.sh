#!/usr/bin/env bash

# Arguments passed to the script
src_dir=$1
client_version=${2:-stable} # Default to 'stable' if no version is provided

# Function to launch the Shadow client
launch_shadow() {
  cd "$src_dir"
  make "$client_version"
  make start
}

# Check if the local git repository is up to date
cd "$src_dir"

# Check connectivity with the remote repository
if git ls-remote &> /dev/null; then
  # Update the local repository if there are changes
  git fetch origin
  LOCAL=$(git rev-parse HEAD)
  REMOTE=$(git rev-parse origin/master)

  if [ "$LOCAL" != "$REMOTE" ]; then
    echo "Local repository is not up-to-date. Updating..."
    git pull origin master
    make clean
    launch_shadow
  else
    echo "Local repository is up-to-date."
    launch_shadow
  fi
else
  echo "Unable to reach the remote repository. Launching the client with the local version..."
  launch_shadow
fi
