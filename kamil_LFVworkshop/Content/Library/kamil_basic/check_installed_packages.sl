namespace: kamil_basic
operation:
  name: check_installed_packages
  python_action:
    use_jython: false
    script: "def execute():\r\n    import subprocess\r\n    import sys\r\n    out =  subprocess.run([sys.executable, \"-m\", \"pip\", \"freeze\"], capture_output=True)\r\n    return {\"installed_modules\": out.stdout.decode()}"
  outputs:
    - installed_modules
  results:
    - SUCCESS
