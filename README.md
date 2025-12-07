# Robot Framework Template

## Quick start for visual testing with Robot Framework and Wopee.io

1. Clone this repository
2. Copy .env.example to .env and set your Wopee.io API key
3. Create virtual environment (optional) and install dependencies and init Browser library:

```bash
python -m venv venv
source venv/bin/activate  # On Windows use `venv\Scripts\activate`
pip install -r requirements.txt
rfbrowser init
```

4. Run tests:

```bash
robot tests/
```

## Alternative: Quick start (with Makefile)

1. Clone this repository
2. Copy .env.example to .env and set your Wopee.io API key
3. Install: `make install`
4. Run tests: `make test`

---

Read more https://docs.wopee.io/robot-framework/01-getting-started/
