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
  name: kamil_query_and_update_smax_entities
  inputs:
    - saw_url: 'https://ngsm.smax-materna.se/'
    - tenant_id: '644815427'
    - username: kamil
    - password:
        default: Materna2023+
        sensitive: true
    - entity_type: Person
    - fields: 'Id,Name'
    - query: "FirstName startswith('Adam')"
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
          - entities_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
          - NO_RESULTS: NO_RESULTS
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${entities_json}'
            - json_path: $.entities..properties.Id
        publish:
          - ids_to_update: '${return_result}'
        navigate:
          - SUCCESS: array_iterator
          - FAILURE: on_failure
    - array_iterator:
        do:
          io.cloudslang.base.json.array_iterator:
            - array: '${ids_to_update}'
        publish:
          - entity_id: '${result_string[1:-1]}'
        navigate:
          - HAS_MORE: update_entities
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - update_entities:
        do:
          io.cloudslang.opentext.service_management_automation_x.commons.update_entities:
            - saw_url: '${saw_url}'
            - sso_token: '${sso_token}'
            - tenant_id: '${tenant_id}'
            - json_body: |-
                ${{
                    "entity_type":"Person",
                    "properties":{
                        "Id":"" + entity_id + "",
                        "Description":"Human being from planet Earth"
                    }
                }}
        navigate:
          - FAILURE: on_failure
          - SUCCESS: array_iterator
  results:
    - FAILURE
    - SUCCESS
    - NO_RESULTS
extensions:
  graph:
    steps:
      get_sso_token:
        x: 80
        'y': 160
      query_entities:
        x: 240
        'y': 160
        navigate:
          180ed0d2-f95e-fe6e-ae43-d0ac5c012ea6:
            targetId: f7aace44-d6d0-9c52-8967-927b25ad152e
            port: NO_RESULTS
      json_path_query:
        x: 400
        'y': 80
      array_iterator:
        x: 560
        'y': 120
        navigate:
          7800f50a-bc9f-d574-bb60-a38fdf09597f:
            targetId: b5166c84-d39b-4a9d-5541-b05b2cf50d9e
            port: NO_MORE
      update_entities:
        x: 560
        'y': 360
    results:
      SUCCESS:
        b5166c84-d39b-4a9d-5541-b05b2cf50d9e:
          x: 720
          'y': 120
      NO_RESULTS:
        f7aace44-d6d0-9c52-8967-927b25ad152e:
          x: 360
          'y': 400
