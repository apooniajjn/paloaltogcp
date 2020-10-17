*** Settings ***
Library         PaloAltoNetworksLibrary    WITH NAME   PaloAlto

*** Keywords ****
Login to Palo Alto
    PaloAlto.Generate API Key
    ...    username=${username} 
    ...    password=${password}
    ...    base_url=${api_url}

*** Variables ***
##############################
#     LOGIN VARIABLES
##############################
${username}                 %{TEST_API_USER=admin}
${password}                 %{TEST_API_PASS=Admin123}
${api_url}                  %{TEST_API_URL=https://52.41.115.27}
${api_version}              %{TEST_API_URL=https://52.41.115.27}