*** Settings ***
Library     Browser
Library     wopee_rf.Wopee    dot_env_path=.env

Resource    ../resources/common.robot

Test Teardown  Stop Scenario

*** Test Cases ***
Visual test w. Browser Library Viewport
    New Page        https://wopee.io

    ${timestamp}    Generate Timestamp

    Start Suite    suite_name=Suite name-${timestamp}
    Start Scenario    scenario_name=Scenario name-${timestamp}

    &{payload}    Create Dictionary    step_name=Landing page
    ${track_result}    Track Viewport    payload=&{payload}

Visual test w. Browser Library Fullpage
    New Page        https://wopee.io

    ${timestamp}    Generate Timestamp

    Start Suite    suite_name=Suite name-${timestamp}
    Start Scenario    scenario_name=Scenario name-${timestamp}

    &{payload}    Create Dictionary    step_name=Landing page
    ${track_result}    Track Fullpage    payload=&{payload}
