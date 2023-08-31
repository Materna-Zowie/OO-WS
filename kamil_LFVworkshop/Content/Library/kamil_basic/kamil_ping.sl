########################################################################################################################
#!!
#! @description: This flow is created for testing of network...
#!               inputs>
#!               outputs>
#!
#! @input target_host: The target host to ping.
#!!#
########################################################################################################################
namespace: kamil_basic
flow:
  name: kamil_ping
  inputs:
    - target_host: "${get_sp('kamil_basic.kamil_target_host')}"
  workflow:
    - ping_target_host:
        do:
          io.cloudslang.base.samples.utils.ping_target_host:
            - target_host: '${target_host}'
        publish:
          - ping_response: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: match_regex
    - match_regex:
        do:
          io.cloudslang.base.strings.match_regex:
            - regex: "[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}"
            - text: '${ping_response}'
        publish:
          - ip_address: '${match_text}'
        navigate:
          - MATCH: SUCCESS
          - NO_MATCH: NO_MATCH
  results:
    - FAILURE
    - SUCCESS
    - NO_MATCH
extensions:
  graph:
    steps:
      ping_target_host:
        x: 40
        'y': 160
      match_regex:
        x: 280
        'y': 120
        navigate:
          f4011910-55b0-6c5b-f7f2-d03deed27b93:
            targetId: a8fffca3-150e-8d15-8088-2556f171ab6e
            port: MATCH
          b2357921-641c-0d3b-8ffb-402307f05947:
            targetId: 075a9891-7358-97e6-abc2-218c22e8126d
            port: NO_MATCH
    results:
      SUCCESS:
        a8fffca3-150e-8d15-8088-2556f171ab6e:
          x: 560
          'y': 160
      NO_MATCH:
        075a9891-7358-97e6-abc2-218c22e8126d:
          x: 480
          'y': 320
