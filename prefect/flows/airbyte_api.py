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


def get_info():
    client_id, client_secret = get_abctl_credentials()
    token = get_airbyte_token(client_id, client_secret)
    app_id, clinet_id, client_secret = get_credentials(token)
    return token, app_id, clinet_id, client_secret, AIRBYTE_URL, API_URL


#https://reference.airbyte.com/reference/listsources
def get_sources(url, api, token):
    url = f"{url}/{api}/sources"
    headers = {
        "accept": "application/json",
        "authorization": f"Bearer {token}"
    }
    response = requests.get(url, headers=headers)
    return response.json()


#https://reference.airbyte.com/reference/listdestinations
def get_destinations(url, api, token):
    url = f"{url}/{api}/destinations"
    headers = {
        "accept": "application/json",
        "authorization": f"Bearer {token}"
    }
    response = requests.get(url, headers=headers)
    return response.json()


#https://reference.airbyte.com/reference/listconnections
def get_connections(url, api, token):
    url = f"{url}/{api}/connections"
    headers = {
        "accept": "application/json",
        "authorization": f"Bearer {token}"
    }
    response = requests.get(url, headers=headers)
    return response.json()


#https://reference.airbyte.com/reference/listworkspaces
def get_workspaces(url, api, token):
    url = f"{url}/{api}/workspaces"
    headers = {
        "accept": "application/json",
        "authorization": f"Bearer {token}"
    }
    response = requests.get(url, headers=headers)
    return response.json()

#https://reference.airbyte.com/reference/createsource
def createsource(url, api, token, workspace_id):
    url = f"{url}/{api}/sources"
    payload = {
        'name': 'Postgres SRV1', 
        'workspaceId': f'{workspace_id}', 
        'configuration': {
            'sourceType': 'postgres', 
            'host': 'host.docker.internal', 
            'port': 5431, 
            'schemas': ['public'], 
            'database': 'cms', 
            'password': 'pass', 
            'ssl_mode': {
                'mode': 'disable'
            }, 
            'username': 'airbyte', 
            'tunnel_method': {
                'tunnel_method': 'NO_TUNNEL'
            }, 
            'replication_method': {
                'method': 'CDC', 
                'plugin': 'pgoutput', 
                'queue_size': 10000, 
                'publication': 'airbyte_publication', 
                'replication_slot': 'airbyte_slot', 
                'lsn_commit_behaviour': 'After loading Data in the destination', 
                'heartbeat_action_query': "INSERT INTO airbyte_heartbeat (text) VALUES ('heartbeat')", 
                'initial_waiting_seconds': 1200, 
                'initial_load_timeout_hours': 8, 
                'invalid_cdc_cursor_position_behavior': 'Re-sync data'
            }
        }
    }
    headers = {
        "accept": "application/json",
        "content-type": "application/json",
        "authorization": f"Bearer {token}"
    }
    response = requests.post(url, json=payload, headers=headers)
    return response.json()


#https://reference.airbyte.com/reference/createdestination
def createdestination(url, api, token, workspace_id):
    url = f"{url}/{api}/destinations"
    payload = {
        'name': 'Postgres DWHDB', 
        'workspaceId': f'{workspace_id}', 
        'configuration': {
            'destinationType': 'postgres',
            'ssl': False, 
            'host': 'host.docker.internal', 
            'port': 5454, 
            'schema': 'staging', 
            'database': 'dwh', 
            'password': 'pass', 
            'ssl_mode': {
                'mode': 'disable'
            }, 
            'username': 'airbyte', 
            'drop_cascade': False, 
            'tunnel_method': {
                'tunnel_method': 'NO_TUNNEL'
            }, 
            'disable_type_dedupe': False, 
            'unconstrained_number': True
        }
    }
    headers = {
        "accept": "application/json",
        "content-type": "application/json",
        "authorization": f"Bearer {token}"
    }
    response = requests.post(url, json=payload, headers=headers)
    return response.json()


