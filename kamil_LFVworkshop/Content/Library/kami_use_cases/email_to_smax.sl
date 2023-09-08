########################################################################################################################
#!!
#! @input saw_url: The Service Management Automation X URL to make the request to.
#!                 Examples: scheme://{serverAddress}.
#! @input tenant_id: The OpenText SMAX tenant Id.
#!!#
########################################################################################################################
namespace: kami_use_cases
flow:
  name: email_to_smax
  inputs:
    - saw_url: 'https://ngsm.smax-materna.se/'
    - tenant_id: '644815427'
  workflow:
    - get_email:
        do:
          io.cloudslang.microsoft.office365.get_email:
            - tenant: 421a3522-a36e-43ad-aa5b-10d85a63dc1f
            - login_type: API
            - client_id: 0d5fa167-6a7d-4bcf-a9bf-574a90fedf37
            - client_secret:
                value: gRH8Q~~VeQsy4zPQAq0DqHbQUhqgYPA.XFu6zbxB
                sensitive: true
            - email_address: lfvootraning@materna.se
            - o_data_query: $search=WORKSHOP
        publish:
          - email_json: '${return_result}'
        navigate:
          - SUCCESS: get_emai_body_content_type
          - FAILURE: on_failure
    - get_emai_body_content_type:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${email_json}'
            - json_path: $.value..body.contentType
        publish:
          - content_type: '${return_result[2:-2]}'
        navigate:
          - SUCCESS: get_emai_body_content
          - FAILURE: on_failure
    - get_emai_body_content:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${email_json}'
            - json_path: $.value..body.content
        publish:
          - email_body_content: '${return_result}'
        navigate:
          - SUCCESS: is_body_html
          - FAILURE: on_failure
    - is_body_html:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${content_type}'
            - second_string: html
            - ignore_case: 'true'
        navigate:
          - SUCCESS: remove_html_tags
          - FAILURE: extract_info_from_text
    - remove_html_tags:
        do:
          kami_use_cases.remove_html_tags:
            - input_string: '${email_body_content}'
        publish:
          - clean_email_body_content: '${clean_text}'
        navigate:
          - SUCCESS: extract_info_from_text
    - extract_info_from_text:
        do:
          kami_use_cases.extract_info_from_text:
            - input_string: '${clean_email_body_content}'
            - template_mapping: '{"customer":["Customer: ", "PW Reference number"],"reference_number":["PW Reference number: ","Your affected"],"start_time":["Start Date and Time: ", " CET/CEST End Date "],"end_time":["End Date and Time: ","CET/CEST"], "reason_for_work":["Reason for work: ", "Location of work: "], "location_of_work":["Location of work: ", "The same information"], "service_ids":["Service ID: ","Product:"]}'
        publish:
          - extracted_info_json: '${return_result}'
        navigate:
          - SUCCESS: start_time_to_unix
    - start_time_to_unix:
        do:
          kami_use_cases.date_to_unix:
            - date_str: "${(cs_json_query(extracted_info_json,'$.start_time'))[3:-3]}"
            - format_str: '%Y-%b-%d %H:%M'
        publish:
          - start_time_unix: '${unix_timestamp}'
        navigate:
          - SUCCESS: end_time_to_unix
    - end_time_to_unix:
        do:
          kami_use_cases.date_to_unix:
            - date_str: "${(cs_json_query(extracted_info_json,'$.end_time'))[3:-3]}"
            - format_str: '%Y-%b-%d %H:%M'
        publish:
          - end_time_unix: '${unix_timestamp}'
        navigate:
          - SUCCESS: search_for_location
    - search_for_location:
        do:
          kamil_smax.kamil_query_smax_entity:
            - saw_url: '${saw_url}'
            - tenant_id: '${tenant_id}'
            - entity_type: Location
            - fields: Id
            - query: "${\"ExactLocation eq '\" + (cs_json_query(extracted_info_json,'@.location_of_work'))[3:-3] + \"'\"}"
        publish:
          - location_id: "${(cs_json_query(return_result,'$.entities..properties.Id'))[2:-2]}"
          - sso_token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: create_entity
          - NO_RESULTS: CUSTOM
    - create_entity:
        do:
          io.cloudslang.opentext.service_management_automation_x.commons.create_entity:
            - saw_url: '${saw_url}'
            - sso_token: '${sso_token}'
            - tenant_id: '${tenant_id}'
            - json_body: "${{\n\t\"entity_type\": \"Change\",\n\t\"properties\": {\n\t    \"DisplayLabel\":\"Test Change\",\n\t    \"Description\": \"Test Change\",\n\t    \"Justification\": \"Test Change\",\n\t\t\"PWReferenceNumber_c\":\"\" + (cs_json_query(extracted_info_json,'$.reference_number'))[3:-3] + \"\",\n\t\t\"RegisteredForLocation\":\"\" + location_id + \"\",\n\t\t\"ScheduledStartTime\": start_time_unix,\n\t\t\"ScheduledEndTime\": end_time_unix,\n\t\t\"ReasonForWork_c\":\"\" + (cs_json_query(extracted_info_json,'$.reason_for_work'))[3:-3] + \"\",\n\t\t\"AffectedServiceIds_c\":\"\" + (cs_json_query(extracted_info_json,'$.service_ids'))[3:-3] + \"\",\n\t\t\"ReasonForChange\":\"BusinessRequirement\",\n        \"AffectsActualService\":\"11545\",\n        \"BasedOnChangeModel\":\"11948\"\n\t}\n}}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - CUSTOM
    - SUCCESS
extensions:
  graph:
    steps:
      get_emai_body_content:
        x: 240
        'y': 320
      search_for_location:
        x: 920
        'y': 320
        navigate:
          a255ccfe-a695-38f6-8536-813a7ff59a85:
            targetId: 311f36ec-565d-5381-7e12-d5f8cad17d35
            port: NO_RESULTS
      create_entity:
        x: 920
        'y': 160
        navigate:
          5a0d9493-4f9c-86ed-97f4-105baa71bee3:
            targetId: da4c8201-2da1-8926-0096-cae697c3560e
            port: SUCCESS
      extract_info_from_text:
        x: 520
        'y': 160
      remove_html_tags:
        x: 400
        'y': 320
      get_email:
        x: 80
        'y': 160
      is_body_html:
        x: 240
        'y': 160
      start_time_to_unix:
        x: 640
        'y': 320
      get_emai_body_content_type:
        x: 80
        'y': 320
      end_time_to_unix:
        x: 760
        'y': 320
    results:
      CUSTOM:
        311f36ec-565d-5381-7e12-d5f8cad17d35:
          x: 720
          'y': 480
      SUCCESS:
        da4c8201-2da1-8926-0096-cae697c3560e:
          x: 1160
          'y': 160
