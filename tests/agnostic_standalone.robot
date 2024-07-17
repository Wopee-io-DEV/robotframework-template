*** Settings ***
Library     SeleniumLibrary  screenshot_root_directory=reports/screenshots/selenium
Library     wopee_rf.Wopee    dot_env_path=.env


*** Test Cases ***
Test Browser Framework Agnostic Track
    Open Browser    https://wopee.io    headlesschrome
    Set Screenshot Directory    screenshots/selenium

    ${timestamp}    Generate Timestamp

    Start Suite    suite_name=Suite name-${timestamp}
    Start Scenario    scenario_name=Scenario name-${timestamp}

    ${image_path}    Capture Page Screenshot
    ${image_base64}    Convert Image to Base64    ${image_path}

    &{payload}    Create Dictionary    image_base64=${image_base64}    step_name=Step name-${timestamp}
    ${track_result}    Track    payload=&{payload}

    Stop Scenario


*** Keywords ***
Convert Image to Base64
    [Arguments]    ${image_path}
    ${image_base64}    Evaluate
    ...    sys.modules['base64'].b64encode(open(r"${image_path}", 'rb').read()).decode('utf-8')
    ...    base64
    RETURN    ${image_base64}

Generate Timestamp
    ${timestamp}    Evaluate    int(datetime.datetime.now().timestamp())    datetime
    RETURN    ${timestamp}