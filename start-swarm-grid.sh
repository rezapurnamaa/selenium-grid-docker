#!/bin/bash
for i in berlin paris rome prague; do
	docker-machine create -d virtualbox swarm-$i
done
echo "MACHINE ARE CREATED."
eval $(docker-machine env swarm-berlin)
docker swarm init --advertise-addr $(docker-machine ip swarm-berlin)
docker run -it -d -p 5000:8080 -v /var/run/docker.sock:/var/run/docker.sock dockersamples/visualizer
TOKEN=$(docker swarm join-token -q manager)
INIT_IP=$(docker-machine ip swarm-berlin)
echo $(docker-machine ip swarm-berlin)" IS MANAGER"
for i in paris rome prague; do
	eval $(docker-machine env swarm-$i)
	docker swarm join --advertise-addr $(docker-machine ip swarm-$i) --token $TOKEN $INIT_IP:2377
done
echo "DOCKER SWARM IS READY."
echo "DEPLOYING selenium-swarm"
eval $(docker-machine env swarm-berlin)
docker stack deploy --compose-file grid.yaml selenium-swarm
echo "open selenium grid console in browser"
open http://$(docker-machine ip swarm-berlin):4444/grid/console
echo "open docker visualizer"
open http://$(docker-machine ip swarm-berlin):5000
eval "$(docker-machine env -u)"
echo "selenium-grid is ready"
