namespace: kami_use_cases
operation:
  name: extract_info_from_text
  inputs:
    - input_string
    - template_mapping
  python_action:
    use_jython: false
    script: "# do not remove the execute function\n\ndef execute(input_string, template_mapping):\n    import json\n    import re \n    try:\n        # Parse the template_mapping JSON string into a dictionary\n        mapping_dict = json.loads(template_mapping)\n\n        # Initialize the result dictionary\n        result_dict = {}\n\n        # Iterate over each variable in the mapping_dict\n        for variable, [start, end] in mapping_dict.items():\n            # Find all occurrences of start and end strings\n            start_indices = [m.end() for m in re.finditer(re.escape(start), input_string)]\n            end_indices = [m.start() for m in re.finditer(re.escape(end), input_string)]\n\n            # Initialize a list to store extracted values\n            extracted_values = []\n\n            # Extract values for the current variable\n            for s_idx in start_indices:\n                for e_idx in end_indices:\n                    if e_idx > s_idx:\n                        extracted_text = input_string[s_idx:e_idx].strip()\n                        extracted_values.append(extracted_text)\n\n            # Store the extracted values in the result dictionary\n            result_dict[variable] = extracted_values if extracted_values else None\n\n        return {\"return_result\": json.dumps(result_dict)}\n\n    except Exception as e:\n        return json.dumps({\"error\": str(e)})\n# you can add additional helper methods below."
  outputs:
    - return_result
    - error
  results:
    - SUCCESS
