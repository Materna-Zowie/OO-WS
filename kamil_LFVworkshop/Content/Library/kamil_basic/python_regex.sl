namespace: kamil_basic
operation:
  name: python_regex
  inputs:
    - text
    - regex
  python_action:
    use_jython: false
    script: "# do not remove the execute function\ndef execute(text, regex):\n    # code goes here\n    import re\n    match = re.search(regex, text)\n    if match:\n        match_text = match.group()\n        found = True\n        return {\"match_text\": match_text, \"found\": found}\n    else:\n        found = False\n        return {\"match_text\": \"No text matching the regex has been found\", \"found\": found}\n    \n# you can add additional helper methods below.\n\ndef addition(number1,number2):\n    # code goes here\n    addition = float(number1) + float(number2)\n    return {\"return_result\" : addition}"
  outputs:
    - match_text
    - found
  results:
    - FAILURE: '${found == False}'
    - SUCCESS
