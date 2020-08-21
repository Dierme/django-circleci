#!/usr/bin/env sh

wait_for_postgres() (
	first_iteration=true
	while ! docker exec "djangoci_test-db" pg_isready -h "localhost" -q; do
		if [ -n "$first_iteration" ]; then
			printf "Waiting for db \"postgresql://%s@%s:%s\"" "$DB_USER" "$DB_HOST" "$DB_PORT"
			unset first_iteration
		else
			printf "."
		fi

		sleep 1
	done
	if [ -z "$first_iteration" ]; then echo; fi
)

# Base path of script, needed to run other scripts in same dir.
SCRIPT=$(readlink "$0")
BASE_PATH=$(dirname "$SCRIPT")
SOURCE_DIR=$(cd $BASE_PATH; pwd)

docker run --name "djangoci_test-db" --env-file .env.db.dev -d -p 5445:5432 --rm postgres:12.0-alpine

if [ "$1" == "--build" ]; then
    docker build -t djangoci_test-web:latest . -f test.Dockerfile;
fi

wait_for_postgres

docker run \
    --name "djangoci_test-web" \
    -v $SOURCE_DIR:/home/app/web/ \
    --rm \
    --link=djangoci_test-db \
    --env-file .env.test \
    djangoci_test-web:latest

# Purges the database so we have a clean slate on the next run
docker kill "djangoci_test-web"
docker kill "djangoci_test-db"
