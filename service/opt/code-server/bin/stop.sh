#!/usr/bin/env bash

echo "Stopping code-server"
docker stop code-server && docker rm -f code-server

