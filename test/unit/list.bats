#!/usr/bin/env bats

# Unit tests for list command

load '../test_helper'

@test "p6_cmd_list outputs JSON with --json flag" {
  mock__gh '[{"id":123,"name":"test","enforcement":"active","target":"branch"}]'

  run p6_cmd_list --json

  [ "$status" -eq 0 ]
  [[ "$output" == *'"id":123'* ]]
  [[ "$output" == *'"name":"test"'* ]]
}

@test "p6_cmd_list outputs table format by default" {
  mock__gh '[{"id":123,"name":"test-ruleset","enforcement":"active","target":"branch"}]'

  run p6_cmd_list

  [ "$status" -eq 0 ]
  [[ "$output" == *"ID"* ]]
  [[ "$output" == *"NAME"* ]]
  [[ "$output" == *"ENFORCEMENT"* ]]
  [[ "$output" == *"test-ruleset"* ]]
}

@test "p6_cmd_list handles empty ruleset list" {
  mock__gh '[]'

  run p6_cmd_list --json

  [ "$status" -eq 0 ]
  [ "$output" = "[]" ]
}

@test "p6_cmd_list handles multiple rulesets" {
  mock__gh '[{"id":1,"name":"first","enforcement":"active","target":"branch"},{"id":2,"name":"second","enforcement":"disabled","target":"branch"}]'

  run p6_cmd_list

  [ "$status" -eq 0 ]
  [[ "$output" == *"first"* ]]
  [[ "$output" == *"second"* ]]
}
