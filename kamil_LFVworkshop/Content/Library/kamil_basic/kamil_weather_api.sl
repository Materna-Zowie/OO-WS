########################################################################################################################
#!!
#! @input url: URL to which the call is made.
#!!#
########################################################################################################################
namespace: kamil_basic
flow:
  name: kamil_weather_api
  inputs:
    - url: 'https://api.openweathermap.org/data/2.5/weather'
    - city: Bratislava
    - api_key:
        default: "${get_sp('kamil_basic.kamil_api_key')}"
        sensitive: true
  workflow:
    - http_client_get:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: '${url}'
            - query_params: "${'q=' + city + '&units=metric&appid=' + api_key}"
            - content_type: application/json
        publish:
          - weather_json: '${return_result}'
          - status_code
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: string_equals
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${weather_json}'
            - json_path: $.main.temp
        publish:
          - temperature: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status_code}'
            - second_string: '401'
            - ignore_case: 'true'
        navigate:
          - SUCCESS: UNAUTHORIZED
          - FAILURE: on_failure
  outputs:
    - temperature: '${temperature}'
  results:
    - FAILURE
    - SUCCESS
    - UNAUTHORIZED
extensions:
  graph:
    steps:
      http_client_get:
        x: 80
        'y': 160
      json_path_query:
        x: 280
        'y': 40
        navigate:
          771864d6-5aaa-7c83-4b86-ae303075f748:
            targetId: 596817de-b03e-38d5-b950-bdb918354bf6
            port: SUCCESS
      string_equals:
        x: 280
        'y': 280
        navigate:
          202a036d-b627-e7fb-74d2-7861e56e577f:
            targetId: 0a9322b6-1b20-39f1-efc3-fc554aea92c7
            port: SUCCESS
    results:
      SUCCESS:
        596817de-b03e-38d5-b950-bdb918354bf6:
          x: 480
          'y': 160
      UNAUTHORIZED:
        0a9322b6-1b20-39f1-efc3-fc554aea92c7:
          x: 480
          'y': 400
