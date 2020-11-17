# Oracle Cloud Configuration

This repository includes `python` library which end user can use with `Robot Framework`. This will allow end user to configure Oracle Cloud using keywords which are written around Oracle API. 

Software versions used: 
- Oracle REST API version
- Robot Framework (3.1.2)

## Prerequisites

This repository has below prerequisites:

1. I am using `spartan` helper which is nothing but `robot framework` cli so either you create a new helper or use `robot` cli directly. 
2. Update your Oracle Cloud details in `variables.robot` file in `test-suites` directory. 

## How to Use 

We have defined few keywords which will allow end user to perform below operations:

1. Get User Details
2. Get Namespace
3. Create Bucket
4. List Bucket
5. Delete Bucket


You can always add more keywords by adding python REST API functions in `oracle.py` file in `OracleLibrary`. 

Below example show how I am getting addresses information and security policies:

**Example Output**: 

```
(spartan-v1) ➜  test-suites git:(master) ✗ spartan oracle.robot 
==============================================================================
Oracle                                                                        
==============================================================================
Get User Details                                                      .{
  "capabilities": {
    "can_use_api_keys": true,
    "can_use_auth_tokens": true,
    "can_use_console_password": false,
    "can_use_customer_secret_keys": true,
    "can_use_o_auth2_client_credentials": true,
    "can_use_smtp_credentials": true
  },
  "compartment_id": "ocid1.tenancy.oc1..XXXXX",
  "defined_tags": {
    "Oracle-Tags": {
      "CreatedBy": "scim-service",
      "CreatedOn": "2020-10-13T22:40:44.709Z"
    }
  },
  "description": "poonia0arun@gmail.com",
  "email": null,
  "email_verified": true,
  "external_identifier": "ac51cd8cdf8c4beb94296b66780049d5",
  "freeform_tags": {},
  "id": "ocid1.user.oc1..XXXXX",
  "identity_provider_id": "ocid1.saml2idp.oc1..XXXXX",
  "inactive_status": null,
  "is_mfa_activated": false,
  "lifecycle_state": "ACTIVE",
  "name": "oracleidentitycloudservice/poonia0arun@gmail.com",
  "time_created": "2020-10-13T22:40:44.721000+00:00"
}
Get User Details                                                      | PASS |
------------------------------------------------------------------------------
Get Namespace Details                                                 .aXXXXyrd
Get Namespace Details                                                 | PASS |
------------------------------------------------------------------------------
Create Bucket                                                         .{
  "approximate_count": null,
  "approximate_size": null,
  "compartment_id": "ocid1.tenancy.oc1..XXXXX",
  "created_by": "ocid1.user.oc1..XXXXX",
  "defined_tags": {
    "Oracle-Tags": {
      "CreatedBy": "oracleidentitycloudservice/poonia0arun@gmail.com",
      "CreatedOn": "2020-11-17T03:29:25.852Z"
    }
  },
  "etag": "be3ca3bd-3b63-498f-b5b0-e01e28a22162",
  "freeform_tags": {},
  "id": "ocid1.bucket.oc1.us-sanjose-1.XXXXX",
  "is_read_only": false,
  "kms_key_id": null,
  "metadata": {},
  "name": "test-arun",
  "namespace": "axwj21nkyyrd",
  "object_events_enabled": false,
  "object_lifecycle_policy_etag": null,
  "public_access_type": "NoPublicAccess",
  "replication_enabled": false,
  "storage_tier": "Standard",
  "time_created": "2020-11-17T03:29:25.858000+00:00",
  "versioning": "Disabled"
}
Create Bucket                                                         | PASS |
------------------------------------------------------------------------------
List Bucket                                                           .[{
  "compartment_id": "ocid1.tenancy.oc1..XXXXX",
  "created_by": "ocid1.user.oc1..XXXXX",
  "defined_tags": null,
  "etag": "be3ca3bd-3b63-498f-b5b0-e01e28a22162",
  "freeform_tags": null,
  "name": "test-arun",
  "namespace": "axwj21nkyyrd",
  "time_created": "2020-11-17T03:29:25.858000+00:00"
}]
List Bucket                                                           | PASS |
------------------------------------------------------------------------------
Delete Bucket                                                         .None
Delete Bucket                                                         | PASS |
------------------------------------------------------------------------------
Oracle                                                                | PASS |
5 critical tests, 5 passed, 0 failed
5 tests total, 5 passed, 0 failed
==============================================================================
Output:  /Users/apoonia/Desktop/paloaltogcp/palo-alto-oracle-partner/oracle-python/test-suites/test_reports/spartan-output-20201116-192924.xml
Log:     /Users/apoonia/Desktop/paloaltogcp/palo-alto-oracle-partner/oracle-python/test-suites/test_reports/spartan-log-20201116-192924.html
Report:  /Users/apoonia/Desktop/paloaltogcp/palo-alto-oracle-partner/oracle-python/test-suites/test_reports/spartan-report-20201116-192924.html
```

## Feedback

User can use this repository as starting point and enhance it accordingly.