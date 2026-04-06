#!/bin/bash

set -euo pipefail

# Define variables
BUILD_DIR="${BUILD_DIR:-_site}"
REMOTE_USER="${REMOTE_USER:?Set REMOTE_USER}"
REMOTE_HOST="cs-www.cs.yale.edu"
REMOTE_PATH="/srv/www/htdocs/cswww/yacl"

# Build the site with Jekyll
bundle exec jekyll build

# Use rsync to deploy the site
rsync -avz --delete "$BUILD_DIR/" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH/"

echo "Deployment successful!"
