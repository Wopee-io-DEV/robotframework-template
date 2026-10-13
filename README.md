# Wopee.io Robot Framework tests

Robot Framework project with Wopee.io visual testing set up. The sample test `tests/wopee.robot` opens your app with the Browser library, waits until fonts and images are loaded and sends a full-page screenshot to Wopee.io. Wopee.io compares it with the approved baseline and shows the result in Commander. Start from this test and add your own pages and flows.

## Run in GitHub Actions

Open **Actions › Run Robot Framework tests › Run workflow**. Nothing to set up: the repository already has the `WOPEE_API_KEY` secret, and `.github/workflows/.env` has your project's API URL, project UUID and App URL.

## Run locally

Needs Python 3.11 or newer and Node.js 18 or newer (for the Browser library). On macOS, `python3` is often 3.9: install a newer one (`brew install python@3.12`) and use it for the first command.

```shell
git clone <this repository>
cd <repository folder>
cp .env.example .env
```

Open `.env` and paste an API key after `WOPEE_API_KEY=`. Create one in Commander under **More › Settings › API Keys** (it is shown only once). The other values are already filled in for your project. If you cloned the public template instead, replace the `{…}` placeholders with your project's API URL (`https://api.wopee.io`), project UUID (same page as the API keys) and the URL of your app.

```shell
python3 -m venv .venv
source .venv/bin/activate        # Windows: .venv\Scripts\activate
pip install -r requirements.txt
rfbrowser init chromium
robot -d results tests
```

`rfbrowser init chromium` is needed once; it downloads Chromium for the Browser library. Run `robot` from the repository folder: the tests read `.env` from the current folder. Results are in `results/log.html`.

`.env` is in `.gitignore`. Never commit your API key.

## Review in Commander

Open your project in [Commander](https://cmd.wopee.io) › **Runs**. Every run is its own suite, `Robot Framework sample <date time>`. The first run has no baseline, so its steps are **New**: approve them to make them the baseline. Later runs are compared with it: approve a change you expect, reject a bug. Visual differences do not fail the Robot Framework test.

## Make it yours

- **App URL**: the test opens `WOPEE_PROJECT_URL` (the App URL you entered when creating the project). Change it in `.env` and `.github/workflows/.env`, or for one run: `robot -d results -v WOPEE_PROJECT_URL:https://example.com tests`.
- **Add a check**: after an interaction, track another step:
  ```robotframework
  Click             text=Pricing
  Page Ready
  Track Fullpage    step_name=Pricing page
  ```
  `Page Ready` (in `resources/wopee.resource`) waits for fonts and images so the screenshot shows the finished page. Every test in `tests/` gets its own scenario: the test setup starts the suite and a scenario named after the test, the teardown stops it.
- **Examples**: `test-examples/` has more examples (viewport screenshots, SeleniumLibrary, the listener that tracks keywords without changing the tests, the GraphQL API). They are not part of `robot -d results tests`. Run one with `robot -d results test-examples/browser_standalone.robot`; the SeleniumLibrary examples need `WOPEE_DRIVER_LIBRARY=SeleniumLibrary` in front of the command, the listener examples are described in the [docs](https://docs.wopee.io/robot-framework/02-manual-setup/), the GraphQL API example in `API_INTEGRATION.md`.

## Add Wopee.io to an existing Robot Framework project

Follow [Robot Framework getting started](https://docs.wopee.io/robot-framework/01-getting-started/). This repository is a working reference for the files involved: `requirements.txt`, `.env.example`, `resources/wopee.resource` and `tests/wopee.robot`. Keep the last two lines of `.env.example`: without `WOPEE_SCREENSHOT_VALIDATION_ENABLED=true` and `WOPEE_DRIVER_LIBRARY` (`BrowserLibrary` or `SeleniumLibrary`) the keywords send nothing.

`requirements.txt` installs `wopee_rf` from a release file rather than PyPI: the PyPI package cannot be imported yet because it does not install its `wopee_sdk` dependency.

## Troubleshooting

- **`ModuleNotFoundError: No module named 'wopee_sdk'`** or **`Importing library 'wopee_rf.Standalone' failed`**: `wopee_rf` came from PyPI. Install with `pip install -r requirements.txt`.
- **`pip install` runs for minutes or finds no `wopee_rf`**: the virtual environment uses Python older than 3.11. Delete `.venv` and create it with a newer Python.
- **`Environment variable: WOPEE_PROJECT_UUID (missing: Field required)`**: no `.env` in the current folder. Run `robot` from the repository folder.
- **`Not Authorised!`**: `WOPEE_API_URL`, `WOPEE_PROJECT_UUID` and `WOPEE_API_KEY` must come from the same Commander (cmd.wopee.io uses `https://api.wopee.io`).
- **The test passes but nothing shows up in Commander**: `.env` lacks `WOPEE_SCREENSHOT_VALIDATION_ENABLED=true` or `WOPEE_DRIVER_LIBRARY=BrowserLibrary`.
