#!/usr/bin/env bash

# Choose the version of the client to launch (stable, beta, alpha)
client_version="${1:-stable}"

# Function to launch the Shadow client
launch_shadow() {
  make $client_version
  make start
}

# Check if the local git repository is up to date
cd ${src}

# Check connectivity with the remote repository
if git ls-remote &> /dev/null; then
  # Update the local repository if there are changes
  git fetch origin
  LOCAL=$(git rev-parse HEAD)
  REMOTE=$(git rev-parse origin/master)

  if [ $LOCAL != $REMOTE ]; then
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
