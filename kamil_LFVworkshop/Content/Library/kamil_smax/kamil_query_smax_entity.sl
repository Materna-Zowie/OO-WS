########################################################################################################################
#!!
#! @input saw_url: The Service Management Automation X URL to make the request to.
#!                 Examples: scheme://{serverAddress}.
#! @input tenant_id: The OpenText SMAX tenant Id.
#! @input username: The user name used for authentication.
#! @input password: The password used for authentication.
#! @input entity_type: The OpenText SMAX entity type.
#! @input fields: for all fields use layout=FULL_LAYOUT
#! @input query: The query filter Examples: IdentityCard > 100 or FirstName = 'EmployeeFirst11'
#!!#
########################################################################################################################
namespace: kamil_smax
flow:
  name: kamil_query_smax_entity
  inputs:
    - saw_url: 'https://ngsm.smax-materna.se/'
    - tenant_id: '644815427'
    - username: kamil
    - password:
        default: Materna2023+
        sensitive: true
    - entity_type: Person
    - fields: FULL_LAYOUT
    - query: "Email eq 'zowie.stenroos@materna.se'"
  workflow:
    - get_sso_token:
        do:
          io.cloudslang.opentext.service_management_automation_x.commons.get_sso_token:
            - saw_url: '${saw_url}'
            - tenant_id: '${tenant_id}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        publish:
          - sso_token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: query_entities
    - query_entities:
        do:
          io.cloudslang.opentext.service_management_automation_x.commons.query_entities:
            - saw_url: '${saw_url}'
            - sso_token: '${sso_token}'
            - tenant_id: '${tenant_id}'
            - entity_type: '${entity_type}'
            - query: '${query}'
            - fields: '${fields}'
        publish:
          - return_result
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
          - NO_RESULTS: NO_RESULTS
  outputs:
    - return_result: '${return_result}'
    - sso_token: '${sso_token}'
  results:
    - FAILURE
    - SUCCESS
    - NO_RESULTS
extensions:
  graph:
    steps:
      get_sso_token:
        x: 120
        'y': 120
      query_entities:
        x: 320
        'y': 160
        navigate:
          33792ef0-5c7d-5511-6b69-c77d3eea8762:
            targetId: b5166c84-d39b-4a9d-5541-b05b2cf50d9e
            port: SUCCESS
          180ed0d2-f95e-fe6e-ae43-d0ac5c012ea6:
            targetId: f7aace44-d6d0-9c52-8967-927b25ad152e
            port: NO_RESULTS
    results:
      SUCCESS:
        b5166c84-d39b-4a9d-5541-b05b2cf50d9e:
          x: 560
          'y': 80
      NO_RESULTS:
        f7aace44-d6d0-9c52-8967-927b25ad152e:
          x: 560
          'y': 280
