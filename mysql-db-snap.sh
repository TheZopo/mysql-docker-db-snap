#!/bin/bash -e

# Usage :
#       ./mysql-db-snap.sh --dump-host=127.0.0.1 --dump-port=3308 --dump-user=bingo-ifa --dump-password=bingo-ifa --databases=bingo-ifa --image=bm/bingo-ifa/test-data

# ========================
#        PARAMETERS
# ========================
for i in "$@"
do
case $i in
    -dh=*|--dump-host=*)
    DUMP_HOST="${i#*=}"
    shift
    ;;
    -dp=*|--dump-port=*)
    DUMP_PORT="${i#*=}"
    shift
    ;;
    -du=*|--dump-user=*)
    DUMP_USERNAME="${i#*=}"
    shift
    ;;
    -d=*|--databases=*)
    DB_DUMP_NAMES="${i#*=}"
    IFS=':' read -r -a DB_DUMP_NAMES_ARRAY <<< "$DB_DUMP_NAMES"
    shift
    ;;
    -dP=*|--dump-password=*)
    DUMP_PASSWORD="${i#*=}"
    shift
    ;;
    -i=*|--image=*)
    IMAGE="${i#*=}"
    shift
    ;;
    -iv=*|--image-version=*)
    IMAGE_VERSION="${i#*=}"
    shift
    ;;
    *)
        # unknown option
    ;;
esac
done

# ========================
#      CONFIGURATION
# ========================
# Definition
CONF_DOCKERFILE=Dockerfile
CONF_REGISTRY=registry.mouseover.fr:5000
CONF_IMAGE="mo/data/unknow-data"

CONF_DUMP_PORT=3306
CONF_DUMP_PATH=dumps

# Environment resolve
[[ -z ${DOCKERFILE} ]] && FILE_NAME=${CONF_DOCKERFILE}
[[ -z ${REGISTRY} ]] && REGISTRY=${CONF_REGISTRY}
[[ -z ${IMAGE} ]] && IMAGE=${CONF_IMAGE}
[[ -z ${DUMP_PORT} ]] && DUMP_PORT=${CONF_DUMP_PORT}
DUMP_PATH=${CONF_DUMP_PATH}/${IMAGE}

# Environment logging
echo "=== ENVIRONMENT ==="
echo "IMAGE=${IMAGE}"
echo "REGISTRY=${REGISTRY}"
echo "DUMP_HOST=${DUMP_HOST}"
echo "DUMP_PORT=${DUMP_PORT}"
echo "DUMP_USER=${DUMP_USERNAME}"
echo "DUMP_PASSWORD=${DUMP_PASSWORD}"
echo "DB_DUMP_NAMES_ARRAY=${DB_DUMP_NAMES_ARRAY}"
echo "DUMP_PATH=${DUMP_PATH}"
echo "==================="
# =========================

echo "===> Cleaning old dump"
    rm -Rf ${DUMP_PATH}
    mkdir -p ${DUMP_PATH}
echo "Done."

for (( i=0; i<${#DB_DUMP_NAMES_ARRAY[@]}; i++ )); do
    if [ -z "$DB_DUMP_PATHS" ]; then
        echo "===> Dump database ${DB_DUMP_NAMES_ARRAY[$i]}."
        mysqldump --host=${DUMP_HOST} \
                --port=${DUMP_PORT} \
                --user=${DUMP_USERNAME} \
                --password=${DUMP_PASSWORD} \
                --databases ${DB_DUMP_NAMES_ARRAY[$i]} > "${DUMP_PATH}/${DB_DUMP_NAMES_ARRAY[$i]}.sql"
        echo "Done."
    else
        echo "===> Copying database dump ${DB_DUMP_NAMES_ARRAY[$i]} to container."
        cp ${DB_DUMP_PATHS_ARRAY[$i]} "${DUMP_PATH}/${DB_DUMP_NAMES_ARRAY[$i]}.sql"
        echo "Done."
    fi
done

echo "===> Building image"
docker build --no-cache -t $IMAGE -f $FILE_NAME --build-arg dump_path=${DUMP_PATH} .
echo "Done."

echo "===> Exporting image to registry"
docker tag $IMAGE $REGISTRY/$IMAGE
docker push $REGISTRY/$IMAGE
docker rmi $REGISTRY/$IMAGE || true
docker rmi $IMAGE || true
echo "Done."