install:
	python3 -m venv .venv && \
	source .venv/bin/activate && \
	pip install -r requirements.txt && \
	[ ! -e ".env" ] && cp .env.example .env || echo ".env file already exists"
test:
	source .venv/bin/activate && \
	robot tests/

clean:
	rm -rf reports/