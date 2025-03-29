#!/bin/bash

# Script to create white-label submodule repositories

# Add prefix to repository names
REPOSITORIES=(
  "abcd_sm_web3-non-bank-banking-dapp"
  "abcd_sm_blockchain-forking-contract"
  "abcd_sm_openzeppelin-defender"
  "abcd_sm_openzeppelin-smart-contracts"
  "abcd_sm_utility-contracts"
  "abcd_sm_two-way-tethering"
  "abcd_sm_blockchain-mirroring"
  "abcd_sm_ccip-arbitrary-messaging-bridge"
  "abcd_sm_swagger-api"
  "abcd_sm_javascript-and-typescript-sdk"
  "abcd_sm_webhooks"
  "abcd_sm_custom-submodule-scaffold"
  "abcd_sm_documentation-tooling"
)

# GitHub organization or user
# Removed hard-coded organization value.
# It should now be provided via the .env file as GITHUB_ORG

# Base directory for the project
PROJECT_ROOT=$(dirname $(dirname $(realpath $0)))

# Ensure the .env file exists
if [ ! -f "$PROJECT_ROOT/.env" ]; then
  echo "Error: .env file not found. Please create a .env file in the project root directory with the required environment variables."
  echo "Example .env file content:"
  echo "GITHUB_ACCESS_TOKEN=your_github_access_token_here"
  echo "GITHUB_ORG=your_org_name_here"
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

# Ensure the submodules directory exists
if [ ! -d "$PROJECT_ROOT/submodules" ]; then
  mkdir -p "$PROJECT_ROOT/submodules"
  echo "Created submodules directory."
fi

# Unified logging function
log() {
  local level=$1
  local message=$2
  echo "$(date '+%Y-%m-%d %H:%M:%S') [$level] $message"
}

# Function to validate required environment variables
validate_env() {
  local vars=("GITHUB_ACCESS_TOKEN" "GITHUB_ORG")
  for var in "${vars[@]}"; do
    if [ -z "${!var}" ]; then
      log "ERROR" "Environment variable $var is not set."
      exit 1
    fi
  done
}

# Retry logic for network operations
retry() {
  local retries=3
  local count=0
  until "$@"; do
    exit_code=$?
    count=$((count + 1))
    if [ $count -lt $retries ]; then
      log "INFO" "Retrying... ($count/$retries)"
      sleep 2
    else
      log "ERROR" "Command failed after $retries attempts."
      return $exit_code
    fi
  done
  return 0
}

# Cleanup temporary files on exit
trap 'rm -f /tmp/repo_response.json /tmp/repo_delete_response.json' EXIT

# Dry-run mode
DRY_RUN=false
if [[ "$1" == "--dry-run" ]]; then
  DRY_RUN=true
fi

