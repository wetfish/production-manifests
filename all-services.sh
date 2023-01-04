#!/usr/bin/env bash

set -eu

# where this .sh file lives
DIRNAME=$(dirname "$0")
SCRIPT_DIR=$(cd "$DIRNAME" || exit; pwd)
cd "$SCRIPT_DIR" || exit

# dir with compose file
# relative to this dir
PROJECT_DIRS=("traefik" "services/blog")

# ensure they provided a subcommand
if [ $# -eq 0 ]
  then
    echo "Error: Must specify action to take"
    echo "Error: [up / down / restart]"
    exit 1
fi

# test for newer style compose
docker compose version
if [ $? -ne 0 ]; then
    echo "Error: Newer type of docker compose plugin not found"
    exit 2
fi

# eval arg and run commands
case $1 in
  "stop")
    for DIR in "${PROJECT_DIRS[@]}"; do
      echo "About to run \"docker compose down\" in ${DIR}"
      cd "${SCRIPT_DIR}/${DIR}" && docker compose down || exit
    done
  ;;

  "start")
    for DIR in "${PROJECT_DIRS[@]}"; do
      echo "About to run \"docker compose up -d --force-recreate\" in ${DIR}"
      cd "${SCRIPT_DIR}/${DIR}" && docker compose up -d --force-recreate || exit
    done
  ;;

  "restart")
    for DIR in "${PROJECT_DIRS[@]}"; do
      echo "About to run \"docker compose down && docker compose up -d --force-recreate\" in ${DIR}"
      cd "${SCRIPT_DIR}/${DIR}" && docker compose down && docker compose up -d --force-recreate || exit
    done
  ;;
esac
