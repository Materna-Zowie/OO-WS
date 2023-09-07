namespace: kamil_basic
operation:
  name: addition
  inputs:
    - number1
    - number2
  python_action:
    use_jython: false
    script: |-
      # do not remove the execute function
      def execute(number1,number2):
          # code goes here
          addition = float(number1) + float(number2)
          return {"return_result" : addition}
      # you can add additional helper methods below.
  outputs:
    - return_result
  results:
    - SUCCESS
