#!/bin/bash
set -e

# export UID=$(id -u)
GID=$(id -g)
docker build --build-arg USER="$USER" \
    --build-arg UID="$UID" \
    --build-arg GID="$GID" \
    --tag "gd32" \
    .