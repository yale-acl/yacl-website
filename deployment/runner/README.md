# Runner Container

This directory contains a minimal GitHub Actions self-hosted runner image for deployment.

Files:

- `Dockerfile`
- `entrypoint.sh`
- `docker-compose.yml`
- `scripts/bootstrap-runner-host.sh`

Expected runtime environment variables:

- `GITHUB_URL`
- `RUNNER_TOKEN`
- `RUNNER_NAME` optional
- `RUNNER_LABELS` optional, defaults to `yacl-deploy`
- `RUNNER_WORKDIR` optional
- `SSH_KEY_PATH` optional, path to mounted SSH private key

Example build:

```bash
./deployment/runner/scripts/bootstrap-runner-host.sh
```

Example run:

```bash
docker run -d \
  --name yacl-runner \
  -e GITHUB_URL=https://github.com/yale-acl/yacl-website \
  -e RUNNER_TOKEN=YOUR_REGISTRATION_TOKEN \
  -e RUNNER_LABELS=yacl-deploy \
  -e SSH_KEY_PATH=/home/runner/.ssh/id_ed25519 \
  -v yacl-runner-work:/home/runner/_work \
  -v $HOME/yacl-runner-ssh:/home/runner/.ssh:ro \
  yacl-runner
```

Example Docker Compose usage:

```bash
cd deployment/runner
export GITHUB_URL=https://github.com/yale-acl/yacl-website
export RUNNER_TOKEN=YOUR_REGISTRATION_TOKEN
docker compose up -d
```

Notes:

- The runner needs outbound access to GitHub.
- The mounted SSH directory should contain the deploy key used to reach `cs-www.cs.yale.edu`.
- Prefer a dedicated SSH directory such as `$HOME/yacl-runner-ssh`, not your personal `$HOME/.ssh`.
- Registration tokens expire quickly; use a fresh one when creating or replacing the runner.

## Fresh Ubuntu 24.04 host bootstrap

If Docker is already installed on a fresh Ubuntu 24.04 host, you can use:

```bash
./deployment/runner/scripts/bootstrap-runner-host.sh
```

This script:

- validates the host OS
- verifies Docker access
- installs small missing host utilities if needed
- generates a deploy SSH key if one does not already exist
- builds the runner image

This creates:

- an `id_ed25519`
- a matching `.pub`
- `config`
- `known_hosts`
