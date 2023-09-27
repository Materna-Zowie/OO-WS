########################################################################################################################
#!!
#! @input email_address: The email address on which to perform the action,
#!                       Optional
#! @input o_data_query: Query parameters which can be used to specify and control the amount of data returned in a
#!                      response specified in 'key1=val1&key2=val2' format. $top and $select options should be not
#!                      passed for this input because the values for these options can be passed in topQuery and
#!                      selectQuery inputs. In order to customize the Office 365 response, modify or remove the default value.
#!                      Example: &filter=Subject eq 'Test' AND IsRead eq true
#!                      &filter=HasAttachments eq true
#!                      &search="from:help@contoso.com"
#!                      &search="subject:Test"
#!                      $select=subject,bodyPreview,sender,from
#!                      Optional
#!!#
########################################################################################################################
namespace: kami_use_cases
flow:
  name: get_email_attachments
  inputs:
    - tenant: 421a3522-a36e-43ad-aa5b-10d85a63dc1f
    - client_id: 0d5fa167-6a7d-4bcf-a9bf-574a90fedf37
    - scope: 'https%3A%2F%2Fgraph.microsoft.com%2F.default'
    - client_secret: gRH8Q~~VeQsy4zPQAq0DqHbQUhqgYPA.XFu6zbxB
    - grant_type: client_credentials
    - email_address: lfvootraning@materna.se
    - o_data_query: $search=atts
    - attachments: '[]'
  workflow:
    - get_graph_token:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${'https://login.microsoftonline.com/' + tenant + '/oauth2/v2.0/token'}"
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - body: "${'client_id=' + client_id + '&scope=' + scope + '&client_secret=' + client_secret + '&grant_type=' + grant_type}"
            - content_type: application/x-www-form-urlencoded
        publish:
          - return_result
          - graph_token: "${(cs_json_query(return_result,'$.access_token'))[2:-2]}"
        navigate:
          - SUCCESS: get_email
          - FAILURE: on_failure
    - get_email:
        do:
          io.cloudslang.microsoft.office365.get_email:
            - tenant: '${tenant}'
            - login_type: API
            - client_id: '${client_id}'
            - client_secret:
                value: '${client_secret}'
                sensitive: true
            - email_address: '${email_address}'
            - o_data_query: '${o_data_query}'
        publish:
          - email_json: '${return_result}'
          - email_id: "${(cs_json_query(return_result,'$.value..id'))[2:-2]}"
          - has_attachment: "${(cs_json_query(return_result,'$.value..hasAttachments'))[1:-1]}"
        navigate:
          - SUCCESS: has_email_attachments
          - FAILURE: on_failure
    - has_email_attachments:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${has_attachment}'
            - second_string: 'true'
            - ignore_case: 'true'
        navigate:
          - SUCCESS: get_attachment_list
          - FAILURE: NO_ATTACHMENTS
    - get_attachment_list:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'https://graph.microsoft.com/v1.0/users/' + email_address + '/messages/' + email_id + '/attachments'}"
            - x_509_hostname_verifier: allow_all
            - headers: "${'Authorization: Bearer ' + graph_token}"
            - content_type: application/json
        publish:
          - return_result
          - attachment_list: "${(cs_json_query(return_result,'$.value'))[1:-1]}"
        navigate:
          - SUCCESS: array_iterator
          - FAILURE: on_failure
    - array_iterator:
        do:
          io.cloudslang.base.json.array_iterator:
            - array: '${attachment_list}'
        publish:
          - current_attachment: '${result_string}'
        navigate:
          - HAS_MORE: get_attachment_raw_content
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - get_attachment_raw_content:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'https://graph.microsoft.com/v1.0/users/' + email_address + '/messages/' + email_id + '/attachments/' + (cs_json_query(current_attachment,'$.id'))[2:-2] + '/$value'}"
            - x_509_hostname_verifier: allow_all
            - headers: "${'Authorization: Bearer ' + graph_token}"
            - content_type: application/json
        publish:
          - current_attachment_raw_content: '${return_result}'
        navigate:
          - SUCCESS: add_object_into_json_array
          - FAILURE: on_failure
    - add_object_into_json_array:
        do:
          io.cloudslang.base.json.add_object_into_json_array:
            - json_array: '${attachments}'
            - json_object: "${{(cs_json_query(current_attachment,'$.name'))[2:-2] : current_attachment_raw_content}}"
        publish:
          - attachments: '${return_result}'
        navigate:
          - SUCCESS: array_iterator
          - FAILURE: on_failure
  outputs:
    - attachments_out: '${attachments}'
  results:
    - FAILURE
    - SUCCESS
    - NO_ATTACHMENTS
extensions:
  graph:
    steps:
      get_graph_token:
        x: 120
        'y': 80
      get_email:
        x: 120
        'y': 240
      has_email_attachments:
        x: 120
        'y': 400
        navigate:
          85c48dc1-19df-f045-2d5f-8ec01b18d9fb:
            targetId: f6bdda4d-1679-e11c-4728-ae20f5ada8ca
            port: FAILURE
      get_attachment_list:
        x: 240
        'y': 80
      array_iterator:
        x: 400
        'y': 80
        navigate:
          b5bb9b34-7ecc-d80e-74ab-bc86dbd1cdbe:
            targetId: 53a58f35-ce59-d612-98db-2d676cb9dcd2
            port: NO_MORE
      get_attachment_raw_content:
        x: 520
        'y': 200
      add_object_into_json_array:
        x: 640
        'y': 80
    results:
      SUCCESS:
        53a58f35-ce59-d612-98db-2d676cb9dcd2:
          x: 400
          'y': 320
      NO_ATTACHMENTS:
        f6bdda4d-1679-e11c-4728-ae20f5ada8ca:
          x: 320
          'y': 400
