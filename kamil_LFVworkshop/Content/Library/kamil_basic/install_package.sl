########################################################################################################################
#!!
#! @input packages_list: comma separated list of modules/packages you want to install
#!!#
########################################################################################################################
namespace: kamil_basic
operation:
  name: install_package
  inputs:
    - packages_list
  python_action:
    use_jython: false
    script: "def execute(packages_list):\r\n    import subprocess\r\n    import sys\r\n    # leave empty string if you don't need a proxy\r\n    proxy = \"\"\r\n    # comma separated list of package names\r\n    packages = packages_list\r\n    for package in packages.split(\",\"):    \r\n        subprocess.run([sys.executable, \"-m\", \"pip\", \"--proxy\", proxy, \"install\", package])"
  results:
    - SUCCESS
