"""Robot Framework variable file: the App URL and suite name for the sample test.

The shell or CI environment wins over `.env`, so the same test runs locally and in
GitHub Actions. A value still holding a `{placeholder}` counts as not set.
"""

import os
from datetime import datetime

from dotenv import dotenv_values

FALLBACK_URL = "https://dronjo.wopee.io"


def _setting(name, dot_env):
    value = os.environ.get(name) or dot_env.get(name) or ""
    return "" if value.startswith("{") else value


def get_variables(dot_env_path=".env"):
    dot_env = dotenv_values(dot_env_path) if os.path.exists(dot_env_path) else {}
    return {
        "WOPEE_PROJECT_URL": _setting("WOPEE_PROJECT_URL", dot_env) or FALLBACK_URL,
        "WOPEE_SUITE_NAME": _setting("WOPEE_SUITE_NAME", dot_env)
        or f"Robot Framework sample {datetime.now():%Y-%m-%d %H:%M}",
    }