# Function to check if a repository exists
check_repository_exists() {
  local repo_name=$1
  response=$(curl -s -o /dev/null -w "%{http_code}" \
    -H "Authorization: token $GITHUB_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    $GITHUB_API/repos/$GITHUB_ORG/$repo_name)

  if [ "$response" -eq 200 ]; then
    echo "Repository $repo_name already exists."
    return 0
  else
    return 1
  fi
}

# Function to check if a repository is initialized
check_repository_initialized() {
  local repo_name=$1
  response=$(curl -s \
    -H "Authorization: token $GITHUB_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    $GITHUB_API/repos/$GITHUB_ORG/$repo_name/contents/README.md)

  if echo "$response" | grep -q '"name": "README.md"'; then
    echo "Repository $repo_name is initialized."
    return 0
  else
    echo "Repository $repo_name is not initialized."
    return 1
  fi
}

# Function to check if a repository is already a submodule
check_submodule_exists() {
  local repo_name=$1
  local submodule_path="submodules/$repo_name"

  if git config --file .gitmodules --get-regexp path | grep -q "$submodule_path"; then
    echo "Repository $repo_name is already a submodule."
    return 0
  else
    return 1
  fi
}

# Enhanced repository creation with retry and dry-run support
create_repository() {
  local repo_name=$1
  log "INFO" "Creating repository: $repo_name"

  if $DRY_RUN; then
    log "INFO" "Dry-run: Would create repository $repo_name."
    return 0
  fi

  response=$(retry curl -s -w "%{http_code}" -o /tmp/repo_response.json \
    -H "Authorization: token $GITHUB_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    -X POST $GITHUB_API/orgs/$GITHUB_ORG/repos \
    -d "{\"name\": \"$repo_name\", \"private\": true}")

  if [ "$response" -ne 201 ]; then
    log "ERROR" "Failed to create repository $repo_name."
    log "ERROR" "Error: $(cat /tmp/repo_response.json)"
    return 1
  else
    log "SUCCESS" "Repository $repo_name created successfully."
    return 0
  fi
}

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
  else
    echo "Repository $repo_name deleted successfully."
  fi

  # Clean up temporary response file
  rm -f /tmp/repo_delete_response.json
}

# Function to clone the repository locally
clone_repository() {
  local repo_name=$1
  local repo_url="https://github.com/$GITHUB_ORG/$repo_name"
  local clone_path="$PROJECT_ROOT/submodules/$repo_name"

  echo "Cloning repository: $repo_name"
  git clone $repo_url $clone_path
  if [ $? -eq 0 ]; then
    echo "Repository $repo_name cloned successfully."
  else
    echo "Failed to clone repository $repo_name."
  fi
}

# Function to initialize the repository with default files
initialize_repository() {
  local repo_path=$1

  echo "Initializing repository at $repo_path"
  cd $repo_path
  echo "# $(basename $repo_path)" > README.md
  echo ".DS_Store" > .gitignore
  git add README.md .gitignore
  git commit -m "Initial commit with README and .gitignore"
  git push origin main
  cd - > /dev/null
}

# Enhanced submodule initialization with retry
initialize_submodule() {
  local repo_name=$1
  local repo_url="https://github.com/$GITHUB_ORG/$repo_name"
  local submodule_path="submodules/$repo_name"

  log "INFO" "Initializing submodule: $repo_name"
  retry git submodule add $repo_url $submodule_path
  if [ $? -eq 0 ]; then
    log "SUCCESS" "Submodule $repo_name initialized successfully."
  else
    log "ERROR" "Failed to initialize submodule $repo_name."
    return 1
  fi
}

# Function to commit submodule changes
commit_submodules() {
  # Temporarily disable GPG signing for the current repository
  git config --local commit.gpgsign false

  echo "Committing submodule changes..."
  git add .gitmodules submodules/*
  git commit -m "Added submodules for white-label repositories"

  if [ $? -eq 0 ]; then
    echo "Submodule changes committed successfully."
  else
    echo "Failed to commit submodule changes."
  fi

  # Re-enable GPG signing after committing (if it was enabled globally)
  git config --local --unset commit.gpgsign
}

# Summary report
created_count=0
skipped_count=0
failed_count=0

log_summary() {
  log "INFO" "Summary:"
  log "INFO" "Repositories created: $created_count"
  log "INFO" "Repositories skipped: $skipped_count"
  log "INFO" "Repositories failed: $failed_count"
}

# Function to check if a repository is archived
check_repository_archived() {
  local repo_name=$1
  response=$(curl -s \
    -H "Authorization: token $GITHUB_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    $GITHUB_API/repos/$GITHUB_ORG/$repo_name)

  if echo "$response" | grep -q '"archived": true'; then
    echo "Repository $repo_name is archived. Skipping."
    return 0
  else
    return 1
  fi
}

# Function to add repository description and topics
add_repository_metadata() {
  local repo_name=$1
  local description="Default description for $repo_name"
  local topics="blockchain,web3,automation"

  log "INFO" "Adding metadata to repository: $repo_name"
  response=$(curl -s -w "%{http_code}" -o /tmp/repo_metadata_response.json \
    -H "Authorization: token $GITHUB_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    -X PATCH $GITHUB_API/repos/$GITHUB_ORG/$repo_name \
    -d "{\"description\": \"$description\", \"topics\": [\"$topics\"]}")

  if [ "$response" -ne 200 ]; then
    log "ERROR" "Failed to add metadata to repository $repo_name."
    log "ERROR" "Error: $(cat /tmp/repo_metadata_response.json)"
  else
    log "SUCCESS" "Metadata added to repository $repo_name."
  fi

  rm -f /tmp/repo_metadata_response.json
}

# Validate environment variables
validate_env

# Enhanced logic to skip archived repositories
for repo in "${REPOSITORIES[@]}"; do
  log "INFO" "Processing repository: $repo"

  # Check if the repository exists
  if check_repository_exists $repo; then
    # Check if the repository is archived
    if check_repository_archived $repo; then
      skipped_count=$((skipped_count + 1))
      continue
    fi

    log "INFO" "Repository $repo already exists."
    skipped_count=$((skipped_count + 1))
    continue
  fi

  # Create the repository if it does not exist
  create_repository $repo || { log "ERROR" "Failed to create $repo. Skipping."; failed_count=$((failed_count + 1)); continue; }
  created_count=$((created_count + 1))

  # Add metadata to the repository
  add_repository_metadata $repo || { log "ERROR" "Failed to add metadata to $repo. Skipping."; failed_count=$((failed_count + 1)); continue; }

  # Initialize the repository as a submodule
  initialize_submodule $repo || { log "ERROR" "Failed to add $repo as a submodule. Skipping."; failed_count=$((failed_count + 1)); continue; }

done

# Commit submodule changes after initialization
commit_submodules

# Display summary report
log_summary

# End of script