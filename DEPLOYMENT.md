# Deployment

## Workflow

Deployment is handled by `.github/workflows/deploy.yml`.

When a qualifying change is pushed to `main`, GitHub Actions does the following:

1. start a `build` job on a GitHub-hosted runner
2. run `bundle exec jekyll build`
3. stop immediately if the build fails
4. if the build succeeds, start the `deploy` job on the Yale self-hosted runner, which runs `./deploy-cs.sh` to publish the site to production

This means production is only updated after the site builds successfully in CI.

For pull requests that touch the same site-relevant paths, GitHub Actions runs the `build` job as a basic site check, but does not run the deploy job.

## When It Runs

The workflow runs automatically on pushes to `main` when one of these paths changes:

- `_config.yml`
- `_data/**`
- `_includes/**`
- `_layouts/**`
- `_pages/**`
- `assets/**`
- `index.md`

The same path filter is used for pull requests.

It can also be triggered manually with `workflow_dispatch`.
