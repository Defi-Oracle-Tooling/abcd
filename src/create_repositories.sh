#!/bin/bash

# Script to create white-label submodule repositories

# Array of repository names
REPOSITORIES=(
  "web3-non-bank-banking-dapp"
  "blockchain-forking-contract"
  "openzeppelin-defender"
  "openzeppelin-smart-contracts"
  "utility-contracts"
)

# GitHub organization or user
GITHUB_ORG="your-org"

# Base directory for the project
PROJECT_ROOT=$(dirname $(dirname $(realpath $0)))

# Ensure the .env file exists
if [ ! -f "$PROJECT_ROOT/.env" ]; then
  echo "Error: .env file not found. Please create a .env file in the project root directory with the required environment variables."
  echo "Example .env file content:"
  echo "GITHUB_ACCESS_TOKEN=your_github_access_token_here"
  exit 1
fi

# Load environment variables from .env file
# The .env file should be located in the project root directory.
export $(grep -v '^#' $PROJECT_ROOT/.env | xargs)

# Ensure GITHUB_ACCESS_TOKEN is set
if [ -z "$GITHUB_ACCESS_TOKEN" ]; then
  echo "Error: GITHUB_ACCESS_TOKEN is not set in the .env file. Please add it and try again."
  exit 1
fi

# Use GITHUB_ACCESS_TOKEN for authentication
GITHUB_TOKEN=$GITHUB_ACCESS_TOKEN

# Base API URL
GITHUB_API="https://api.github.com"

# Function to create a repository
create_repository() {
  local repo_name=$1
  echo "Creating repository: $repo_name"

  curl -H "Authorization: token $GITHUB_TOKEN" \
       -H "Accept: application/vnd.github.v3+json" \
       -X POST $GITHUB_API/orgs/$GITHUB_ORG/repos \
       -d "{\"name\": \"$repo_name\", \"private\": true}"

  if [ $? -eq 0 ]; then
    echo "Repository $repo_name created successfully."
  else
    echo "Failed to create repository $repo_name."
  fi
}

# Iterate over the repositories and create them
for repo in "${REPOSITORIES[@]}"; do
  create_repository $repo
done

# End of script