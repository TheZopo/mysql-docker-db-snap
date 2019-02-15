# mysql-docker-db-snap
Shell script creating a snapshot of mysql databases and pushing it to a mariadb docker image in a registry.

## Options
|Option|Desription|
|---|---|
|`--host`, `-h`|MySQL server host|
|`--port`, `-p`|MySQL server port|
|`--user`, `-u`|MySQL username|
|`--password`, `-P`|MySQL password|
|`--databases`, `-d`|Database names separated by `,`|
|`--image`, `-i`|Output image name|
|`--image-version`, `-iv`|Output image tag|

Exemple:
```shell
./mysql-db-snap.sh --host=127.0.0.1 --port=3308 --user=bingo-ifa --password=bingo-ifa --databases=bingo-ifa --image=bm/bingo-ifa/test-data --image-version=latest
```

## Environment variables
|Variable name|Description|
|---|---|
|`REGISTRY`|Registry URL|
|`DUMP_PATH`|Directory where dumps are stored|

## Contributors
Bastien Marsaud