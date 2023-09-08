########################################################################################################################
#!!
#! @description: This operation removes html tags using the beautifulsoup Python module......
#!               
#!               inputs>
#!               
#!               outputs>
#!
#! @input input_string: the html string to parse
#!!#
########################################################################################################################
namespace: kami_use_cases
operation:
  name: remove_html_tags
  inputs:
    - input_string
  python_action:
    use_jython: false
    script: "# do not remove the execute function\ndef execute(input_string):\n    from bs4 import BeautifulSoup\n    soup = BeautifulSoup(input_string, 'html.parser')\n    text = soup.get_text()\n    \n    return {\"clean_text\": text}\n# you can add additional helper methods below."
  outputs:
    - clean_text
  results:
    - SUCCESS
