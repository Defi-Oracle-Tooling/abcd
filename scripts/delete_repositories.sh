#!/bin/bash

# Script to force delete repositories

# List of repositories to delete
REPOSITORIES=(
  "abcd_sm_documentation-tooling"
  "abcd_sm_custom-submodule-scaffold"
  "abcd_sm_webhooks"
  "abcd_sm_javascript-and-typescript-sdk"
  "abcd_sm_swagger-api"
  "abcd_sm_ccip-arbitrary-messaging-bridge"
  "abcd_sm_blockchain-mirroring"
  "abcd_sm_two-way-tethering"
  "abcd_sm_utility-contracts"
  "abcd_sm_openzeppelin-smart-contracts"
  "abcd_sm_openzeppelin-defender"
  "abcd_sm_blockchain-forking-contract"
  "abcd_sm_web3-non-bank-banking-dapp"
  "utility-contracts"
  "openzeppelin-smart-contracts"
  "openzeppelin-defender"
  "blockchain-forking-contract"
  "web3-non-bank-banking-dapp"
)

# GitHub organization or user
GITHUB_ORG="your-org"

# Base directory for the project
PROJECT_ROOT=$(dirname $(dirname $(realpath $0)))

# Ensure the .env file exists
if [ ! -f "$PROJECT_ROOT/.env" ]; then
  echo "Error: .env file not found. Please create a .env file in the project root directory with the required environment variables."
  exit 1
fi

# Load environment variables from .env file
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

# Function to delete a repository
force_delete_repository() {
  local repo_name=$1
  echo "Deleting repository: $repo_name"

  response=$(curl -s -w "%{http_code}" -o /tmp/repo_delete_response.json \
    -H "Authorization: token $GITHUB_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    -X DELETE $GITHUB_API/repos/$GITHUB_ORG/$repo_name)

  if [ "$response" -ne 204 ]; then
    echo "Failed to delete repository $repo_name."
    echo "Error: $(cat /tmp/repo_delete_response.json)"
    return 1
  else
    echo "Repository $repo_name deleted successfully."
    return 0
  fi

  # Clean up temporary response file
  rm -f /tmp/repo_delete_response.json
}

# Function to delete a submodule from the submodules directory
remove_submodule() {
  local repo_name=$1
  local submodule_path="$PROJECT_ROOT/submodules/$repo_name"

  echo "Removing submodule: $repo_name"

  # Remove the submodule entry from .gitmodules
  git submodule deinit -f $submodule_path
  git rm -f $submodule_path
  rm -rf .git/modules/$submodule_path

  echo "Submodule $repo_name removed successfully."
}

# Summary report
log_summary() {
  echo "Summary:"
  echo "Repositories deleted: $deleted_count"
  echo "Repositories skipped: $skipped_count"
  echo "Repositories failed: $failed_count"
}

# Initialize counters
deleted_count=0
skipped_count=0
failed_count=0

# Enhanced logic to delete repositories and submodules
for repo in "${REPOSITORIES[@]}"; do
  echo "Processing repository: $repo"

  # Delete the repository from GitHub
  if force_delete_repository $repo; then
    deleted_count=$((deleted_count + 1))
  else
    echo "Failed to delete repository $repo. Skipping."
    failed_count=$((failed_count + 1))
    continue
  fi

  # Remove the submodule
  if remove_submodule $repo; then
    echo "Submodule $repo removed successfully."
  else
    echo "Failed to remove submodule $repo. Skipping."
    failed_count=$((failed_count + 1))
  fi

done

# Display summary report
log_summary

# End of script