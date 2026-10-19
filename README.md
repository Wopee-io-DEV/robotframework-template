# Robot Framework + Wopee.io

This repository is your project's Robot Framework test suite with Wopee.io visual testing already wired in.
Wopee.io created it when you created the project in [Commander](https://cmd.wopee.io), and filled in your project settings.
The sample test `tests/simple.robot` opens your app's URL with the Browser library and takes one full-page screenshot that Wopee.io compares with an approved baseline.
Run it as it is first, then grow it into your own tests.

## Run from Commander

Nothing to set up. In Commander open **Runs** › **Start testing**. Commander runs this repository's tests in GitHub Actions with your project settings (the API key is the repository's `WOPEE_API_KEY` secret) and shows the results under Runs.

Want the tests on every push or pull request? Add your own trigger to `.github/workflows/tests.yml`.

## Run locally

Needs Python 3.11 or newer, Node.js (for the Browser library), `make` and git.
On macOS `python3` is often 3.9; check with `python3 --version`. With Homebrew, `brew install python@3.11` and run `make install` as `PATH="$(brew --prefix python@3.11)/libexec/bin:$PATH" make install`.

```shell
git clone <this repository>
cd <repository folder>
cp .env.example .env
```

Open `.env` and paste an API key after `WOPEE_API_KEY=`. Create one in Commander › More › Settings › API Keys (the key is shown only once).
The other values are already your project's. Keep `.env` out of git; it is in `.gitignore`.

```shell
make install
make test
```

`make install` creates `.venv`, installs `requirements.txt` and downloads the browsers for the Browser library (`rfbrowser init`, a few minutes the first time). `make test` loads `.env` and runs `tests/simple.robot`. In `reports/log.html` the `Track Fullpage` keyword logs a `Tracking response` with the step's status and a link to it in Commander.

## Review in Commander

Open Commander › Runs and the suite "Suite name-&lt;timestamp&gt;".

- First run: the step `Landing page` has status **new**. Check the screenshot and **Approve** it; it becomes the baseline.
- Next runs: the step is **ok** when the page looks the same, or **unresolved** when it differs. Open it to see the difference, then Approve (new baseline) or Reject.

A visual difference is reported in Commander; it does not fail the Robot Framework test.

## Make it yours

- **Your app:** the sample opens `WOPEE_PROJECT_URL` (the App URL you entered in Commander). Change it in `.env` for local runs; for runs from Commander, change the App URL in Commander.
- **Add a check:** after any interaction, one line tracks another screenshot:

  ```robot
  Track Fullpage    step_name=Contact page
  ```

  Every `step_name` in a scenario gets its own baseline.
- **More tests:** Commander and `make test` run `tests/simple.robot`. Add test cases there; every test needs what the sample shows: `Start Suite`, `Start Scenario`, a `Track Fullpage` (or `Track Viewport`), `Stop Scenario`.
- **Examples:** `test-examples/` shows the SeleniumLibrary, the listener (tracks a screenshot after chosen keywords) and the GraphQL API (`make test.api`, see `API_INTEGRATION.md`). They are not part of the default run; to try one, copy it into `tests/` and run its `make` target, e.g. `make test.browser` for `browser_standalone.robot`.

## Add Wopee.io to an existing Robot Framework project

Follow [Robot Framework getting started](https://docs.wopee.io/robot-framework/01-getting-started/) in the Wopee.io docs.

Install `wopee_rf` from the release file in this repository's `requirements.txt`, not with `pip install wopee_rf`: the version on PyPI cannot be imported yet (`No module named 'wopee_sdk'`).

## Troubleshooting

- **The test passes but nothing appears in Commander** (`${track_result} = None` in `reports/log.html`): `.env` is missing, or it lacks `WOPEE_SCREENSHOT_VALIDATION_ENABLED=true` and `WOPEE_DRIVER_LIBRARY=BrowserLibrary` (`SeleniumLibrary` for SeleniumLibrary tests). Without them wopee_rf uploads nothing. Run `cp .env.example .env` and paste the API key.
- **`Not Authorised!`**: the API key usually belongs to another Wopee.io instance (or another project). Create the key in the Commander you run against. `WOPEE_API_URL` is only for self-hosted instances; leave it out for cmd.wopee.io (the default is `https://api.wopee.io`).
- **`make install` runs `pip` for many minutes without finishing**: `python3` is older than 3.11. Run `rm -rf .venv` and install again with a newer Python first in `PATH` (see Run locally).
- **`API key and project UUID are required`**: the key in `.env` is empty. Paste it after `WOPEE_API_KEY=`.
- **A local run is unresolved against a baseline from Commander:** expected; your screen, fonts and browser differ from Commander's runner. Keep the baseline from one place (usually Commander) and do not approve local screenshots over it. To accept small differences, set `WOPEE_PIXEL_TO_PIXEL_DIFF_TOLERANCE` in `.env`.
- **`put-your-project-uuid-here` in `.env`**: you cloned the public template, not your project's repository. Put in your project UUID from Commander › More › Settings › API Keys (`WOPEE_PROJECT_UUID`) and your app's URL (`WOPEE_PROJECT_URL`).
