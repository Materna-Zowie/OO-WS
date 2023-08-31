namespace: Zowie-Folder
flow:
  name: ZowieFlow
  workflow:
    - ping_target_host:
        do:
          io.cloudslang.base.samples.utils.ping_target_host:
            - target_host: google.com
        publish:
          - return_result
        navigate:
          - FAILURE: FAILURE_1
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
    - FAILURE_1
extensions:
  graph:
    steps:
      ping_target_host:
        x: 640
        'y': 280
        navigate:
          1aafa915-8758-c773-b17e-65078891d692:
            targetId: ef6a8330-7bc5-ee40-135c-c2d56d0340ab
            port: SUCCESS
          404f106b-2908-ab1a-cfda-e8dadeb1a978:
            targetId: befd421a-a146-9c31-fa09-4e855434794c
            port: FAILURE
    results:
      SUCCESS:
        ef6a8330-7bc5-ee40-135c-c2d56d0340ab:
          x: 840
          'y': 280
      FAILURE_1:
        befd421a-a146-9c31-fa09-4e855434794c:
          x: 760
          'y': 480
