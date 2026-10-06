#!/usr/bin/env python3
"""Report production deployment failures and stalled self-hosted jobs."""

import json
import os
import re
from datetime import datetime, timedelta, timezone
from urllib.parse import urlencode
from urllib.request import Request, urlopen


MARKER = "<!-- yacl-deployment-monitor:"
FAILED = {"failure", "timed_out", "action_required", "startup_failure"}


class GitHub:
    def __init__(self, repository, token):
        self.base = f"https://api.github.com/repos/{repository}"
        self.token = token

    def request(self, path, method="GET", payload=None):
        data = json.dumps(payload).encode() if payload is not None else None
        request = Request(
            self.base + path,
            data=data,
            method=method,
            headers={
                "Authorization": f"Bearer {self.token}",
                "Accept": "application/vnd.github+json",
                "Content-Type": "application/json",
                "User-Agent": "yacl-deployment-monitor",
            },
        )
        with urlopen(request, timeout=30) as response:
            return json.load(response)

    def paginate(self, path, key=None):
        page = 1
        while True:
            separator = "&" if "?" in path else "?"
            result = self.request(f"{path}{separator}per_page=100&page={page}")
            items = result[key] if key else result
            yield from items
            if len(items) < 100:
                return
            page += 1


def incident(run, jobs, now, queue_minutes):
    if run["conclusion"] in FAILED:
        return "Production workflow failed", f"Conclusion: `{run['conclusion']}`."
    for job in jobs:
        if job["status"] != "queued" or "yacl-deploy" not in job.get("labels", []):
            continue
        queued_at = job.get("created_at") or job.get("started_at") or run["run_started_at"]
        age = now - datetime.fromisoformat(queued_at.replace("Z", "+00:00"))
        if age > timedelta(minutes=queue_minutes):
            return (
                f"Deployment queued over {queue_minutes} minutes",
                f"The `deploy` job has been queued since {queued_at} and has not "
                "been picked up by a runner with the `yacl-deploy` label.\n\n"
                "Check the runner container, available disk space, and runner updates.",
            )
    return None


def monitor(api, repository, branch, assignee, queue_minutes=10, dry_run=False, now=None):
    now = now or datetime.now(timezone.utc)
    query = urlencode({"branch": branch, "event": "push", "per_page": 1})
    runs = api.request(f"/actions/workflows/deploy.yml/runs?{query}")["workflow_runs"]
    if not runs:
        print("No production workflow runs found.")
        return
    run = runs[0]
    jobs = []
    if run["status"] != "completed":
        jobs = list(api.paginate(f"/actions/runs/{run['id']}/jobs?filter=latest", "jobs"))
    problem = incident(run, jobs, now, queue_minutes)
    run_url = f"https://github.com/{repository}/actions/runs/{run['id']}"
    print(f"Latest production run: {run_url}; {run['status']}/{run['conclusion']}")
    print(f"Monitor result: {problem[0] if problem else 'no alert'}")
    if dry_run:
        print("Dry run: no issues created or changed.")
        return

    issues = [
        issue for issue in api.paginate("/issues?state=all")
        if not issue.get("pull_request")
        and issue.get("user", {}).get("login") == "github-actions[bot]"
        and (issue.get("body") or "").startswith(MARKER)
    ]
    if problem:
        marker = f"{MARKER}{run['id']}:{run.get('run_attempt', 1)} -->"
        title = f"Deployment alert: {problem[0]}"
        body = (
            f"{marker}\n\n## {problem[0]}\n\n{problem[1]}\n\n"
            f"[View production workflow run]({run_url}) "
            f"(attempt {run.get('run_attempt', 1)}).\n\n"
            "This monitor runs on GitHub-hosted infrastructure, independently of "
            "the Yale runner. It will close this issue after a successful production "
            "run. Repeated checks do not create duplicate alerts."
        )
        existing = next((issue for issue in issues if issue["body"].startswith(marker)), None)
        if existing is None:
            issue = api.request("/issues", "POST", {
                "title": title, "body": body, "assignees": [assignee],
            })
            print(f"Created alert: {issue['html_url']}")
        elif existing["body"] != body or existing["state"] != "open":
            api.request(f"/issues/{existing['number']}", "PATCH", {
                "title": title, "body": body, "state": "open",
            })
            api.request(f"/issues/{existing['number']}/comments", "POST", {
                "body": f"Deployment status changed: **{problem[0]}**. [View run]({run_url}).",
            })
        return

    # Leave existing alerts open while a replacement run is still building/deploying.
    if run["conclusion"] == "success":
        for issue in issues:
            match = re.match(r"<!-- yacl-deployment-monitor:(\d+):(\d+) -->", issue["body"])
            if issue["state"] != "open" or not match or int(match[1]) > run["id"]:
                continue
            api.request(f"/issues/{issue['number']}/comments", "POST", {
                "body": f"Deployment recovered: [production workflow run]({run_url}) succeeded.",
            })
            api.request(f"/issues/{issue['number']}", "PATCH", {
                "state": "closed", "state_reason": "completed",
            })
            print(f"Closed recovered alert #{issue['number']}.")


if __name__ == "__main__":
    repository = os.environ["GITHUB_REPOSITORY"]
    monitor(
        GitHub(repository, os.environ["GITHUB_TOKEN"]),
        repository,
        os.environ.get("MONITOR_BRANCH", "main"),
        os.environ.get("MONITOR_ASSIGNEE", "bl4ck5un"),
        int(os.environ.get("MONITOR_QUEUE_MINUTES", "10")),
        os.environ.get("MONITOR_DRY_RUN", "false").lower() == "true",
    )
