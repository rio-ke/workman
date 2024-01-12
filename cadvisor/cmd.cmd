docker-compose build

docker-compose up -d

docker-compose down

docker rm nodexpo promo alertman cadvisor


docker-compose down --rmi all


docker logs nodexpo
docker logs promo
docker logs alertman
docker logs cadvisor


#swarm

docker swarm init

docker stack deploy -c docker-compose.yml monitor_groups

docker stack services monitor_groups

