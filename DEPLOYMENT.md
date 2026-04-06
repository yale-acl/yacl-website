# Deployment

This site can be deployed automatically from GitHub Actions using a self-hosted runner on the Yale/internal network.

## Why self-hosted

The production target is an internal server:

- host: `cs-www.cs.yale.edu`
- path: `/srv/www/htdocs/cswww/yacl`

GitHub-hosted runners will not be able to reach that target directly, so deployment should run on a machine that:

1. can reach GitHub
2. can SSH to `cs-www.cs.yale.edu`
3. has Ruby/Bundler available

## Workflow

The workflow lives at `.github/workflows/deploy.yml`.

It runs on:

- pushes to `main`
- manual trigger via `workflow_dispatch`

It expects a self-hosted runner labeled:

- `self-hosted`
- `yacl-deploy`

## Required secrets

Set these repository secrets in GitHub:

- `YACL_REMOTE_USER`
- `YACL_REMOTE_HOST`
- `YACL_REMOTE_PATH`

Recommended values:

- `YACL_REMOTE_HOST=cs-www.cs.yale.edu`
- `YACL_REMOTE_PATH=/srv/www/htdocs/cswww/yacl`

## Runner setup notes

The self-hosted runner should have:

- `ruby`
- `bundle`
- `rsync`
- SSH credentials that allow deployment to the target host without interactive prompts

The deploy script reads environment overrides, so the same script works both locally and in CI:

```bash
./deploy-cs.sh
```

or

```bash
REMOTE_USER=your_netid \
REMOTE_HOST=cs-www.cs.yale.edu \
REMOTE_PATH=/srv/www/htdocs/cswww/yacl \
./deploy-cs.sh
```
