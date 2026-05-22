# node-setup

Docker Swarm node setup with Nginx reverse proxy and Portainer.

## Usage

**1. Install Docker**
```sh
bash install-docker.sh
```

**2. Initialize Docker Swarm**
```sh
docker swarm init
```

**3. Deploy stacks**
```sh
bash init-stack.sh
```

## Stacks

| Stack | Description |
|---|---|
| `reverse-proxy` | Nginx reverse proxy with automatic Let's Encrypt SSL |
| `portainer` | Portainer CE + agent for container management |

## Environment

Portainer requires the following env vars before deploying:

```
LETSENCRYPT_HOST=
VIRTUAL_HOST=
VIRTUAL_PORT=9000
```
