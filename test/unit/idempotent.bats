#!/usr/bin/env bats

# Unit tests for idempotent operations

load '../test_helper'

setup() {
  source_script
  # Reset dry-run mode
  GHRB_DRY_RUN=0
}

@test "p6_cmd_create is idempotent when ruleset exists" {
  # Mock _p6_ruleset_id_by_name to return an ID
  _p6_ruleset_id_by_name() {
    echo "12345"
  }

  # Mock _gh to return ruleset data
  _gh() {
    echo '{"id":12345,"name":"test-ruleset","enforcement":"active"}'
  }

  run p6_cmd_create "test-ruleset"

  [ "$status" -eq 0 ]
  [[ "$output" == *"already exists"* ]]
  [[ "$output" == *"idempotent"* ]]
}

@test "p6_cmd_create creates when ruleset doesn't exist" {
  # Mock _p6_ruleset_id_by_name to return empty
  _p6_ruleset_id_by_name() {
    echo ""
  }

  # Mock _gh
  _gh() {
    echo '{"id":12345,"name":"new-ruleset","enforcement":"active"}'
  }

  run p6_cmd_create "new-ruleset"

  [ "$status" -eq 0 ]
}

@test "p6_cmd_delete is idempotent when ruleset doesn't exist" {
  # Mock _p6_ruleset_id_by_name to return empty
  _p6_ruleset_id_by_name() {
    echo ""
  }

  run p6_cmd_delete "nonexistent-ruleset"

  [ "$status" -eq 0 ]
  [[ "$output" == *"does not exist"* ]]
  [[ "$output" == *"idempotent"* ]]
  [[ "$output" == *"already deleted"* ]]
}

@test "p6_cmd_delete deletes when ruleset exists" {
  # Mock _p6_ruleset_id_by_name to return an ID
  _p6_ruleset_id_by_name() {
    echo "12345"
  }

  # Mock _gh
  _gh() {
    echo ""
  }

  run p6_cmd_delete "test-ruleset"

  [ "$status" -eq 0 ]
  [[ "$output" == *"deleted successfully"* ]]
}

@test "p6_cmd_create checks for existing ruleset before creating" {
  # Verify the idempotent check exists in the code
  grep -q "already exists (idempotent)" gh-ruleset-branch
  [ "$?" -eq 0 ]
}

@test "p6_cmd_delete checks for existing ruleset before deleting" {
  # Verify the idempotent check exists in the code
  grep -q "already deleted" gh-ruleset-branch
  [ "$?" -eq 0 ]
}
