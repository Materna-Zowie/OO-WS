########################################################################################################################
#!!
#! @description: Python package required: ldap3
#!               
#!               The python action enables the addition of a specified user to a designated AD group by providing the group's distinguished name, the user's distinguished name, LDAP server address (with optional SSL), and appropriate login credentials. 
#!               
#!               inputs>
#!               group_distinguished_name: The distinguished name (DN) of the Active Directory group where the user will be added, typically in the form of "CN=GroupName,OU=Department,DC=example,DC=com." Example input: "CN=IT_Users,OU=Groups,DC=mycompany,DC=com."
#!               user_distinguished_name: The DN of the user to be added to the group, following a similar format as the group DN. Example input: "CN=John Doe,OU=Users,DC=mycompany,DC=com."
#!               ldap_server_address: The address of the LDAP server, including only the domain or IP address, e.g., "example.com."
#!               ldap_username: The username for authenticating with the LDAP server. Example input: "admin_user."
#!               ldap_password: The password associated with the provided ldap_username. Example input: "P@ssw0rd."
#!               use_ssl (Boolean): A flag indicating whether to use SSL encryption for the LDAP connection. Possible values are True (for SSL) or False (for plain LDAP). Example input: True.
#!               
#!               outputs>
#!               result - the result of the operation
#!               group_members - in case of addtion, or user already being a member of the group, the function also returns the group members for reference
#!               
#!
#! @input group_distinguished_name: The distinguished name (DN) of the Active Directory group where the user will be added, typically in the form of "CN=GroupName,OU=Department,DC=example,DC=com." Example input: "CN=IT_Users,OU=Groups,DC=mycompany,DC=com."
#! @input user_distinguished_name: The DN of the user to be added to the group, following a similar format as the group DN. Example input: "CN=John Doe,OU=Users,DC=mycompany,DC=com."
#!                                 ldap_server_address: The address of the LDAP server, including only the domain or IP address, e.g., "example.com."
#! @input ldap_server_address:  The address of the LDAP server, including only the domain or IP address, e.g., "example.com."
#! @input ldap_username: The username for authenticating with the LDAP server. Example input: "admin_user."
#! @input ldap_password:  The password associated with the provided ldap_username. Example input: "P@ssw0rd."
#! @input use_ssl:  A flag indicating whether to use SSL encryption for the LDAP connection. Possible values are True (for SSL) or False (for plain LDAP). Example input: True.
#!
#! @output result: the result of the operation
#! @output group_members: in case of addtion, or user already being a member of the group, the function also returns the group members for reference
#!!#
########################################################################################################################
namespace: kami_use_cases
operation:
  name: LDAP_add_user_to_group
  inputs:
    - group_distinguished_name
    - user_distinguished_name
    - ldap_server_address
    - ldap_username
    - ldap_password:
        sensitive: true
    - use_ssl
  python_action:
    use_jython: false
    script: "# do not remove the execute function\r\ndef execute(group_distinguished_name, user_distinguished_name, ldap_server_address, ldap_username, ldap_password, use_ssl):\r\n    from ldap3 import Server, Connection, MODIFY_ADD, MODIFY_DELETE, ALL_ATTRIBUTES\r\n    # code goes here\r\n    if use_ssl:\r\n        ldap_protocol = 'ldaps://'\r\n        ldap_port = 636\r\n    else:\r\n        ldap_protocol = 'ldap://'\r\n        ldap_port = 389\r\n    \r\n    # Create the LDAP server URL\r\n    ldap_server_url = ldap_protocol + ldap_server_address + ':' + str(ldap_port)\r\n\r\n    # Create an LDAP server object\r\n    ldap_server = Server(ldap_server_url)\r\n\r\n    # Create an LDAP connection object\r\n    ldap_connection = Connection(ldap_server, user=ldap_username, password=ldap_password)\r\n\r\n    try:\r\n        # Bind to the AD server\r\n        if not ldap_connection.bind():\r\n            return {\"result\": \"Failed to bind to LDAP server\"}\r\n\r\n        # Check if the user is already a member of the group\r\n        ldap_connection.search(group_distinguished_name, \"(member={})\".format(user_distinguished_name), attributes=[ALL_ATTRIBUTES])\r\n        if len(ldap_connection.entries) > 0:\r\n            return {\"result\": \"User is already a member of the group\", \"group_members\": [str(entry) for entry in ldap_connection.entries]}\r\n\r\n        # If not a member, add the user to the group\r\n        ldap_connection.modify(group_distinguished_name, {'member': [(MODIFY_ADD, [user_distinguished_name])]})\r\n\r\n        # Verify that the user has been added to the group\r\n        ldap_connection.search(group_distinguished_name, \"(member={})\".format(user_distinguished_name), attributes=[ALL_ATTRIBUTES])\r\n        if len(ldap_connection.entries) > 0:\r\n            return {\"result\": \"User added to the group successfully\", \"group_members\": [str(entry) for entry in ldap_connection.entries]}\r\n        else:\r\n            return {\"result\": \"Failed to add user to the group\"}\r\n\r\n    except Exception as e:\r\n        return {\"result\": \"Error: {}\".format(str(e))}\r\n    finally:\r\n        # Unbind the connection when done\r\n        ldap_connection.unbind()\r\n        \r\n# you can add additional helper methods below."
  outputs:
    - result
    - group_members
  results:
    - SUCCESS
