#!/usr/bin/env bash

# shellcheck shell=bash

# Test helper for BATS tests
# Provides common setup and utilities

# Get the directory containing this script
TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$TEST_DIR/.." && pwd)"
# shellcheck disable=SC2034
FIXTURES_DIR="$TEST_DIR/fixtures"

# Source the main script functions without executing p6main
# We do this by sourcing and then unsetting the auto-run
source_script() {
  # Set exit codes before sourcing (in case readonly fails)
  # shellcheck disable=SC2034
  EXIT_SUCCESS=0
  # shellcheck disable=SC2034
  EXIT_ERROR=1
  # shellcheck disable=SC2034
  EXIT_USAGE=2

  # Create a modified version that doesn't auto-run and removes readonly
  local tmp_script="/tmp/gh-ruleset-branch-test-$$"
  sed -e 's/^p6main "\$@"$/# p6main "$@"/' \
      -e 's/^readonly //' \
      "$PROJECT_ROOT/gh-ruleset-branch" > "$tmp_script"
  # shellcheck source=/dev/null
  source "$tmp_script"
  rm -f "$tmp_script"
}

# Mock gh command for testing
# shellcheck disable=SC2329
mock_gh() {
  local response="$1"
  gh() {
    echo "$response"
  }
  export -f gh
}

# Mock _gh function for testing
# Usage: mock__gh '{"json":"response"}'
# shellcheck disable=SC2329
mock__gh() {
  local response="$1"
  # Write response to a temp file that _gh will read
  MOCK_GH_RESPONSE="$response"
  export MOCK_GH_RESPONSE

  # Redefine _gh to return mock response
  _gh() {
    echo "$MOCK_GH_RESPONSE"
  }
}

# Create a temporary JSON file with content
create_temp_json() {
  local content="$1"
  local tmp_file="/tmp/test-json-$$.json"
  echo "$content" > "$tmp_file"
  echo "$tmp_file"
}

# Clean up temporary files
cleanup_temp_files() {
  rm -f /tmp/test-json-$$.json /tmp/test-json-$$.json.new
  rm -f /tmp/gh-ruleset-branch-test-$$
}

# Setup function called before each test
setup() {
  source_script
}

# Teardown function called after each test
teardown() {
  cleanup_temp_files
}
