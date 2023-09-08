namespace: kami_use_cases
operation:
  name: date_to_unix
  inputs:
    - date_str
    - format_str
  python_action:
    use_jython: false
    script: "# do not remove the execute function\ndef execute(date_str, format_str):\n    from datetime import datetime\n    try:\n        # Parse the input date string using the specified format\n        parsed_date = datetime.strptime(date_str, format_str)\n        \n        # Convert the datetime object to Unix timestamp in seconds\n        unix_timestamp = int(parsed_date.timestamp())\n        \n        # Convert to Unix timestamp in milliseconds\n        unix_timestamp_ms = unix_timestamp * 1000\n        \n        # Return the result as a dictionary\n        return {\"unix_timestamp\": unix_timestamp_ms}\n    except ValueError as e:\n        # Handle invalid date format\n        return {\"error\": str(e)}\n# you can add additional helper methods below."
  outputs:
    - unix_timestamp
    - error
  results:
    - SUCCESS
