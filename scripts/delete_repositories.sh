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

# Unified logging function
log() {
  local level=$1
  local message=$2
  echo "$(date '+%Y-%m-%d %H:%M:%S') [$level] $message"
}

# Dry-run mode
DRY_RUN=false
if [[ "$1" == "--dry-run" ]]; then
  DRY_RUN=true
fi

# Function to delete a repository
force_delete_repository() {
  local repo_name=$1
  log "INFO" "Deleting repository: $repo_name"

  if $DRY_RUN; then
    log "INFO" "Dry-run: Would delete repository $repo_name."
    return 0
  fi

  response=$(curl -s -w "%{http_code}" -o /tmp/repo_delete_response.json \
    -H "Authorization: token $GITHUB_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    -X DELETE $GITHUB_API/repos/$GITHUB_ORG/$repo_name)

  if [ "$response" -ne 204 ]; then
    log "ERROR" "Failed to delete repository $repo_name."
    log "ERROR" "$(cat /tmp/repo_delete_response.json)"
    return 1
  else
    log "INFO" "Repository $repo_name deleted successfully."
    return 0
  fi

  # Clean up temporary response file
  rm -f /tmp/repo_delete_response.json
}

# Function to delete a submodule from the submodules directory
remove_submodule() {
  local repo_name=$1
  local submodule_path="$PROJECT_ROOT/submodules/$repo_name"

  log "INFO" "Removing submodule: $repo_name"

  # Remove the submodule entry from .gitmodules
  git submodule deinit -f $submodule_path
  git rm -f $submodule_path
  rm -rf .git/modules/$submodule_path

  log "INFO" "Submodule $repo_name removed successfully."
}

# Function to delete specific repositories
filter_repositories() {
  local filter=$1
  local filtered_repos=()

  for repo in "${REPOSITORIES[@]}"; do
    if [[ $repo == *$filter* ]]; then
      filtered_repos+=("$repo")
    fi
  done

  echo "Filtered repositories: ${filtered_repos[@]}"
  REPOSITORIES=(${filtered_repos[@]})
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

# Updated logic to support dry-run mode
for repo in "${REPOSITORIES[@]}"; do
  echo "Processing repository: $repo"

  if $DRY_RUN; then
    echo "Dry-run: Would delete repository $repo and remove submodule."
    continue
  fi

  # Delete the repository from GitHub
  if force_delete_repository $repo; then
    deleted_count=$((deleted_count + 1))
  else
    log "ERROR" "Failed to delete repository $repo. Skipping."
    failed_count=$((failed_count + 1))
    continue
  fi

  # Remove the submodule
  if remove_submodule $repo; then
    log "INFO" "Submodule $repo removed successfully."
  else
    log "ERROR" "Failed to remove submodule $repo. Skipping."
    failed_count=$((failed_count + 1))
  fi

done

# Display summary report
log_summary

# End of script