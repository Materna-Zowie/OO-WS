namespace: kamil_basic
flow:
  name: kamil_weather_api_loop
  inputs:
    - cities_list: 'Stockholm,Bratislava,Berlin'
  workflow:
    - kamil_weather_api:
        loop:
          for: current_city in cities_list
          do:
            kamil_basic.kamil_weather_api:
              - city: '${current_city}'
              - temperatures_list: '${temperatures_list}'
          break:
            - FAILURE
            - UNAUTHORIZED
          publish:
            - current_temperature: '${temperature}'
            - temperatures_list: "${cs_append(str(temperatures_list).replace('None',''),' ' + city + ': ' + current_temperature)}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
          - UNAUTHORIZED: FAILURE_UNAUTHORIZED
  results:
    - FAILURE
    - SUCCESS
    - FAILURE_UNAUTHORIZED
extensions:
  graph:
    steps:
      kamil_weather_api:
        x: 200
        'y': 200
        navigate:
          29ca2a8b-9205-5854-aa1f-82dfaf3e9897:
            targetId: ec711145-4b34-7a5c-5ef7-f43b76ba742d
            port: SUCCESS
          b398ee44-c0ba-0388-ff6e-8948feaa7a44:
            targetId: e22294c4-8360-1ac3-e66e-f7e134489344
            port: UNAUTHORIZED
    results:
      SUCCESS:
        ec711145-4b34-7a5c-5ef7-f43b76ba742d:
          x: 440
          'y': 200
      FAILURE_UNAUTHORIZED:
        e22294c4-8360-1ac3-e66e-f7e134489344:
          x: 440
          'y': 360
