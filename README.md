# node-setup

Docker Swarm node setup with Nginx reverse proxy and Portainer.

## Setup

```sh
bash install-docker.sh
docker swarm init
bash init-stack.sh
```

## Core stacks

| File | Stack | Description |
|---|---|---|
| `core/portainer-agent.yml` | `portainer` | Portainer CE + agent |
| `core/reverse-proxy.yml` | `reverse-proxy` | Nginx + Let's Encrypt SSL |
| `core/reverse-proxy-tor.yml` | `reverse-proxy-tor` | Tor reverse proxy |

## App stacks

| File | Description |
|---|---|
| `stacks/wrytes-api.yml` | Wrytes API (Node + Postgres + Redis) |
| `stacks/wrytes-app.yml` | Wrytes frontend app |
| `stacks/umami-analytics.yml` | Umami analytics (Node + Postgres) |
| `stacks/hermes-agent.yml` | Hermes agent |
| `stacks/3dotsinc-app.yml` | 3dots Inc app |

Deploy any stack via:
```sh
docker stack deploy -c stacks/<file>.yml <stack-name>
```

## Continuous deployment

1. Portainer → Services → select service → Webhooks → copy URL
2. Add as `PORTAINER_WEBHOOK_URL` in GitHub repo secrets
3. Add workflow:

```yaml
# .github/workflows/deploy.yml
name: Deploy
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - run: curl -X POST "${{ secrets.PORTAINER_WEBHOOK_URL }}"
```

> Stacks use `order: start-first` with health checks — old container stays up until the new one is healthy.
