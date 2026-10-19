*** Settings ***
Library     SeleniumLibrary  screenshot_root_directory=reports/screenshots/selenium
Library     wopee_rf.Standalone    dot_env_path=.env

Resource    ../resources/common.robot

Test Teardown  Stop Scenario

*** Test Cases ***
Visual test w. SeleniumLibrary - Viewport
    Open Browser    https://wopee.io    headlesschrome

    Start Suite    suite_name=${SUITE_NAME}
    Start Scenario    scenario_name=${TEST_NAME}

    ${track_result}    Track Viewport    step_name=Track Viewport

Visual test w. SeleniumLibrary - Fullpage
    Open Browser    https://wopee.io    headlesschrome

    Start Suite    suite_name=${SUITE_NAME}
    Start Scenario    scenario_name=${TEST_NAME}

    ${track_result}    Track Fullpage    step_name=Track Fullpage