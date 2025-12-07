*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    OperatingSystem
# Browser library is optional, only needed if capturing screenshots
Library    Browser    timeout=10s    run_on_failure=None

*** Variables ***
${WOPEE_API_URL}    %{WOPEE_API_URL=https://api.wopee.io/}
${WOPEE_PROJECT_UUID}    %{WOPEE_PROJECT_UUID=}
${WOPEE_API_KEY}    %{WOPEE_API_KEY=}

*** Keywords ***
Create Wopee Session
    [Documentation]    Creates a session for Wopee.io API calls
    Run Keyword If    '${WOPEE_API_KEY}' == ''    Fail    WOPEE_API_KEY environment variable is not set
    Run Keyword If    '${WOPEE_PROJECT_UUID}' == ''    Fail    WOPEE_PROJECT_UUID environment variable is not set
    ${headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    api_key=${WOPEE_API_KEY}
    Create Session    wopee    ${WOPEE_API_URL}    headers=${headers}    verify=True

Create Suite
    [Documentation]    Creates a new integration suite in Wopee.io
    [Arguments]    ${suite_name}    ${branch_name}=${None}
    ${query}=    Set Variable    mutation CreateIntegrationSuite($projectUuid: ID!, $name: String!, $suiteIntegrationConfig: SuiteConfigInput) { createIntegrationSuite(projectUuid: $projectUuid, name: $name, suiteIntegrationConfig: $suiteIntegrationConfig) { name uuid } }
    ${variables}=    Create Dictionary
    ...    projectUuid=${WOPEE_PROJECT_UUID}
    ...    name=${suite_name}
    ${config}=    Create Dictionary    branchName=${branch_name}
    Set To Dictionary    ${variables}    suiteIntegrationConfig=${config}
    ${body}=    Create Dictionary    query=${query}    variables=${variables}
    ${response}=    POST On Session    wopee    /    json=${body}    expected_status=any
    Run Keyword If    ${response.status_code} != 200    Fail    CreateIntegrationSuite failed: ${response.status_code} ${response.text}
    ${json}=    Set Variable    ${response.json()}
    ${errors}=    Get From Dictionary    ${json}    errors    default=${None}
    Run Keyword If    $errors is not None    Fail    GraphQL Error: ${errors}
    RETURN    ${json}[data][createIntegrationSuite][uuid]

Create Scenario
    [Documentation]    Creates a new integration scenario in a suite
    [Arguments]    ${suite_uuid}    ${scenario_name}
    ${query}=    Set Variable    mutation CreateIntegrationScenario($projectUuid: ID!, $suiteUuid: ID!, $name: String) { createIntegrationScenario(projectUuid: $projectUuid, suiteUuid: $suiteUuid, name: $name) { uuid name integrationRunningStatus } }
    ${variables}=    Create Dictionary
    ...    projectUuid=${WOPEE_PROJECT_UUID}
    ...    suiteUuid=${suite_uuid}
    ...    name=${scenario_name}
    ${body}=    Create Dictionary    query=${query}    variables=${variables}
    ${response}=    POST On Session    wopee    /    json=${body}    expected_status=any
    Run Keyword If    ${response.status_code} != 200    Fail    CreateIntegrationScenario failed: ${response.status_code} ${response.text}
    ${json}=    Set Variable    ${response.json()}
    ${errors}=    Get From Dictionary    ${json}    errors    default=${None}
    Run Keyword If    $errors is not None    Fail    GraphQL Error: ${errors}
    RETURN    ${json}[data][createIntegrationScenario][uuid]

Create Step
    [Documentation]    Creates a new integration step with image. If image_base64 is not provided, captures a screenshot using Browser library.
    [Arguments]    ${scenario_uuid}    ${step_name}    ${image_base64}=${None}
    
    # If image_base64 is not provided, capture a screenshot
    IF    '${image_base64}' == '${None}'
        ${screenshot_path}=    Take Screenshot    filename=${step_name}    fullPage=True
        ${image_base64}=    Encode Image To Base64    ${screenshot_path}
    END

    ${query}=    Set Variable    mutation CreateIntegrationStep($input: CreateIntegrationStepInput!) { createIntegrationStep(input: $input) { id stepName status } }
    ${input}=    Create Dictionary
    ...    projectUuid=${WOPEE_PROJECT_UUID}
    ...    scenarioUuid=${scenario_uuid}
    ...    stepName=${step_name}
    ...    trackName=${step_name}
    ...    imageBase64=${image_base64}
    ${variables}=    Create Dictionary    input=${input}
    ${body}=    Create Dictionary    query=${query}    variables=${variables}
    ${response}=    POST On Session    wopee    /    json=${body}    expected_status=any
    Run Keyword If    ${response.status_code} != 200    Fail    CreateIntegrationStep failed: ${response.status_code} ${response.text}
    ${json}=    Set Variable    ${response.json()}
    ${errors}=    Get From Dictionary    ${json}    errors    default=${None}
    Run Keyword If    $errors is not None    Fail    GraphQL Error: ${errors}
    RETURN    ${json}

Stop Scenario
    [Documentation]    Stops an integration scenario
    [Arguments]    ${scenario_uuid}
    ${query}=    Set Variable    mutation StopIntegrationScenario($projectUuid: ID!, $scenarioUuid: ID!) { stopIntegrationScenario(projectUuid: $projectUuid, scenarioUuid: $scenarioUuid) { uuid name integrationRunningStatus } }
    ${variables}=    Create Dictionary
    ...    projectUuid=${WOPEE_PROJECT_UUID}
    ...    scenarioUuid=${scenario_uuid}
    ${body}=    Create Dictionary    query=${query}    variables=${variables}
    ${response}=    POST On Session    wopee    /    json=${body}    expected_status=any
    Run Keyword If    ${response.status_code} != 200    Fail    StopIntegrationScenario failed: ${response.status_code} ${response.text}
    ${json}=    Set Variable    ${response.json()}
    ${errors}=    Get From Dictionary    ${json}    errors    default=${None}
    Run Keyword If    $errors is not None    Fail    GraphQL Error: ${errors}
    RETURN    ${json}

Encode Image To Base64
    [Documentation]    Encodes an image file to base64 string
    [Arguments]    ${image_path}
    ${image_content}=    Get Binary File    ${image_path}
    ${base64_string}=    Evaluate    base64.b64encode($image_content).decode('utf-8')    modules=base64
    RETURN    ${base64_string}

AI Visual Assert
    [Documentation]    Performs an AI-based visual assertion.
    ...    Captures a screenshot if image_base64 is not provided.
    ...    Fails if the assertion returns status 'failed'.
    [Arguments]    ${prompt}    ${context}=${None}    ${image_base64}=${None}

    # If image_base64 is not provided, capture a screenshot
    IF    '${image_base64}' == '${None}'
        ${screenshot_path}=    Take Screenshot    filename=ai_assert    fullPage=True
        ${image_base64}=    Encode Image To Base64    ${screenshot_path}
    END

    ${query}=    Set Variable    mutation VisualAssert($input: VisualAssertInput!) { visualAssert(input: $input) { status confidence message } }
    ${input}=    Create Dictionary
    ...    projectUuid=${WOPEE_PROJECT_UUID}
    ...    imageBase64=${image_base64}
    ...    prompt=${prompt}

    IF    '${context}' != '${None}'
        Set To Dictionary    ${input}    context=${context}
    END

    ${variables}=    Create Dictionary    input=${input}
    ${body}=    Create Dictionary    query=${query}    variables=${variables}
    ${response}=    POST On Session    wopee    /    json=${body}    expected_status=any

    Run Keyword If    ${response.status_code} != 200    Fail    VisualAssert request failed: ${response.status_code} ${response.text}

    ${json}=    Set Variable    ${response.json()}
    ${errors}=    Get From Dictionary    ${json}    errors    default=${None}
    Run Keyword If    $errors is not None    Fail    GraphQL Error: ${errors}

    ${result}=    Set Variable    ${json}[data][visualAssert]

    Log    AI Visual Assert Result: ${result}

    Run Keyword If    '${result}[status]' == 'failed'    Fail    AI Visual Assert Failed: ${result}[message] (Confidence: ${result}[confidence])

    RETURN    ${result}
