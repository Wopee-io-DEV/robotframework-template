*** Settings ***
Library         Browser
Library         wopee_rf.Standalone    dot_env_path=.env
Resource        ../resources/wopee.resource
Variables       ../resources/wopee_env.py

Test Setup      Start Wopee Scenario
Test Teardown   Stop Scenario


*** Test Cases ***
Home page
    # WOPEE_PROJECT_URL is your App URL (in .env)
    New Page          ${WOPEE_PROJECT_URL}
    Page Ready
    Track Fullpage    step_name=Home page

    # Add a check after an interaction:
    # Click             text=Contact
    # Page Ready
    # Track Fullpage    step_name=Contact page


*** Keywords ***
Start Wopee Scenario
    Start Suite       suite_name=${WOPEE_SUITE_NAME}
    Start Scenario    scenario_name=${TEST NAME}
