#!/usr/bin/env bats

# Unit tests for helper functions

load '../test_helper'

@test "_json_meta generates valid JSON with name only" {
  local result
  result=$(_json_meta "Test Ruleset")

  # Verify it's valid JSON
  echo "$result" | jq . > /dev/null

  # Check fields
  [ "$(echo "$result" | jq -r '.name')" = "Test Ruleset" ]
  [ "$(echo "$result" | jq -r '.target')" = "branch" ]
  [ "$(echo "$result" | jq -r '.enforcement')" = "active" ]
  [ "$(echo "$result" | jq -r '.id')" = "null" ]
}

@test "_json_meta generates valid JSON with name and id" {
  local result
  result=$(_json_meta "Test Ruleset" "12345")

  # Verify it's valid JSON
  echo "$result" | jq . > /dev/null

  # Check fields
  [ "$(echo "$result" | jq -r '.name')" = "Test Ruleset" ]
  [ "$(echo "$result" | jq -r '.id')" = "12345" ]
}

@test "_jq_toggle_rule enables a rule" {
  local json_file
  json_file=$(create_temp_json '{"rules":[]}')

  _jq_toggle_rule "$json_file" "required_signatures" "enabled"

  local rule_type
  rule_type=$(jq -r '.rules[0].type' < "$json_file")
  [ "$rule_type" = "required_signatures" ]
}

@test "_jq_toggle_rule disables a rule" {
  local json_file
  json_file=$(create_temp_json '{"rules":[{"type":"required_signatures"}]}')

  _jq_toggle_rule "$json_file" "required_signatures" "disabled"

  local rule_count
  rule_count=$(jq '.rules | length' < "$json_file")
  [ "$rule_count" -eq 0 ]
}

@test "_jq_toggle_rule handles empty rules array" {
  local json_file
  json_file=$(create_temp_json '{}')

  _jq_toggle_rule "$json_file" "non_fast_forward" "enabled"

  local rule_type
  rule_type=$(jq -r '.rules[0].type' < "$json_file")
  [ "$rule_type" = "non_fast_forward" ]
}

@test "_jq_toggle_rule preserves existing rules when adding" {
  local json_file
  json_file=$(create_temp_json '{"rules":[{"type":"deletion"}]}')

  _jq_toggle_rule "$json_file" "required_signatures" "enabled"

  local rule_count
  rule_count=$(jq '.rules | length' < "$json_file")
  [ "$rule_count" -eq 2 ]
}

@test "_jq_set_rule_params sets numeric parameter" {
  local json_file
  json_file=$(create_temp_json '{"rules":[{"type":"pull_request","parameters":{}}]}')

  _jq_set_rule_params "$json_file" "pull_request" "required_approving_review_count=2"

  local count
  count=$(jq '.rules[0].parameters.required_approving_review_count' < "$json_file")
  [ "$count" -eq 2 ]
}

@test "_jq_set_rule_params sets boolean parameter" {
  local json_file
  json_file=$(create_temp_json '{"rules":[{"type":"pull_request","parameters":{}}]}')

  _jq_set_rule_params "$json_file" "pull_request" "dismiss_stale_reviews_on_push=true"

  local value
  value=$(jq '.rules[0].parameters.dismiss_stale_reviews_on_push' < "$json_file")
  [ "$value" = "true" ]
}

@test "_jq_set_rule_params sets string parameter" {
  local json_file
  json_file=$(create_temp_json '{"rules":[{"type":"merge_queue","parameters":{}}]}')

  _jq_set_rule_params "$json_file" "merge_queue" "merge_method=squash"

  local value
  value=$(jq -r '.rules[0].parameters.merge_method' < "$json_file")
  [ "$value" = "squash" ]
}

@test "_jq_set_rule_params creates rule if not exists" {
  local json_file
  json_file=$(create_temp_json '{"rules":[]}')

  _jq_set_rule_params "$json_file" "pull_request" "required_approving_review_count=1"

  local rule_type
  rule_type=$(jq -r '.rules[0].type' < "$json_file")
  [ "$rule_type" = "pull_request" ]
}

@test "_jq_set_conditions sets include pattern" {
  local json_file
  json_file=$(create_temp_json '{"conditions":{}}')

  _jq_set_conditions "$json_file" "~DEFAULT_BRANCH" ""

  local include
  include=$(jq -r '.conditions.ref_name.include[0]' < "$json_file")
  [ "$include" = "~DEFAULT_BRANCH" ]
}

@test "_jq_set_conditions sets exclude pattern" {
  local json_file
  json_file=$(create_temp_json '{"conditions":{}}')

  _jq_set_conditions "$json_file" "" "refs/heads/test-*"

  local exclude
  exclude=$(jq -r '.conditions.ref_name.exclude[0]' < "$json_file")
  [ "$exclude" = "refs/heads/test-*" ]
}

@test "_jq_set_conditions sets both include and exclude" {
  local json_file
  json_file=$(create_temp_json '{"conditions":{}}')

  _jq_set_conditions "$json_file" "~DEFAULT_BRANCH" "refs/heads/dev"

  local include exclude
  include=$(jq -r '.conditions.ref_name.include[0]' < "$json_file")
  exclude=$(jq -r '.conditions.ref_name.exclude[0]' < "$json_file")
  [ "$include" = "~DEFAULT_BRANCH" ]
  [ "$exclude" = "refs/heads/dev" ]
}

@test "p6_usage exits with code 0 for help" {
  run p6_usage 0 "help"
  [ "$status" -eq 0 ]
}

@test "p6_usage exits with code 1 for error" {
  run p6_usage 1 "error message"
  [ "$status" -eq 1 ]
  [[ "$output" == *"error message"* ]]
}

@test "p6_usage shows usage text" {
  run p6_usage 0
  [[ "$output" == *"Usage:"* ]]
  [[ "$output" == *"Commands:"* ]]
  [[ "$output" == *"activate"* ]]
  [[ "$output" == *"create"* ]]
}
