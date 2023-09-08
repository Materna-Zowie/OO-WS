########################################################################################################################
#!!
#! @input packages_list: comma separated list of modules/packages you want to install
#!!#
########################################################################################################################
namespace: kamil_basic
flow:
  name: install_packages
  inputs:
    - packages_list: beautifulsoup4
  workflow:
    - install_package:
        do:
          kamil_basic.install_package:
            - packages_list: '${packages_list}'
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      install_package:
        x: 200
        'y': 160
        navigate:
          b4ed995e-61a8-3cfc-8d81-39005ed6d8ed:
            targetId: 11cdf0ad-74e8-7545-213c-1a5c548a7d9e
            port: SUCCESS
    results:
      SUCCESS:
        11cdf0ad-74e8-7545-213c-1a5c548a7d9e:
          x: 400
          'y': 160
