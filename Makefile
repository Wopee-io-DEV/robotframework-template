SHELL := /bin/bash

install:
	python3 -m venv .venv && \
	source .venv/bin/activate && \
	pip install -r requirements.txt && \
	[ ! -e ".env" ] && cp .env.example .env || echo ".env file already exists" && \
	python3 chromedriver.py

test:
	source .venv/bin/activate && \
	robot tests/agnostic_standalone.robot

clean:
	rm -rf reports/