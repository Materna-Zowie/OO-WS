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
  name: kamil_ping_custom
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
          - SUCCESS: python_regex
    - python_regex:
        do:
          kamil_basic.python_regex:
            - text: '${ping_response}'
            - regex: "[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}"
        publish:
          - ip_address: '${match_text}'
        navigate:
          - FAILURE: NO_MATCH
          - SUCCESS: SUCCESS
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
      python_regex:
        x: 280
        'y': 120
        navigate:
          06afa8d3-bd18-284f-94f4-83c29fde0127:
            targetId: 5dfe7b1f-3e0a-47f2-5f20-fb853d121812
            port: SUCCESS
          8a00d596-98a2-d146-ec8e-b3f5f69fca99:
            targetId: 3823b595-c45d-ae02-f889-cddb8af9f3e5
            port: FAILURE
    results:
      SUCCESS:
        5dfe7b1f-3e0a-47f2-5f20-fb853d121812:
          x: 520
          'y': 160
      NO_MATCH:
        3823b595-c45d-ae02-f889-cddb8af9f3e5:
          x: 520
          'y': 320
