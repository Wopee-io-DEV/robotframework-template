*** Settings ***
Documentation    Example test demonstrating Wopee.io API integration
Resource    ../resources/api.robot
Library    Browser

Suite Setup    Create Wopee Session
Test Setup    Log    Starting test: ${TEST NAME}

*** Variables ***
${SUITE_NAME}       API Integration Test Suite
${SCENARIO_NAME}    Sample Visual Test Scenario
${BRANCH_NAME}      main

*** Test Cases ***
Complete Visual Testing Workflow
    [Documentation]    Demonstrates a complete workflow: create suite, scenario, add steps, and get results
    
    # Create a new test suite
    ${suite_uuid}=    Create Suite    ${SUITE_NAME}    ${BRANCH_NAME}
    Log               Created suite with UUID: ${suite_uuid}
    
    # Create a scenario in the suite
    ${scenario_uuid}=    Create Scenario    ${suite_uuid}    ${SCENARIO_NAME}
    Log                  Created scenario with UUID: ${scenario_uuid}

    # Open a page to take a screenshot
    New Page    https://dronjo.wopee.io

    # Create a step without providing image_base64 (should capture screenshot automatically)
    Create Step    ${scenario_uuid}    Step 1: Homepage

    # Check if Dron is displayed on the page using AI Visual Assert
    ${response}=    AI Visual Assert    Is Dron displayed on the page?
    ${pretty_json}=    Evaluate    json.dumps($response, indent=4)    modules=json
    Log To Console     ${pretty_json}


    # Stop the scenario
    ${stop_response}=   Stop Scenario    ${scenario_uuid}
    Log                 Scenario stopped
