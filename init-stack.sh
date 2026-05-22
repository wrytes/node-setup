set -a; source .env; set +a

docker stack rm reverse-proxy
docker stack rm portainer

sleep 20

docker stack deploy -c portainer-agent.yml portainer
docker stack deploy -c reverse-proxy.yml reverse-proxy