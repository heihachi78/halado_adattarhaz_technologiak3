FROM prefecthq/prefect:3.0.0rc14-python3.11

ENV PREFECT_API_URL=http://prefsrv:4200/api

EXPOSE 4200

CMD ["prefect", "server", "start", "--host", "0.0.0.0"]
