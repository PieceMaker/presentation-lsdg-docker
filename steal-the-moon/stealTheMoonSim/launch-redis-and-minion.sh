#!/usr/bin/env bash
docker network create redis

docker run --rm --network=redis redis
docker run --rm --network=redis steal-the-moon-minion # Crashes because it can't see Redis

docker run --name redis --rm --network=redis redis
docker run --rm --network=redis steal-the-moon-minion # Now it can connect, but we can't connect from R

docker run --name redis --rm --network=redis -p 6379:6379 redis
docker run --rm --network=redis steal-the-moon-minion # That's better

# Now let's do a full deployment in one command
docker-compose up