#https://reference.airbyte.com/reference/createconnection
def createconnection(url, api, token, source_id, destination_id, workspace_id):
    url = f"{url}/{api}/connections"
    payload = {
        'name': 'Postgres SRV1 → Postgres DWHDB', 
        'sourceId': f'{source_id}', 
        'destinationId': f'{destination_id}', 
        'workspaceId': f'{workspace_id}', 
        'status': 'active', 
        'schedule': {
            'scheduleType': 'manual'
        }, 
        'dataResidency': 'auto', 
        'configurations': {
            'streams': [
                {
                    'name': 'purchases', 
                    'syncMode': 'incremental_deduped_history', 
                    'cursorField': ['_ab_cdc_lsn'], 
                    'primaryKey': [['purchase_id']]
                }, {
                    'name': 'cities', 
                    'syncMode': 
                    'incremental_deduped_history', 
                    'cursorField': ['_ab_cdc_lsn'], 
                    'primaryKey': [['city_id']]
                }, {
                    'name': 'account_holders', 
                    'syncMode': 'incremental_deduped_history', 
                    'cursorField': ['_ab_cdc_lsn'], 
                    'primaryKey': [['account_holder_id']]
                }, {
                    'name': 'payments', 
                    'syncMode': 'incremental_deduped_history', 
                    'cursorField': ['_ab_cdc_lsn'], 
                    'primaryKey': [['payment_id']]
                }, {
                    'name': 'partners', 
                    'syncMode': 'incremental_deduped_history', 
                    'cursorField': ['_ab_cdc_lsn'], 
                    'primaryKey': [['partner_id']]
                }, {
                    'name': 'genders', 
                    'syncMode': 'incremental_deduped_history', 
                    'cursorField': ['_ab_cdc_lsn'], 
                    'primaryKey': [['gender_id']]
                }, {
                    'name': 'persons', 
                    'syncMode': 'incremental_deduped_history', 
                    'cursorField': ['_ab_cdc_lsn'], 
                    'primaryKey': [['person_id']]
                }, {
                    'name': 'bank_accounts', 
                    'syncMode': 'incremental_deduped_history', 
                    'cursorField': ['_ab_cdc_lsn'], 
                    'primaryKey': [['bank_account_id']]
                }, {
                    'name': 'debts', 
                    'syncMode': 'incremental_deduped_history', 
                    'cursorField': ['_ab_cdc_lsn'], 
                    'primaryKey': [['debt_id']]
                }, {
                    'name': 'debtors', 
                    'syncMode': 'incremental_deduped_history', 
                    'cursorField': ['_ab_cdc_lsn'], 
                    'primaryKey': [['debtor_id']]
                }, {
                    'name': 'payed_debts', 
                    'syncMode': 'incremental_deduped_history', 
                    'cursorField': ['_ab_cdc_lsn'], 
                    'primaryKey': [['payed_debt_id']]
                }, {
                    'name': 'regions', 
                    'syncMode': 'incremental_deduped_history', 
                    'cursorField': ['_ab_cdc_lsn'], 
                    'primaryKey': [['region_id']]
                }, {
                    'name': 'cases', 
                    'syncMode': 'incremental_deduped_history', 
                    'cursorField': ['_ab_cdc_lsn'], 
                    'primaryKey': [['case_id']]
                }, {
                    'name': 'debtor_types', 
                    'syncMode': 'incremental_deduped_history', 
                    'cursorField': ['_ab_cdc_lsn'], 
                    'primaryKey': [['debtor_type_id']]
                }, {
                    'name': 'sectors', 
                    'syncMode': 'incremental_deduped_history', 
                    'cursorField': ['_ab_cdc_lsn'], 
                    'primaryKey': [['sector_id']]
                }]
            }, 
            'nonBreakingSchemaUpdatesBehavior': 'propagate_columns', 
            'namespaceDefinition': 'destination', 
            'prefix': ''
        }
    headers = {
        "accept": "application/json",
        "content-type": "application/json",
        "authorization": f"Bearer {token}"
    }
    response = requests.post(url, json=payload, headers=headers)
    return response.json()
