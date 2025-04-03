
from prefect import flow
from prefect_shell import ShellOperation



@flow
def trigger_meltano():
    with ShellOperation(
        commands=[
            "cd /mnt/meltano/pemik-dwh && meltano run srv1-extract dwhdb-load dwh-transform",
        ],
        working_dir="/mnt/meltano/pemik-dwh",
    ) as meltano_operation:

        meltano_process = meltano_operation.trigger()
        meltano_process.wait_for_completion()
        output_lines = meltano_process.fetch_result()
        print(output_lines)



if __name__ == "__main__":
    trigger_meltano.serve(name="prefect-meltano-deployment", cron="0/5 0-23 * * *")
