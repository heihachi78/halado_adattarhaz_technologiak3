import requests
import subprocess
import re



AIRBYTE_URL = "http://127.0.0.1:8000"
API_URL = "api/public/v1"


def get_abctl_credentials():
    cmd = "abctl local credentials | grep Client | awk '{print $5}'"
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    clean_output = re.sub(r'\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])', '', result.stdout)
    credentials = clean_output.strip().split("\n")
    if len(credentials) >= 2:
        client_id = credentials[0]
        client_secret = credentials[1]
    else:
        print("Error: Could not retrieve credentials.")
    return client_id, client_secret


#https://reference.airbyte.com/reference/createaccesstoken
def get_airbyte_token(client_id, client_secret):
    api_url = f"{AIRBYTE_URL}/{API_URL}/applications/token"
    json_payload = {"client_id": f"{client_id}", "client_secret": f"{client_secret}"}
    response = requests.post(api_url, json=json_payload)
    response.raise_for_status()
    return response.json()['access_token']


#https://reference.airbyte.com/reference/listapplications
def get_application_list(token):
    url = f"{AIRBYTE_URL}/{API_URL}/applications"
    headers = {
        "accept": "application/json",
        "authorization": f"Bearer {token}"
    }
    response = requests.get(url, headers=headers)
    response.raise_for_status()
    return response.json()


def get_credentials(token):
    app_list = get_application_list(token)
    app_id, clinet_id, client_secret = app_list['applications'][0]['id'], app_list['applications'][0]['clientId'], app_list['applications'][0]['clientSecret']
    return app_id, clinet_id, client_secret


#https://reference.airbyte.com/reference/listconnections
def get_connection_list(token):
    import requests
    url = f"{AIRBYTE_URL}/{API_URL}/connections"
    headers = {
        "accept": "application/json",
        "authorization": f"Bearer {token}"
    }
    response = requests.get(url, headers=headers)
    response.raise_for_status()
    return response.json()


def get_connection_id(token):
    conn_list = get_connection_list(token)
    conn_id = conn_list['data'][0]['connectionId']
    return conn_id


def get_all_info():
    client_id, client_secret = get_abctl_credentials()
    token = get_airbyte_token(client_id, client_secret)
    app_id, clinet_id, client_secret = get_credentials(token)
    conn_id = get_connection_id(token)
    return token, app_id, clinet_id, client_secret, conn_id, AIRBYTE_URL, API_URL
