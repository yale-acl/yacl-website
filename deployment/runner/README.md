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
- `SSH_HOST_DIR` optional for Compose, defaults to `$HOME/yacl-runner-ssh`

Example build:

```bash
./deployment/runner/scripts/bootstrap-runner-host.sh
```

Example Docker Compose usage:

```bash
cd deployment/runner
export GITHUB_URL=https://github.com/yale-acl
export RUNNER_TOKEN=YOUR_REGISTRATION_TOKEN
export SSH_HOST_DIR=$HOME/yacl-runner-ssh
docker build -t yacl-runner .
docker compose up -d
```

Notes:

- The runner needs outbound access to GitHub.
- The mounted SSH directory should contain the deploy key used to reach `cs-www.cs.yale.edu`.
- Prefer a dedicated SSH directory such as `$HOME/yacl-runner-ssh`, not your personal `$HOME/.ssh`.
- Registration tokens expire quickly; use a fresh one when creating or replacing the runner.
- The mounted SSH directory must contain `id_ed25519`, plus the related SSH config files.
- If the container says `SSH key not found at /home/runner/.ssh/id_ed25519`, verify the host mount:

```bash
ls -la "$HOME/yacl-runner-ssh"
docker compose exec yacl-runner ls -la /home/runner/.ssh
```

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
