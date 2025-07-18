#!/bin/bash

# === GitHub Configuration ===
REPO_OWNER="pFlugo1942"
REPO_NAME="myTMS-Insta-PhraseRepo.git"
WORKFLOW_FILE_NAME="main-workflow.yml"  # Or use the workflow ID
GITHUB_TOKEN="${GITHUB_TOKEN:?Missing GITHUB_TOKEN env var}"
BRANCH="main"

# === Call GitHub REST API to trigger workflow ===
curl -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/actions/workflows/$WORKFLOW_FILE_NAME/dispatches" \
  -d "{\"ref\":\"$BRANCH\"}"
