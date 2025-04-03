from prefect import flow, task



@flow
def trigger_meltano():
    print('hello meltano')



if __name__ == "__main__":
    trigger_meltano.serve(name="prefect-meltano-deployment", cron="0/5 0-23 * * *")
