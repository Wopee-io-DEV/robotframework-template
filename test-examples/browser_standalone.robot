*** Settings ***
Library     Browser
Library     wopee_rf.Standalone    dot_env_path=.env

Resource    ../resources/common.robot

Test Teardown  Stop Scenario

*** Test Cases ***
Visual test w. Browser Library Viewport
    New Page        https://wopee.io

    Start Suite    suite_name=${SUITE_NAME}
    Start Scenario    scenario_name=${TEST_NAME}

    ${track_result}    Track Viewport    step_name=Track Viewport

    Stop Scenario

Visual test w. Browser Library Fullpage
    New Page        https://wopee.io

    Start Suite    suite_name=${SUITE_NAME}
    Start Scenario    scenario_name=${TEST_NAME}

    ${track_result}    Track Fullpage    step_name=Track Fullpage

    Stop Scenario