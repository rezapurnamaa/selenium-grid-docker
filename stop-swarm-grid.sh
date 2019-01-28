#!/bin/bash
eval $(docker-machine env swarm-berlin)
docker stack rm selenium-swarm
docker stop 
docker-machine rm swarm-berlin swarm-prague swarm-paris swarm-rome -y
eval "$(docker-machine env -u)"

