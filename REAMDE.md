# mysql-db-snap
Shell script creating a snapshot of mysql databases and pushing it to a docker image in a registry.

## Options
|Option|Desription|
|---|---|
|`--dump-host`, `-dh`|MySQL server host|
|`--dump-port`, `-dp`|MySQL server port|
|`--dump-user`, `-du`|MySQL username|
|`--dump-password`, `-dP`|MySQL password|
|`--databases`, `-d`|Database names separated by `:`|
|`--image`, `-i`|Output image name|
|`--image-versions`, `-iv`|Output image tag|

Exemple:
```shell
./mysql-db-snap.sh -dh=127.0.0.1 -du=root -dP=password -d=bingo-ifa -i=bm/bingo-ifa/test-data -iv=latest
```

## Environment variables
|Variable name|Description|
|---|---|
|`REGISTRY`|Registry URL|
|`DUMP_PATH`|Directory where dumps are stored|

## Contributors
Bastien Marsaud