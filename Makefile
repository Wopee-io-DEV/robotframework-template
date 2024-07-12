SHELL := /bin/bash

install:
	python3 -m venv --system-site-packages .venv && \
	source .venv/bin/activate && \
	pip install -r requirements.txt &&\
	[ ! -e ".env" ] && cp .env.example .env || echo ".env file already exists"

test:
	source .venv/bin/activate && \
	robot tests/agnostic_standalone.robot

test.selenium.listener:
	source .venv/bin/activate && \
	export WOPEE_DRIVER_LIBRARY=SeleniumLibrary && \
	robot --listener 'wopee_rf.Listener:--dot_env_path:.env' tests/selenium_listener.robot


test.browser.listener:
	source .venv/bin/activate && \
	python3 -m Browser.entry init && \
	export WOPEE_DRIVER_LIBRARY=BrowserLibrary && \
	robot --listener 'wopee_rf.Listener:--dot_env_path:.env' tests/browser_listener.robot

clean:
	rm -rf reports/