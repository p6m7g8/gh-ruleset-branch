#!/usr/bin/env bats

# Unit tests for debug/verbose mode

load '../test_helper'

@test "_debug outputs message when GHRB_DEBUG=1" {
  GHRB_DEBUG=1
  run _debug "test message"

  [ "$status" -eq 0 ]
  [[ "$output" == *"[DEBUG] test message"* ]]
}

@test "_debug outputs nothing when GHRB_DEBUG=0" {
  GHRB_DEBUG=0
  run _debug "test message"

  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "_verbose outputs message when GHRB_VERBOSE=1" {
  GHRB_VERBOSE=1
  run _verbose "test message"

  [ "$status" -eq 0 ]
  [[ "$output" == *"[VERBOSE] test message"* ]]
}

@test "_verbose outputs nothing when GHRB_VERBOSE=0" {
  GHRB_VERBOSE=0
  run _verbose "test message"

  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "GHRB_DEBUG environment variable is respected" {
  export GHRB_DEBUG=1
  source_script

  run _debug "env test"

  [[ "$output" == *"[DEBUG] env test"* ]]
}

@test "GHRB_VERBOSE environment variable is respected" {
  export GHRB_VERBOSE=1
  source_script

  run _verbose "env test"

  [[ "$output" == *"[VERBOSE] env test"* ]]
}
