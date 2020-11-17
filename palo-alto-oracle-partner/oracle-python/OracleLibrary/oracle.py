""" Library for Oracle integration """

import json

import oci
import requests
import xmltodict
import urllib3
from robot.api import logger
from robot.api.deco import keyword
from urllib3.exceptions import HTTPError

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

from oci.object_storage.models import CreateBucketDetails

class Oracle:
    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def __init__(self):
        """Initialize an Instance of Oracle class."""
        self.config = oci.config.from_file("~/.oci/config","DEFAULT")

    @keyword("Get User", tags=["Common", "Authentication"])
    def get_user(self):
        """Connect to Oracle API and get user details."""
        identity = oci.identity.IdentityClient(self.config)
        user = identity.get_user(self.config["user"]).data
        return user

    @keyword("Get Namespace", tags=["Common", "Namespace"])
    def get_namespace(self, compartment_id=None):
        """Connect to Oracle API and get namespace details."""
        object_storage_client = oci.object_storage.ObjectStorageClient(self.config)
        namespace = object_storage_client.get_namespace(compartment_id=self.config["tenancy"]).data
        return namespace

    @keyword("Create Bucket", tags=["Common", "Authentication", "Object"])
    def create_bucket(self, namespace_name, bucket_name, compartment_id=None):
        """Connect to Oracle API and create bucket."""
        bucket_details = CreateBucketDetails()
        bucket_details.compartment_id = self.config["tenancy"]
        bucket_details.name = bucket_name
        storage = oci.object_storage.ObjectStorageClient(self.config)
        created_bucket = storage.create_bucket(namespace_name=namespace_name,create_bucket_details=bucket_details).data
        return created_bucket

    @keyword("List Buckets", tags=["Common", "Authentication", "Object"])
    def list_buckets(self, namespace_name, compartment_id=None):
        """Connect to Oracle API and list buckets."""
        storage = oci.object_storage.ObjectStorageClient(self.config)
        list_buckets = storage.list_buckets(namespace_name=namespace_name,compartment_id=self.config["tenancy"]).data
        return list_buckets

    @keyword("Delete Bucket", tags=["Common", "Authentication", "Object"])
    def delete_bucket(self, namespace_name, bucket_name):
        """Connect to Oracle API and delete bucket."""
        storage = oci.object_storage.ObjectStorageClient(self.config)
        deleted_bucket = storage.delete_bucket(namespace_name=namespace_name,bucket_name=bucket_name).data
        return deleted_bucket