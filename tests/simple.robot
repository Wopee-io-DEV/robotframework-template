*** Settings ***
Library     Browser
Library     wopee_rf.Standalone    dot_env_path=.env

Resource    ../resources/common.robot


*** Test Cases ***
Visual test w. Browser Library Viewport
    New Page        https://dronjo.wopee.io

    ${timestamp}    Generate Timestamp

    Start Suite    suite_name=Suite name-${timestamp}
    Start Scenario    scenario_name=Simple test

    ${track_result}    Track Fullpage    step_name=Landing page

    Stop Scenario