namespace: kamil_basic
flow:
  name: check_installed_packages_flow
  workflow:
    - check_installed_packages:
        do:
          kamil_basic.check_installed_packages: []
        publish:
          - installed_modules
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - installed_modules: '${installed_modules}'
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      check_installed_packages:
        x: 200
        'y': 200
        navigate:
          da6f7558-3604-be6a-bfe6-9a82359717ea:
            targetId: b94410b7-276c-f039-8682-84b032b945b1
            port: SUCCESS
    results:
      SUCCESS:
        b94410b7-276c-f039-8682-84b032b945b1:
          x: 440
          'y': 200
