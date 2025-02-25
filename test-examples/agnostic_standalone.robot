*** Settings ***
Library     SeleniumLibrary
Library     wopee_rf.Standalone    dot_env_path=.env


*** Test Cases ***
Test Browser Framework Agnostic Track
    Open Browser    https://wopee.io    headlesschrome
    Set Screenshot Directory    screenshots/selenium

    Start Suite    suite_name=${SUITE_NAME}
    Start Scenario    scenario_name=${TEST_NAME}

    ${image_path}    Capture Page Screenshot
    ${image_base64}    Convert Image to Base64    ${image_path}

    ${track_result}    Track
    ...    image_base64=${image_base64}
    ...    step_name=Track

    Stop Scenario


*** Keywords ***
Convert Image to Base64
    [Arguments]    ${image_path}
    ${image_base64}    Evaluate
    ...    sys.modules['base64'].b64encode(open(r"${image_path}", 'rb').read()).decode('utf-8')
    ...    base64
    RETURN    ${image_base64}