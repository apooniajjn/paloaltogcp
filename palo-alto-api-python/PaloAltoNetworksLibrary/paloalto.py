""" Library for Palo Alto integration """

import json

import requests
import xmltodict
import urllib3
from robot.api import logger
from robot.api.deco import keyword
from urllib3.exceptions import HTTPError

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)


class PaloAlto:
    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def __init__(self, base_url=None, verify_ssl=False):
        """Initialize an Instance of Palo Alto class."""
        self.headers = {
            'Accept': 'application/json'
        }
        self.host = ""
        self.version = "v10.0"
        self.session = requests.Session()
        self.session.headers.update({
            'Content-type': 'application/json',
            'Accept': 'application/json'
        })

    @keyword("Generate API Key", tags=["Common", "Authentication", "Login"])
    def generate_api_key(self, username, password, base_url=None):
        """Connect to Pan OS API and Generate key.

        This method returns generated API key.
        """
        self.host = base_url
        # url = self.host + "api/?type=keygen&user=" + username + "&password=" + password
        response = self.session.get(PaloAlto.build_url(
            self.host, "/api/?type=keygen&user=" + username + "&password=" + password), verify=False)
        if response.status_code >= 200 and response.status_code < 300:
            json_data = json.dumps(xmltodict.parse(response.content))
            self.key = json.loads(json_data)["response"]["result"]["key"]
            self.session.headers.update({
                'X-PAN-KEY': self.key})
            return self.key
        else:
            raise Exception(json.loads(response.text))

    @keyword("List Addresses", tags=["Common", "Addresses"])
    def list_addresses(self, location, vsys=None):
        """List Addresses in a Location/System.

        This method returns list Addresses.
        """
        payload = {'location': location, 'vsys': vsys}
        response = self.session.get(PaloAlto.api_url(
            self.host, self.version, "/Objects/Addresses"), params=payload, verify=False)
        if response.status_code >= 200 and response.status_code < 300:
            return json.loads(response.text)
        else:
            raise Exception(json.loads(response.text))

    @keyword("Create Addresses", tags=["Common", "Addresses"])
    def create_addresses(self, address_entry_name, location, vsys=None):
        """Create Addresses in a Location/System.

        This method returns list Addresses.
        """
        payload = {
            'location': location,
            'vsys': vsys,
            'name': address_entry_name
        }
        address_data = {
            "entry": [
                {
                    "@name": address_entry_name,
                    "ip-netmask": "10.40.10.0/24"
                }
            ]
        }
        response = self.session.post(PaloAlto.api_url(
            self.host, self.version, "/Objects/Addresses"), params=payload, data=address_data, verify=False)
        if response.status_code >= 200 and response.status_code < 300:
            return json.loads(response.text)
        else:
            raise Exception(json.loads(response.text))

    @keyword("List Security Policies", tags=["Common", "Addresses"])
    def list_security_polcies(self, location, vsys=None):
        """List Security Policies in a Location.

        This method returns list Security Policies.
        """
        payload = {'location': location, 'vsys': vsys}
        response = self.session.get(PaloAlto.api_url(
            self.host, self.version, "/Policies/SecurityRules"), params=payload, verify=False)
        if response.status_code >= 200 and response.status_code < 300:
            return json.loads(response.text)
        else:
            raise Exception(json.loads(response.text))

    @staticmethod
    def build_url(host, path):
        """Palo Alto Networks API Auth URL."""
        return host + path

    @staticmethod
    def api_url(host, version, path):
        """Palo Alto Networks API Build URL."""
        return host + "/restapi/" + version + path
