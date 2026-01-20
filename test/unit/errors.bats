#!/usr/bin/env bats

# Unit tests for error handling

load '../test_helper'

setup() {
  source_script
  # Reset dry-run mode for error tests
  GHRB_DRY_RUN=0
}

@test "_error outputs message and exits with non-zero code" {
  run _error "test error message"

  [ "$status" -ne 0 ]
  [[ "$output" == *"Error: test error message"* ]]
}

@test "_error exits with custom exit code" {
  run _error "usage error" 2

  [ "$status" -eq 2 ]
  [[ "$output" == *"Error: usage error"* ]]
}

@test "_require_arg passes with valid argument" {
  run _require_arg "name" "test-value"

  [ "$status" -eq 0 ]
}

@test "_require_arg fails with empty argument" {
  run _require_arg "name" ""

  [ "$status" -ne 0 ]
  [[ "$output" == *"Missing required argument: name"* ]]
}

@test "_validate_ruleset_exists passes with valid id" {
  run _validate_ruleset_exists "test-ruleset" "123"

  [ "$status" -eq 0 ]
}

@test "_validate_ruleset_exists fails with empty id" {
  run _validate_ruleset_exists "test-ruleset" ""

  [ "$status" -ne 0 ]
  [[ "$output" == *"Ruleset not found: 'test-ruleset'"* ]]
  [[ "$output" == *"Use 'list' to see available rulesets"* ]]
}

@test "p6_usage with error message shows 'Error:' prefix" {
  run p6_usage 1 "test error"

  [ "$status" -eq 1 ]
  [[ "$output" == *"Error: test error"* ]]
}

@test "p6_cmd_create requires name argument" {
  run p6_cmd_create ""

  [ "$status" -ne 0 ]
  [[ "$output" == *"Missing required argument: name"* ]]
}

@test "p6_cmd_show requires name argument" {
  run p6_cmd_show ""

  [ "$status" -ne 0 ]
  [[ "$output" == *"Missing required argument: name"* ]]
}

@test "p6_cmd_activate requires name argument" {
  run p6_cmd_activate ""

  [ "$status" -ne 0 ]
  [[ "$output" == *"Missing required argument: name"* ]]
}

@test "p6_cmd_deactivate requires name argument" {
  run p6_cmd_deactivate ""

  [ "$status" -ne 0 ]
  [[ "$output" == *"Missing required argument: name"* ]]
}

@test "p6_cmd_delete requires name argument" {
  run p6_cmd_delete ""

  [ "$status" -ne 0 ]
  [[ "$output" == *"Missing required argument: name"* ]]
}

@test "p6_cmd_update requires name argument" {
  run p6_cmd_update ""

  [ "$status" -ne 0 ]
  [[ "$output" == *"Missing required argument: name"* ]]
}
