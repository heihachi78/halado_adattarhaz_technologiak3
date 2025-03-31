#https://docs.prefect.io/integrations/prefect-dbt/index
#https://docs.airbyte.com/using-airbyte/configuring-api-access



from prefect import flow, task
import requests
import time
import json


@task
def collect_airbyte_info():
    with open("prefect/flows/cred.json", "r") as cred_file:
        credentials = json.load(cred_file)
    return (
        credentials["token"],
        credentials["app_id"],
        credentials["client_id"],
        credentials["client_secret"],
        credentials["connection_id"],
        credentials["airbyte_url"],
        credentials["api_url"],
    )


#https://reference.airbyte.com/reference/createjob
@task
def run_airbyte_sync_job(url, api, token, connection_id):
    url = f"{url}/{api}/jobs"
    payload = { 
        "jobType": "sync", 
        "connectionId": f"{connection_id}" 
    }
    headers = {
        "accept": "application/json",
        "content-type": "application/json",
        "authorization": f"Bearer {token}"
    }
    response = requests.post(url, json=payload, headers=headers)
    response.raise_for_status()
    return response.json()['jobId']


#https://reference.airbyte.com/reference/getjob
@task
def check_airbyte_sync_job(url, api, token, job_id):
    url = f"{url}/{api}/jobs/{job_id}"
    headers = {
        "accept": "application/json",
        "authorization": f"Bearer {token}"
    }
    status = 'unknown'
    while status in ('pending', 'running', 'unknown'): #pending running incomplete failed succeeded cancelled
        response = requests.get(url, headers=headers)
        status = response.json()['status']
        time.sleep(1)
    print(response.text)


@flow
def trigger_airbyte_sync():
    TOKEN, app_id, client_id, client_secret, CONNECTION_ID, AIRBYTE_URL, API_URL = collect_airbyte_info()
    JOB_ID = run_airbyte_sync_job(AIRBYTE_URL, API_URL, TOKEN, CONNECTION_ID)
    check_airbyte_sync_job(AIRBYTE_URL, API_URL, TOKEN, JOB_ID)



if __name__ == "__main__":
    trigger_airbyte_sync.serve(name="prefect-airbyte-deployment", cron="0/5 0-23 * * *")
