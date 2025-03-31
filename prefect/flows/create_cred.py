from airbyte_api import get_info, get_sources, get_destinations, get_connections, get_workspaces, createsource, createdestination, createconnection
import json

token, app_id, client_id, client_secret, airbyte_url, api_url = get_info()

#source = (get_sources(airbyte_url, api_url, token)['data'])[0]
#destination = (get_destinations(airbyte_url, api_url, token)['data'])[0]
#connection = (get_connections(airbyte_url, api_url, token)['data'])[0]
workspace = (get_workspaces(airbyte_url, api_url, token)['data'])[0]
source = createsource(airbyte_url, api_url, token, workspace['workspaceId'])
destination = createdestination(airbyte_url, api_url, token, workspace['workspaceId'])
connection = createconnection(airbyte_url, api_url, token, source['sourceId'], destination['destinationId'], workspace['workspaceId'])

credentials = {
    "token": token,
    "app_id": app_id,
    "client_id": client_id,
    "client_secret": client_secret,
    "connection_id": connection['connectionId'],
    "airbyte_url": airbyte_url,
    "api_url": api_url
}

with open("prefect/flows/cred.json", "w") as cred_file:
    json.dump(credentials, cred_file, indent=4)


#{'sourceId': 'd566d457-c512-4a25-a7c3-012bcff22327', 'name': 'Postgres SRV1', 'sourceType': 'postgres', 'definitionId': 'decd338e-5647-4c0b-adf4-da0e75f5a750', 'workspaceId': '571dd508-92ae-4f53-bf82-9a4ebf5ddda6', 'configuration': {'host': 'host.docker.internal', 'port': 5431, 'schemas': ['public'], 'database': 'cms', 'password': '**********', 'ssl_mode': {'mode': 'disable'}, 'username': 'airbyte', 'tunnel_method': {'tunnel_method': 'NO_TUNNEL'}, 'replication_method': {'method': 'CDC', 'plugin': 'pgoutput', 'queue_size': 10000, 'publication': 'airbyte_publication', 'replication_slot': 'airbyte_slot', 'lsn_commit_behaviour': 'After loading Data in the destination', 'heartbeat_action_query': "INSERT INTO airbyte_heartbeat (text) VALUES ('heartbeat')", 'initial_waiting_seconds': 1200, 'initial_load_timeout_hours': 8, 'invalid_cdc_cursor_position_behavior': 'Re-sync data'}}, 'createdAt': 1743418599}
#{'destinationId': '42568001-ad38-406a-b7a1-3f6dc2cf01d0', 'name': 'Postgres DWHDB', 'destinationType': 'postgres', 'definitionId': '25c5221d-dce2-4163-ade9-739ef790f503', 'workspaceId': '571dd508-92ae-4f53-bf82-9a4ebf5ddda6', 'configuration': {'ssl': False, 'host': 'host.docker.internal', 'port': 5454, 'schema': 'staging', 'database': 'dwh', 'password': '**********', 'ssl_mode': {'mode': 'disable'}, 'username': 'airbyte', 'drop_cascade': False, 'tunnel_method': {'tunnel_method': 'NO_TUNNEL'}, 'disable_type_dedupe': False, 'unconstrained_number': False}, 'createdAt': 1743418646}
#{'connectionId': '213d83c4-7ded-41cd-aa2e-27b7bf7d3668', 'name': 'Postgres SRV1 → Postgres DWHDB', 'sourceId': 'd566d457-c512-4a25-a7c3-012bcff22327', 'destinationId': '42568001-ad38-406a-b7a1-3f6dc2cf01d0', 'workspaceId': '571dd508-92ae-4f53-bf82-9a4ebf5ddda6', 'status': 'active', 'schedule': {'scheduleType': 'basic', 'basicTiming': 'Every 1 HOURS'}, 'dataResidency': 'auto', 'configurations': {'streams': [{'name': 'purchases', 'syncMode': 'incremental_deduped_history', 'cursorField': ['_ab_cdc_lsn'], 'primaryKey': [['purchase_id']], 'selectedFields': [], 'mappers': []}, {'name': 'cities', 'syncMode': 'incremental_deduped_history', 'cursorField': ['_ab_cdc_lsn'], 'primaryKey': [['city_id']], 'selectedFields': [], 'mappers': []}, {'name': 'account_holders', 'syncMode': 'incremental_deduped_history', 'cursorField': ['_ab_cdc_lsn'], 'primaryKey': [['account_holder_id']], 'selectedFields': [], 'mappers': []}, {'name': 'payments', 'syncMode': 'incremental_deduped_history', 'cursorField': ['_ab_cdc_lsn'], 'primaryKey': [['payment_id']], 'selectedFields': [], 'mappers': []}, {'name': 'partners', 'syncMode': 'incremental_deduped_history', 'cursorField': ['_ab_cdc_lsn'], 'primaryKey': [['partner_id']], 'selectedFields': [], 'mappers': []}, {'name': 'genders', 'syncMode': 'incremental_deduped_history', 'cursorField': ['_ab_cdc_lsn'], 'primaryKey': [['gender_id']], 'selectedFields': [], 'mappers': []}, {'name': 'persons', 'syncMode': 'incremental_deduped_history', 'cursorField': ['_ab_cdc_lsn'], 'primaryKey': [['person_id']], 'selectedFields': [], 'mappers': []}, {'name': 'bank_accounts', 'syncMode': 'incremental_deduped_history', 'cursorField': ['_ab_cdc_lsn'], 'primaryKey': [['bank_account_id']], 'selectedFields': [], 'mappers': []}, {'name': 'debts', 'syncMode': 'incremental_deduped_history', 'cursorField': ['_ab_cdc_lsn'], 'primaryKey': [['debt_id']], 'selectedFields': [], 'mappers': []}, {'name': 'debtors', 'syncMode': 'incremental_deduped_history', 'cursorField': ['_ab_cdc_lsn'], 'primaryKey': [['debtor_id']], 'selectedFields': [], 'mappers': []}, {'name': 'payed_debts', 'syncMode': 'incremental_deduped_history', 'cursorField': ['_ab_cdc_lsn'], 'primaryKey': [['payed_debt_id']], 'selectedFields': [], 'mappers': []}, {'name': 'regions', 'syncMode': 'incremental_deduped_history', 'cursorField': ['_ab_cdc_lsn'], 'primaryKey': [['region_id']], 'selectedFields': [], 'mappers': []}, {'name': 'cases', 'syncMode': 'incremental_deduped_history', 'cursorField': ['_ab_cdc_lsn'], 'primaryKey': [['case_id']], 'selectedFields': [], 'mappers': []}, {'name': 'debtor_types', 'syncMode': 'incremental_deduped_history', 'cursorField': ['_ab_cdc_lsn'], 'primaryKey': [['debtor_type_id']], 'selectedFields': [], 'mappers': []}, {'name': 'sectors', 'syncMode': 'incremental_deduped_history', 'cursorField': ['_ab_cdc_lsn'], 'primaryKey': [['sector_id']], 'selectedFields': [], 'mappers': []}]}, 'createdAt': 1743418682, 'tags': [], 'nonBreakingSchemaUpdatesBehavior': 'propagate_columns', 'namespaceDefinition': 'destination', 'prefix': ''}
#{'workspaceId': '571dd508-92ae-4f53-bf82-9a4ebf5ddda6', 'name': 'Default Workspace', 'dataResidency': 'auto', 'notifications': {}}