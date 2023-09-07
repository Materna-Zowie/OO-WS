########################################################################################################################
#!!
#! @input saw_url: The Service Management Automation X URL to make the request to.
#!                 Examples: scheme://{serverAddress}.
#! @input tenant_id: The OpenText SMAX tenant Id.
#! @input username: The user name used for authentication.
#! @input password: The password used for authentication.
#! @input entity_type: The OpenText SMAX entity type.
#! @input entity_id: The OpenText SMAX entity Id.
#! @input fields: for all fields use layout=FULL_LAYOUT
#!!#
########################################################################################################################
namespace: kamil_smax
flow:
  name: kamil_get_smax_entity
  inputs:
    - saw_url: 'https://ngsm.smax-materna.se/'
    - tenant_id: '644815427'
    - username: kamil
    - password:
        default: Materna2023+
        sensitive: true
    - entity_type: Person
    - entity_id: '22375'
    - fields: FULL_LAYOUT
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
          - SUCCESS: get_entity
    - get_entity:
        do:
          io.cloudslang.opentext.service_management_automation_x.commons.get_entity:
            - saw_url: '${saw_url}'
            - sso_token: '${sso_token}'
            - tenant_id: '${tenant_id}'
            - entity_type: '${entity_type}'
            - entity_id: '${entity_id}'
            - fields: '${fields}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
          - NO_RESULTS: NO_RESULTS
  results:
    - FAILURE
    - SUCCESS
    - NO_RESULTS
extensions:
  graph:
    steps:
      get_entity:
        x: 320
        'y': 160
        navigate:
          b4b5359a-e058-c0cf-88e1-f0a1015f72ac:
            targetId: b5166c84-d39b-4a9d-5541-b05b2cf50d9e
            port: SUCCESS
          fea27f84-62c5-2698-e8f6-219fda813001:
            targetId: f7aace44-d6d0-9c52-8967-927b25ad152e
            port: NO_RESULTS
      get_sso_token:
        x: 120
        'y': 120
    results:
      SUCCESS:
        b5166c84-d39b-4a9d-5541-b05b2cf50d9e:
          x: 560
          'y': 80
      NO_RESULTS:
        f7aace44-d6d0-9c52-8967-927b25ad152e:
          x: 560
          'y': 280
