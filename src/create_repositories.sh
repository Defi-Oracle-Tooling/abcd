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

# Load GitHub token from environment variables
GITHUB_TOKEN=${GITHUB_TOKEN:-""}

if [ -z "$GITHUB_TOKEN" ]; then
  echo "Error: GITHUB_TOKEN is not set. Please set it in the .env file or as an environment variable."
  exit 1
fi

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