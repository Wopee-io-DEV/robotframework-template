install:
	python -m venv .venv && \
	source .venv/bin/activate && \
	pip install -r requirements.txt && \
	cp .env.example .env

test:
	source .venv/bin/activate && \
	robot tests/

clean:
	rm -rf reports/