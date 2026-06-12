set -a; source .env; set +a

docker stack rm reverse-proxy-tor
docker stack rm reverse-proxy
docker stack rm portainer

sleep 20

docker stack deploy -c core/portainer-agent.yml portainer
docker stack deploy -c core/reverse-proxy.yml reverse-proxy
docker stack deploy -c core/reverse-proxy-tor.yml reverse-proxy-tor