#!/bin/bash
for i in berlin paris rome prague; do
	docker-machine create -d virtualbox swarm-$i
done
echo "MACHINE ARE CREATED."
eval $(docker-machine env swarm-berlin)
docker run -it -d -p 5000:8080 -v /var/run/docker.sock:/var/run/docker.sock dockersamples/visualizer
TOKEN=$(docker swarm join-token -q manager)
INIT_IP=$(docker-machine ip swarm-berlin)
echo $(docker-machine ip swarm-berlin)" IS MANAGER"
for i in berlin paris rome prague; do
	eval $(docker-machine env swarm-$i)
	docker swarm join --advertise-addr $(docker-machine ip swarm-$i) --token $TOKEN $INIT_IP:2377
done
