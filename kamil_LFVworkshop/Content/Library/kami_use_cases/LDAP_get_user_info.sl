########################################################################################################################
#!!
#! @description: Python package required: ldap3
#!                
#!               This python operation connects to an LDAP server, searches for user entries based on specified criteria, and retrieves specified attributes for those entries. The function returns a dictionary with the retrieved attributes and a "failed" flag indicating whether the operation was successful or encountered an error. The search is performed using the provided search field, filter, search base, and LDAP server information. The user's credentials (username and password) are used for authentication. The specified attributes are returned as a comma-separated string in the "attributes" field of the result dictionary. In case of an error, the "failed" flag is set to True, and an error message is included in the result.
#!               inputs>
#!               search_field: The LDAP field used for searching, such as "sAMAccountName." Example: "sAMAccountName"
#!               search_filter: The filter used for the search, typically a portion of the user's name or identifier. Example: "John"
#!               return_attributes: A comma-separated list of LDAP attributes to retrieve for each matching entry. Example: "displayName,mail,sAMAccountName"
#!               search_base: The LDAP distinguished name (DN) of the search base or starting point. Example: "OU=Users,DC=example,DC=com"
#!               ldap_server_address: The address of the LDAP server, including the protocol (ldap:// or ldaps://) and port if needed. Examples: "ldap.example.com", "ldap://ldap.example.com:389"
#!               ldap_username: The username for authenticating with the LDAP server. Example: "user@example.com"
#!               ldap_password: The password for authenticating with the LDAP server. Example: "password123"
#!               outputs>
#!               all the main standard user attributes can be returned by the function, check the output list, if there are additional attributes to be returned, the action outputs need to be customized.
#!
#! @input search_field: The LDAP field used for searching, such as "sAMAccountName." Example: "sAMAccountName"
#! @input search_filter: The filter used for the search, typically a portion of the user's name or identifier. Example: "John"
#! @input return_attributes: A comma-separated list of LDAP attributes to retrieve for each matching entry. Example: "displayName,mail,sAMAccountName"
#! @input search_base: The LDAP distinguished name (DN) of the search base or starting point. Example: "OU=Users,DC=example,DC=com"
#! @input ldap_server_address: The address of the LDAP server, including the protocol (ldap:// or ldaps://) and port if needed. Examples: "ldap.example.com", "ldap://ldap.example.com:389"
#! @input ldap_username: The username for authenticating with the LDAP server. Example: "user@example.com"
#! @input ldap_password: The password for authenticating with the LDAP server. Example: "password123"
#!!#
########################################################################################################################
namespace: kami_use_cases
operation:
  name: LDAP_get_user_info
  inputs:
    - search_field
    - search_filter
    - return_attributes
    - search_base
    - ldap_server_address
    - ldap_username
    - ldap_password:
        sensitive: true
  python_action:
    use_jython: false
    script: "# do not remove the execute function\r\n\r\ndef execute(search_field, search_filter, return_attributes, search_base, ldap_server_address, ldap_username, ldap_password):\r\n    from ldap3 import Server, Connection, ALL, SIMPLE, SYNC\r\n    failed = False\r\n    try:\r\n        # Set up LDAP server and connection\r\n        ldap_server = Server(ldap_server_address, get_info=ALL)\r\n        ldap_connection = Connection(\r\n            ldap_server,\r\n            user=ldap_username,\r\n            password=ldap_password,\r\n            authentication=SIMPLE,  # You might need to adjust this based on your LDAP setup\r\n            auto_bind=True,\r\n        )\r\n       \r\n        # Define the search filter and attributes to retrieve\r\n        search_query = f\"({search_field}=*{search_filter}*)\"\r\n        attributes = return_attributes.split(\",\") #attributes = ['displayName', 'mail', 'sAMAccountName', 'memberOf']#\r\n\r\n        # Perform the search\r\n        ldap_connection.search(search_base, search_query, attributes=attributes)\r\n        \r\n        result = {}  # Initialize result as a dictionary\r\n\r\n        # Process search results\r\n        for entry in ldap_connection.entries:\r\n            for attribute in attributes:\r\n                result[attribute] = entry[attribute].value\r\n        \r\n        #return {\"displayName\":\"Line 31\",\"attributes\": ','.join(attributes)}\r\n        ldap_connection.unbind()\r\n        \r\n        result[\"attributes\"] =  ','.join(attributes)\r\n        result[\"failed\"] =  failed\r\n        \r\n        return result\r\n\r\n        #return {\"displayName\":display_name, \"Email\": email, \"SAMAccountName\": sam_account_name, \"MemberOf\": member_of, \"attributes\": ','.join(attributes)}\r\n\r\n    except Exception as e:\r\n        #return {\"displayName\":\"Line 41\", \"error\": str(e)}\r\n        failed = True\r\n        return {\"error\": str(e), \"failed\":failed}"
  outputs:
    - displayName
    - mail
    - sAMAccountName
    - memberOf
    - attributes
    - result
    - failed
    - error
    - distinguishedName
    - accountExpires
    - adminCount
    - badPasswordTime
    - badPwdCount
    - cn
    - codePage
    - countryCode
    - dSCorePropagationData
    - instanceType
    - lastLogoff
    - lastLogon
    - lastLogonTimestamp
    - logonCount
    - name
    - objectCategory
    - objectGlass
    - primaryGroupID
    - pwdLastSet
    - userAccountControl
    - uSNChanged
    - uSNCreated
    - whenChanged
    - whenCreated
    - logonHours
    - objectGUID
    - objectSid
    - givenName
    - sn
    - title
    - employeeNumber
    - telephoneNumber
    - mobile
    - homePhone
    - streetAddress
    - postalCode
    - l
    - st
    - c
    - description
    - employeeType
  results:
    - SUCCESS
