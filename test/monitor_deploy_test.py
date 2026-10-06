import importlib.util
import unittest
from contextlib import redirect_stdout
from datetime import datetime, timezone
from io import StringIO
from pathlib import Path


spec = importlib.util.spec_from_file_location(
    "monitor_deploy", Path(__file__).parents[1] / ".github/scripts/monitor_deploy.py"
)
monitor_deploy = importlib.util.module_from_spec(spec)
spec.loader.exec_module(monitor_deploy)

NOW = datetime(2026, 10, 6, 18, 0, tzinfo=timezone.utc)


def run(status="in_progress", conclusion=None, attempt=1):
    return {
        "id": 123, "status": status, "conclusion": conclusion,
        "run_attempt": attempt, "run_started_at": "2026-10-06T17:00:00Z",
    }


def queued(created_at="2026-10-06T17:49:00Z", labels=None):
    return {
        "status": "queued", "created_at": created_at,
        "labels": labels if labels is not None else ["self-hosted", "yacl-deploy"],
    }


class FakeAPI:
    def __init__(self, workflow_run, jobs=(), issues=()):
        self.run = workflow_run
        self.jobs = list(jobs)
        self.issues = list(issues)
        self.writes = []

    def request(self, path, method="GET", payload=None):
        if method == "GET":
            if not path.startswith("/actions/workflows/deploy.yml/runs?"):
                raise AssertionError(f"Unexpected request: {path}")
            if "event=push" not in path or "branch=main" not in path:
                raise AssertionError("Monitor must restrict to production push runs")
            return {"workflow_runs": [self.run] if self.run else []}
        self.writes.append((path, method, payload))
        return {"html_url": "https://github.com/yale-acl/yacl-website/issues/1"}

    def paginate(self, path, key=None):
        if path.startswith("/actions/runs/"):
            return iter(self.jobs)
        if path == "/issues?state=all":
            return iter(self.issues)
        raise AssertionError(f"Unexpected pagination: {path}")


def check(api, dry_run=False):
    with redirect_stdout(StringIO()):
        monitor_deploy.monitor(
            api, "yale-acl/yacl-website", "main", "bl4ck5un", dry_run=dry_run, now=NOW
        )


def alert_issue(body, state="open", author="github-actions[bot]"):
    return {"number": 1, "body": body, "state": state, "user": {"login": author}}


class DeploymentMonitorTest(unittest.TestCase):
    def test_long_queue_creates_assigned_alert(self):
        api = FakeAPI(run(), [queued()])
        check(api)
        self.assertEqual(len(api.writes), 1)
        payload = api.writes[0][2]
        self.assertEqual(payload["assignees"], ["bl4ck5un"])
        self.assertIn("123:1 -->", payload["body"])
        self.assertIn("queued over 10 minutes", payload["title"])

    def test_young_queue_and_unrelated_runner_do_not_alert(self):
        for job in [queued("2026-10-06T17:51:00Z"), queued(labels=["ubuntu-latest"])]:
            with self.subTest(job=job):
                api = FakeAPI(run(), [job])
                check(api)
                self.assertEqual(api.writes, [])

    def test_rerun_uses_job_creation_time_instead_of_old_run_time(self):
        api = FakeAPI(run(attempt=2), [queued("2026-10-06T17:59:00Z")])
        check(api)
        self.assertEqual(api.writes, [])

    def test_repeated_check_does_not_duplicate_or_notify(self):
        api = FakeAPI(run(), [queued()])
        check(api)
        body = api.writes[0][2]["body"]
        repeated = FakeAPI(run(), [queued()], [alert_issue(body)])
        check(repeated)
        self.assertEqual(repeated.writes, [])

    def test_failure_and_timeout_alert_even_without_deploy_job(self):
        for conclusion in ["failure", "timed_out"]:
            with self.subTest(conclusion=conclusion):
                api = FakeAPI(run("completed", conclusion))
                check(api)
                self.assertEqual(len(api.writes), 1)
                self.assertIn(conclusion, api.writes[0][2]["body"])

    def test_changed_problem_updates_same_issue_and_notifies_once(self):
        api = FakeAPI(run(), [queued()])
        check(api)
        body = api.writes[0][2]["body"]
        failed = FakeAPI(run("completed", "failure"), issues=[alert_issue(body)])
        check(failed)
        self.assertEqual([write[1] for write in failed.writes], ["PATCH", "POST"])
        self.assertEqual(failed.writes[0][0], "/issues/1")
        new_body = failed.writes[0][2]["body"]
        repeated = FakeAPI(run("completed", "failure"), issues=[alert_issue(new_body)])
        check(repeated)
        self.assertEqual(repeated.writes, [])

    def test_success_closes_only_older_monitor_owned_open_issues(self):
        issues = [
            alert_issue("<!-- yacl-deployment-monitor:122:1 -->"),
            alert_issue("<!-- yacl-deployment-monitor:124:1 -->"),
            alert_issue("<!-- yacl-deployment-monitor:121:1 -->", author="bl4ck5un"),
            alert_issue("Unrelated issue"),
            alert_issue("<!-- yacl-deployment-monitor:120:1 -->", state="closed"),
        ]
        api = FakeAPI(run("completed", "success"), issues=issues)
        check(api)
        self.assertEqual(len(api.writes), 2)
        self.assertEqual(api.writes[-1][2], {"state": "closed", "state_reason": "completed"})

    def test_cancellation_and_running_replacement_leave_alert_open(self):
        issue = alert_issue("<!-- yacl-deployment-monitor:122:1 -->")
        for workflow_run in [run("completed", "cancelled"), run()]:
            with self.subTest(workflow_run=workflow_run):
                api = FakeAPI(workflow_run, issues=[issue])
                check(api)
                self.assertEqual(api.writes, [])

    def test_dry_run_never_changes_issues(self):
        api = FakeAPI(run(), [queued()])
        check(api, dry_run=True)
        self.assertEqual(api.writes, [])


if __name__ == "__main__":
    unittest.main()
