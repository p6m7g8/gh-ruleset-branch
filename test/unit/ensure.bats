#!/usr/bin/env bats

# Unit tests for ensure command

load '../test_helper'

setup() {
  source_script
  # Reset dry-run mode
  GHRB_DRY_RUN=0
}

# Helper function to pipe JSON to ensure command
_pipe_to_ensure() {
  echo "$1" | p6_cmd_ensure "$2"
}

@test "p6_cmd_ensure requires name argument" {
  run p6_cmd_ensure ""

  [ "$status" -ne 0 ]
  [[ "$output" == *"Missing required argument: name"* ]]
}

@test "p6_cmd_ensure creates ruleset if it doesn't exist" {
  # Mock _p6_ruleset_id_by_name to return empty (doesn't exist)
  _p6_ruleset_id_by_name() {
    echo ""
  }

  # Mock _gh
  _gh() {
    echo '{"id":12345,"name":"test-ruleset","enforcement":"active"}'
  }

  local json_input='{"name":"test-ruleset","target":"branch","enforcement":"active"}'

  run _pipe_to_ensure "$json_input" 'test-ruleset'

  [ "$status" -eq 0 ]
  [[ "$output" == *"created successfully"* ]]
}

@test "p6_cmd_ensure updates ruleset if it exists" {
  # Mock _p6_ruleset_id_by_name to return an ID (exists)
  _p6_ruleset_id_by_name() {
    echo "12345"
  }

  # Mock _gh
  _gh() {
    echo '{"id":12345,"name":"test-ruleset","enforcement":"active"}'
  }

  local json_input='{"name":"test-ruleset","target":"branch","enforcement":"active"}'

  run _pipe_to_ensure "$json_input" 'test-ruleset'

  [ "$status" -eq 0 ]
  [[ "$output" == *"updated successfully"* ]]
}

@test "p6_cmd_ensure validates JSON input" {
  # Mock _p6_ruleset_id_by_name
  _p6_ruleset_id_by_name() {
    echo ""
  }

  local invalid_json='not valid json'

  run _pipe_to_ensure "$invalid_json" 'test-ruleset'

  [ "$status" -ne 0 ]
  [[ "$output" == *"Invalid JSON"* ]]
}

@test "p6_cmd_ensure overrides name in JSON" {
  # Verify the code contains name override logic
  grep -q '.name = \$NAME' gh-ruleset-branch
  [ "$?" -eq 0 ]
}

@test "p6_cmd_ensure supports dry-run for create" {
  GHRB_DRY_RUN=1

  # Mock _p6_ruleset_id_by_name to return empty
  _p6_ruleset_id_by_name() {
    echo ""
  }

  local json_input='{"name":"test-ruleset","target":"branch","enforcement":"active"}'

  run _pipe_to_ensure "$json_input" 'test-ruleset'

  [ "$status" -eq 0 ]
  [[ "$output" == *"Would create"* ]]
  [[ "$output" == *"Proposed configuration"* ]]
}

@test "p6_cmd_ensure supports dry-run for update" {
  GHRB_DRY_RUN=1

  # Mock _p6_ruleset_id_by_name to return an ID
  _p6_ruleset_id_by_name() {
    echo "12345"
  }

  local json_input='{"name":"test-ruleset","target":"branch","enforcement":"active"}'

  run _pipe_to_ensure "$json_input" 'test-ruleset'

  [ "$status" -eq 0 ]
  [[ "$output" == *"Would update"* ]]
  [[ "$output" == *"Proposed configuration"* ]]
}

@test "ensure command is documented in usage" {
  grep "ensure <name>" gh-ruleset-branch | grep -q "Ensure ruleset matches JSON"
  [ "$?" -eq 0 ]
}

@test "ensure command is in case statement" {
  grep "case \$cmd in" gh-ruleset-branch -A 15 | grep -q "ensure)"
  [ "$?" -eq 0 ]
}
