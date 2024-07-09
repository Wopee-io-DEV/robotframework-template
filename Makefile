SHELL := /bin/bash

install:
	python3 -m venv .venv && \
	source .venv/bin/activate && \
	pip install -r requirements.txt && \
	[ ! -e ".env" ] && cp .env.example .env || echo ".env file already exists" && \
	python3 -m Browser.entry init

test:
	source .venv/bin/activate && \
	robot tests/selenium_standalone.robot

clean:
	rm -rf reports/