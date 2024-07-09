*** Settings ***
Library     SeleniumLibrary
Library     wopee_rf.Wopee    dot_env_path=.env


*** Test Cases ***
Test Browser Framework SeleniumLibrary Viewport
    Open Browser    https://wopee.io    headlesschrome
    Set Screenshot Directory    screenshots/selenium

    ${timestamp}    Generate Timestamp

    Start Suite    suite_name=Suite name-${timestamp}
    Start Scenario    scenario_name=Scenario name-${timestamp}

    &{payload}    Create Dictionary    step_name=Step name-${timestamp}
    ${track_result}    Track Viewport    payload=&{payload}

    Stop Scenario

Test Browser Framework SeleniumLibrary Fullpage
    Open Browser    https://wopee.io    headlesschrome
    Set Screenshot Directory    screenshots/selenium

    ${timestamp}    Generate Timestamp

    Start Suite    suite_name=Suite name-${timestamp}
    Start Scenario    scenario_name=Scenario name-${timestamp}

    &{payload}    Create Dictionary    step_name=Step name-${timestamp}
    ${track_result}    Track Fullpage    payload=&{payload}

    Stop Scenario


*** Keywords ***
Generate Timestamp
    ${timestamp}    Evaluate    int(datetime.datetime.now().timestamp())    datetime
    RETURN    ${timestamp}