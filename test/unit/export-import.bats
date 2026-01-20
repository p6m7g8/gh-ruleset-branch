#!/usr/bin/env bats

# Unit tests for export/import commands

load '../test_helper'

setup() {
  source_script
  GHRB_DRY_RUN=0
}

@test "p6_cmd_export requires name argument" {
  run p6_cmd_export ""

  [ "$status" -ne 0 ]
  [[ "$output" == *"Missing required argument: name"* ]]
}

@test "p6_cmd_import dry-run shows preview" {
  GHRB_DRY_RUN=1

  run p6_cmd_import <<< '{"name":"test-ruleset","target":"branch"}'

  [ "$status" -eq 0 ]
  [[ "$output" == *"[DRY-RUN]"* ]]
  [[ "$output" == *"Would import ruleset"* ]]
  [[ "$output" == *"test-ruleset"* ]]
}

@test "p6_cmd_import extracts name from JSON" {
  GHRB_DRY_RUN=1

  run p6_cmd_import <<< '{"name":"my-custom-ruleset","target":"branch"}'

  [ "$status" -eq 0 ]
  [[ "$output" == *"my-custom-ruleset"* ]]
}

@test "p6_cmd_import handles unnamed ruleset" {
  GHRB_DRY_RUN=1

  run p6_cmd_import <<< '{"target":"branch"}'

  [ "$status" -eq 0 ]
  [[ "$output" == *"unnamed"* ]]
}
