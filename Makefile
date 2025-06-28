SHELL := /bin/bash

install:
	python3 -m venv --system-site-packages .venv && \
	source .venv/bin/activate && \
	pip install -r requirements.txt && \
	rfbrowser init && \
	[ ! -e ".env" ] && cp .env.example .env || echo ".env file already exists"

test:
	source .venv/bin/activate && \
	export WOPEE_DRIVER_LIBRARY=BrowserLibrary && \
	python -m robot -d reports tests/simple.robot

test.selenium:
	source .venv/bin/activate && \
	export WOPEE_DRIVER_LIBRARY=SeleniumLibrary && \
	python -m robot -d reports tests/selenium_standalone.robot

test.browser:
	source .venv/bin/activate && \
	export WOPEE_DRIVER_LIBRARY=BrowserLibrary && \
	python -m robot -d reports tests/browser_standalone.robot

test.selenium.listener:
	source .venv/bin/activate && \
	export WOPEE_DRIVER_LIBRARY=SeleniumLibrary && \
	export WOPEE_TRACKED_KEYWORDS="SeleniumLibrary.Click Link;SeleniumLibrary.Click Button;BuiltIn.Log;" && \
	python -m robot -d reports --listener 'wopee_rf.Listener:dot_env_path=.env' tests/selenium_listener.robot


test.browser.listener:
	source .venv/bin/activate && \
	export WOPEE_DRIVER_LIBRARY=BrowserLibrary && \
	export WOPEE_TRACKED_KEYWORDS="Browser.Click;BuiltIn.Log;" && \
	python -m robot -d reports --listener 'wopee_rf.Listener:dot_env_path=.env' tests/browser_listener.robot

clean:
	rm -rf reports/
	rm -rf screenshots/