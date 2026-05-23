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

## New stack

**1. Deploy stack in Portainer**
- Upload or paste the stack file, fill in environment variables, deploy.

**2. Connect the frontend network to the reverse proxy**

If the stack defines its own `frontend` overlay network, attach it to the reverse proxy so Nginx can reach the service.

Via Portainer: Networks → select the network → connect the reverse proxy container.

Via CLI:
```sh
docker network connect frontend <reverse-proxy-container-id>
```

**3. Get the service webhook**
- In Portainer → Services → select the service → Webhooks → copy the URL.

**4. Add the webhook to your GitHub repo secrets**
- Repo → Settings → Secrets and variables → Actions → New repository secret.
- Name: `PORTAINER_WEBHOOK_URL`, value: the copied URL.

**5. Add the GitHub Actions workflow and push**

Create `.github/workflows/deploy.yml`:
```yaml
name: Deploy
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Trigger Portainer redeploy
        run: curl -X POST "${{ secrets.PORTAINER_WEBHOOK_URL }}"
```

Commit and push — subsequent pushes to `main` will trigger a rolling redeploy.

> Stacks use `order: start-first` with a health check, so the old container stays up until the new one is ready.
