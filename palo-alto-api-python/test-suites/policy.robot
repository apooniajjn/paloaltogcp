*** Settings ***
Resource        ./variables.robot
Force Tags      paloalto

*** Test Cases ***
Login to Palo Alto
    PaloAlto.Generate API Key
    ...    username=${username} 
    ...    password=${password}
    ...    base_url=${api_url}

List All Object Addresses
    ${address_info} =    PaloAlto.List Addresses
                         ...    location=vsys
                         ...    vsys=vsys1
    Log To Console    ${address_info}

# Create Addresse Entry
#     ${address_info} =    PaloAlto.Create Addresses
#                          ...    location=vsys
#                          ...    vsys=vsys1
#                          ...    address_entry_name=test13
#     Log To Console    ${address_info}

List All Security Policies
    PaloAlto.List Security Policies
        ...    location=vsys
        ...    vsys=vsys1