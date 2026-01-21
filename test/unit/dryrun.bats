#!/usr/bin/env bats

# Unit tests for dry-run mode

load '../test_helper'

@test "_dry_run outputs message and returns 0 when GHRB_DRY_RUN=1" {
  GHRB_DRY_RUN=1
  run _dry_run "test action"

  [ "$status" -eq 0 ]
  [[ "$output" == *"[DRY-RUN] test action"* ]]
}

@test "_dry_run returns 1 when GHRB_DRY_RUN=0" {
  GHRB_DRY_RUN=0
  run _dry_run "test action"

  [ "$status" -eq 1 ]
  [ -z "$output" ]
}

@test "p6_cmd_create shows dry-run message" {
  GHRB_DRY_RUN=1

  run p6_cmd_create "test-ruleset"

  [ "$status" -eq 0 ]
  [[ "$output" == *"[DRY-RUN]"* ]]
  [[ "$output" == *"Would create ruleset"* ]]
  [[ "$output" == *"test-ruleset"* ]]
}

@test "p6_cmd_activate shows dry-run message" {
  GHRB_DRY_RUN=1
  mock__gh '[{"id":123,"name":"test-ruleset"}]'

  run p6_cmd_activate "test-ruleset"

  [ "$status" -eq 0 ]
  [[ "$output" == *"[DRY-RUN]"* ]]
  [[ "$output" == *"Would activate ruleset"* ]]
}

@test "p6_cmd_deactivate shows dry-run message" {
  GHRB_DRY_RUN=1
  mock__gh '[{"id":123,"name":"test-ruleset"}]'

  run p6_cmd_deactivate "test-ruleset"

  [ "$status" -eq 0 ]
  [[ "$output" == *"[DRY-RUN]"* ]]
  [[ "$output" == *"Would deactivate ruleset"* ]]
}

@test "p6_cmd_delete shows dry-run message" {
  GHRB_DRY_RUN=1
  mock__gh '[{"id":123,"name":"test-ruleset"}]'

  run p6_cmd_delete "test-ruleset"

  [ "$status" -eq 0 ]
  [[ "$output" == *"[DRY-RUN]"* ]]
  [[ "$output" == *"Would delete ruleset"* ]]
}
