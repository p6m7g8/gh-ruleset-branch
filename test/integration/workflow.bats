#!/usr/bin/env bats

# Integration tests for full workflows

load '../test_helper'

setup() {
  source_script
  GHRB_DRY_RUN=0
  GHRB_DEBUG=0
  GHRB_VERBOSE=0
}

# Helper to load fixture
load_fixture() {
  cat "$FIXTURES_DIR/$1"
}

# ============================================================
# Workflow: List rulesets
# ============================================================

@test "workflow: list rulesets in table format" {
  mock__gh "$(load_fixture ruleset-list.json)"

  run p6_cmd_list

  [ "$status" -eq 0 ]
  [[ "$output" == *"ID"* ]]
  [[ "$output" == *"NAME"* ]]
  [[ "$output" == *"default"* ]]
  [[ "$output" == *"feature-branches"* ]]
  [[ "$output" == *"release-branches"* ]]
}

@test "workflow: list rulesets in JSON format" {
  mock__gh "$(load_fixture ruleset-list.json)"

  run p6_cmd_list --json

  [ "$status" -eq 0 ]
  # Verify it's valid JSON with expected content
  echo "$output" | jq -e '.[0].name == "default"'
  echo "$output" | jq -e 'length == 3'
}

# ============================================================
# Workflow: Create and configure ruleset
# ============================================================

@test "workflow: create ruleset dry-run shows JSON" {
  GHRB_DRY_RUN=1

  run p6_cmd_create "test-ruleset"

  [ "$status" -eq 0 ]
  [[ "$output" == *"[DRY-RUN]"* ]]
  [[ "$output" == *"test-ruleset"* ]]
  [[ "$output" == *"branch"* ]]
  [[ "$output" == *"active"* ]]
}

# ============================================================
# Workflow: Show and export ruleset
# ============================================================

@test "workflow: show requires name argument" {
  run p6_cmd_show ""

  [ "$status" -ne 0 ]
  [[ "$output" == *"Missing required argument"* ]]
}

@test "workflow: export requires name argument" {
  run p6_cmd_export ""

  [ "$status" -ne 0 ]
  [[ "$output" == *"Missing required argument"* ]]
}

# ============================================================
# Workflow: Import ruleset
# ============================================================

@test "workflow: import ruleset dry-run validates and previews" {
  GHRB_DRY_RUN=1

  local import_json='{"name":"imported-ruleset","target":"branch","enforcement":"active","rules":[]}'

  run p6_cmd_import <<< "$import_json"

  [ "$status" -eq 0 ]
  [[ "$output" == *"[DRY-RUN]"* ]]
  [[ "$output" == *"imported-ruleset"* ]]
}

@test "workflow: import with valid JSON succeeds in dry-run" {
  GHRB_DRY_RUN=1

  # Use a minimal valid ruleset JSON
  local json='{"name":"test-import","target":"branch","enforcement":"active","rules":[],"conditions":{"ref_name":{"include":["~DEFAULT_BRANCH"],"exclude":[]}}}'

  run p6_cmd_import <<< "$json"

  [ "$status" -eq 0 ]
  [[ "$output" == *"test-import"* ]]
}

# ============================================================
# Workflow: Activate and deactivate
# ============================================================

@test "workflow: activate ruleset dry-run" {
  mock__gh "$(load_fixture ruleset-list.json)"
  GHRB_DRY_RUN=1

  run p6_cmd_activate "default"

  [ "$status" -eq 0 ]
  [[ "$output" == *"[DRY-RUN]"* ]]
  [[ "$output" == *"Would activate"* ]]
  [[ "$output" == *"12345"* ]]
}

@test "workflow: deactivate ruleset dry-run" {
  mock__gh "$(load_fixture ruleset-list.json)"
  GHRB_DRY_RUN=1

  run p6_cmd_deactivate "default"

  [ "$status" -eq 0 ]
  [[ "$output" == *"[DRY-RUN]"* ]]
  [[ "$output" == *"Would deactivate"* ]]
  [[ "$output" == *"12345"* ]]
}

# ============================================================
# Workflow: Delete ruleset
# ============================================================

@test "workflow: delete ruleset dry-run" {
  mock__gh "$(load_fixture ruleset-list.json)"
  GHRB_DRY_RUN=1

  run p6_cmd_delete "default"

  [ "$status" -eq 0 ]
  [[ "$output" == *"[DRY-RUN]"* ]]
  [[ "$output" == *"Would delete"* ]]
  [[ "$output" == *"12345"* ]]
}

# ============================================================
# Workflow: Error handling
# ============================================================

@test "workflow: show non-existent ruleset fails" {
  mock__gh "[]"

  run p6_cmd_show "non-existent"

  [ "$status" -ne 0 ]
  [[ "$output" == *"Ruleset not found"* ]]
  [[ "$output" == *"non-existent"* ]]
}

@test "workflow: delete non-existent ruleset fails" {
  mock__gh "[]"

  run p6_cmd_delete "non-existent"

  [ "$status" -ne 0 ]
  [[ "$output" == *"Ruleset not found"* ]]
}

@test "workflow: activate non-existent ruleset fails" {
  mock__gh "[]"

  run p6_cmd_activate "non-existent"

  [ "$status" -ne 0 ]
  [[ "$output" == *"Ruleset not found"* ]]
}

# ============================================================
# Workflow: Debug and verbose mode
# ============================================================

@test "workflow: debug mode shows internal info" {
  mock__gh "$(load_fixture ruleset-list.json)"
  GHRB_DEBUG=1

  run p6_cmd_show "default"

  [[ "$output" == *"[DEBUG]"* ]]
  [[ "$output" == *"Looking up ruleset ID"* ]]
}

@test "workflow: version flag outputs version" {
  run _version

  [ "$status" -eq 0 ]
  [[ "$output" == *"gh-ruleset-branch version"* ]]
  [[ "$output" == *"0.2.0"* ]]
}
