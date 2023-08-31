namespace: kamil_basic
flow:
  name: kamil_weather_api_iterate
  inputs:
    - cities_array: '[Stockholm,Bratislava,Berlin]'
    - temperatures_array: '[]'
  workflow:
    - array_iterator:
        do:
          io.cloudslang.base.json.array_iterator:
            - array: '${cities_array}'
        publish:
          - current_city: '${result_string[1:-1]}'
        navigate:
          - HAS_MORE: kamil_weather_api
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - kamil_weather_api:
        do:
          kamil_basic.kamil_weather_api:
            - city: '${current_city}'
        publish:
          - current_temperature: '${temperature}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: add_object_into_json_array
          - UNAUTHORIZED: FAILURE_UNAUTHORIZED
    - add_object_into_json_array:
        do:
          io.cloudslang.base.json.add_object_into_json_array:
            - json_array: '${temperatures_array}'
            - json_object: "${'{\"' + current_city + '\":\"' + current_temperature + '\"}'}"
        publish:
          - temperatures_array: '${return_result}'
        navigate:
          - SUCCESS: array_iterator
          - FAILURE: on_failure
  outputs:
    - temperatures_result: '${temperatures_array}'
  results:
    - FAILURE
    - SUCCESS
    - FAILURE_UNAUTHORIZED
extensions:
  graph:
    steps:
      array_iterator:
        x: 120
        'y': 200
        navigate:
          3b7b4cf5-0bca-7905-8c6e-129ecd6285b5:
            targetId: c0b8ad9c-cfac-4c75-5efd-99eff0e8bb13
            port: NO_MORE
      kamil_weather_api:
        x: 320
        'y': 200
        navigate:
          35e1cbeb-098a-1b5f-e63c-96b7de62dc5b:
            targetId: 5bc77810-7f98-82e3-9a57-857d4c87bd68
            port: UNAUTHORIZED
      add_object_into_json_array:
        x: 560
        'y': 200
        navigate:
          745543b3-37f6-b88f-4acf-06748973808c:
            vertices:
              - x: 360
                'y': 120
            targetId: array_iterator
            port: SUCCESS
    results:
      SUCCESS:
        c0b8ad9c-cfac-4c75-5efd-99eff0e8bb13:
          x: 200
          'y': 40
      FAILURE_UNAUTHORIZED:
        5bc77810-7f98-82e3-9a57-857d4c87bd68:
          x: 320
          'y': 400
