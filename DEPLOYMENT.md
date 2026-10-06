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

## Netlify

The repository is also connected to Netlify. `netlify.toml` adds an `X-Robots-Tag: noindex` header to every response so that Netlify-hosted copies of the site are not indexed by search engines. Production is served from `cs-www.cs.yale.edu` via the workflow above.

## Deployment alerts

`.github/workflows/monitor-deploy.yml` runs on a GitHub-hosted runner every five
minutes and after production workflow completion. It checks the latest `main`
push run of `Deploy Site`, regardless of who triggered it, and opens a GitHub issue
assigned to `bl4ck5un` when:

- the production workflow fails (including a build failure or timeout); or
- a job requiring `yacl-deploy` stays queued for more than ten minutes.

The monitor reuses an issue for the same run and attempt, updates it if the problem
changes, and closes open alerts after a successful production run. Intentional
cancellations and pull-request builds do not generate alerts. Alerts remain open
while a replacement deployment is running. Change `MONITOR_ASSIGNEE` or
`MONITOR_QUEUE_MINUTES` in the monitor workflow to adjust the recipient or threshold.

Issue assignment uses your GitHub notifications. Enable email under **Settings →
Notifications → Participating, @mentions and custom** to receive these alerts by
email. This is separate from the built-in Actions failure notification setting.

To check the monitor manually, open **Actions → Monitor deployment → Run workflow**.
Select `dry_run` to inspect current deployment health without changing issues.
No extra secrets or external notification service are required.

GitHub schedules can be delayed, so the ten-minute threshold is checked on the next
monitor run rather than guaranteeing delivery at exactly ten minutes. GitHub also
disables scheduled workflows in public repositories after 60 days without activity;
re-enable the monitor in the Actions tab if the repository becomes inactive.
