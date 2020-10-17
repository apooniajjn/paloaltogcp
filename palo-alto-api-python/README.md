# PAN OS VM Series Firewall Configuration 

This repository includes `python` library which end user can use with `Robot Framework`. This will allow end user to configuration firewall using keywords which will consume REST API accordingly. 

Software version used: 
- PAN OS VM REST API version (v10.0)
- Robot Framework (3.1.2)

## Prerequisites

This repository has below prerequisites:

1. I am using `spartan` helper which is nothing but `robot framework` cli so either you create a helper os use `robot` cli directly. 
2. Update your PAN OS VM details in `variables.robot` file in `test-suites` directory. 

## How to Use 

We have defined below keywords which will allow user to perform below few operations 

1. Generate API Key
2. List Addresses
3. List Security Policies

You can always more keywords by adding functions in `paloalto.py` file in `PaloAltoNetworksLibrary`. 

Below example show how I am getting address information and security policies on my `vsys1` system:

**Example Output**: 

```
(colt-v1-2) ➜  test-suites git:(master) ✗ spartan --log-level trace policy.robot
==============================================================================
Policy                                                                        
==============================================================================
Login to Palo Alto                                                    | PASS |
------------------------------------------------------------------------------
List All Object Addresses                                             .{'@status': 'success', '@code': '19', 'result': {'@total-count': '3', '@count': '3', 'entry': [{'@name': 'test', '@location': 'vsys', '@vsys': 'vsys1', 'ip-netmask': '10.10.10.0/24'}, {'@name': 'test2', '@location': 'vsys', '@vsys': 'vsys1', 'ip-netmask': '10.20.10.0/24'}, {'@name': 'test23', '@location': 'vsys', '@vsys': 'vsys1', 'ip-netmask': '10.23.10.0/24'}]}}
List All Object Addresses                                             | PASS |
------------------------------------------------------------------------------
List All Security Policies                                            | PASS |
------------------------------------------------------------------------------
Policy                                                                | PASS |
3 critical tests, 3 passed, 0 failed
3 tests total, 3 passed, 0 failed
==============================================================================
Output:  /Users/apoonia/Desktop/paloaltogcp/palo-alto-api-python/test-suites/test_reports/spartan-output-20201017-034007.xml
Log:     /Users/apoonia/Desktop/paloaltogcp/palo-alto-api-python/test-suites/test_reports/spartan-log-20201017-034007.html
Report:  /Users/apoonia/Desktop/paloaltogcp/palo-alto-api-python/test-suites/test_reports/spartan-report-20201017-034007.html
```

## Open Items 

I am summarizing few open items: 

1. I noticed official pan os python sdk is too old 
2. PAN OS Rest API doesn't have a swagger file so i can create python sdk file. 
3. So I ended up consuming REST API using requests library 

User can use this repository as starting point and enhance it accordingly.