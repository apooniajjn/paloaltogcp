*** Settings ***
Resource        ./variables.robot
Force Tags      oracle

*** Test Cases ***
Get User Details
    ${user_info} =    Oracle.Get User
    Log To Console    ${user_info}

Get Namespace Details
    ${namespace_info} =    Oracle.Get Namespace
    Log To Console    ${namespace_info}

Create Bucket
    ${bucket_details} =    Oracle.Create Bucket
                           ...    namespace_name=${namespace} 
                           ...    bucket_name=${bucket_name} 
    Log To Console    ${bucket_details}

List Bucket
    ${list_details} =    Oracle.List Buckets
                         ...    namespace_name=${namespace} 
    Log To Console    ${list_details}

Delete Bucket
    ${delete_details} =    Oracle.Delete Bucket
                           ...    namespace_name=${namespace} 
                           ...    bucket_name=${bucket_name}                 
    Log To Console    ${delete_details}