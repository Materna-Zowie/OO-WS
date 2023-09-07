namespace: kamil_basic
flow:
  name: addition_test
  workflow:
    - addition:
        do:
          kamil_basic.addition:
            - number1: '2'
            - number2: '3'
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      addition:
        x: 200
        'y': 160
        navigate:
          7aec0631-89b0-a209-6cb6-6418723045e9:
            targetId: b8fc3bcc-dfeb-ea2d-214a-74a6919e31b8
            port: SUCCESS
    results:
      SUCCESS:
        b8fc3bcc-dfeb-ea2d-214a-74a6919e31b8:
          x: 440
          'y': 160
