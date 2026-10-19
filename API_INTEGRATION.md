# Wopee.io API Integration for Robot Framework

This implementation provides Robot Framework keywords for integrating with the Wopee.io Visual Testing API using GraphQL.

For a complete runnable example, see `test-examples/api_integration.robot`.

## Setup

1. Install dependencies:

```bash
pip install -r requirements.txt
```

2. Set required environment variables in `.env` or export them:

```bash
export WOPEE_PROJECT_UUID="your-project-uuid"
export WOPEE_API_KEY="your-api-key"
```

3. (Optional) Install `robotframework-browser` if you want `Create Step` to automatically capture screenshots when no image is provided.

```bash
rfbrowser init
```

## Available Keywords

### Session Management

#### `Create Wopee Session`

Creates an authenticated session for Wopee.io API calls. This should be called in Suite Setup.

**Example:**

```robot
Suite Setup    Create Wopee Session
```

### Suite Management

#### `Create Suite`

Creates a new test suite in Wopee.io.

**Arguments:**

- `suite_name` (required): Name of the suite
- `branch_name` (optional): Git branch name

**Returns:** The UUID of the created suite.

**Example:**

```robot
${suite_uuid}=    Create Suite    My Test Suite    main
```

### Scenario Management

#### `Create Scenario`

Creates a new scenario within a suite.

**Arguments:**

- `suite_uuid` (required): UUID of the parent suite
- `scenario_name` (required): Name of the scenario

**Returns:** The UUID of the created scenario.

**Example:**

```robot
${scenario_uuid}=    Create Scenario    ${suite_uuid}    Login Test
```

#### `Stop Scenario`

Stops a running scenario.

**Arguments:**

- `scenario_uuid` (required): UUID of the scenario

**Example:**

```robot
Stop Scenario    ${scenario_uuid}
```

### Step Management

#### `Create Step`

Creates a new step with a screenshot in a scenario.

**Arguments:**

- `scenario_uuid` (required): UUID of the parent scenario
- `step_name` (required): Name/description of the step
- `image_base64` (optional): Base64-encoded screenshot image. If not provided, the keyword will attempt to capture a full-page screenshot using the `Browser` library (requires `robotframework-browser`).

**Returns:** Response dictionary containing step UUID and status

**Example with automatic screenshot capture:**

```robot
# Ensure Browser library is imported and a page is open
New Page    https://example.com
${response}=    Create Step    ${scenario_uuid}    Homepage Load
```

### Assertions

#### `AI Visual Assert`

Performs an AI-based visual assertion on the current page or provided image.

**Arguments:**

- `prompt` (required): The assertion question (e.g., "Is the login button visible?").
- `context` (optional): Additional context for the AI.
- `image_base64` (optional): Base64-encoded screenshot. If not provided, captures a full-page screenshot using `Browser` library.

**Returns:** Result dictionary with status, message, and confidence. Fails the test if status is 'failed'.

**Example:**

```robot
AI Visual Assert    Is Dron displayed on the page?
```

### Utility Keywords

#### `Encode Image To Base64`

Encodes an image file to base64 string for API submission.

**Arguments:**

- `image_path` (required): Path to the image file

**Returns:** Base64-encoded string

## API Endpoints

All keywords communicate with the Wopee.io GraphQL API at `https://api.wopee.io/` using the following operations:

- **CreateIntegrationSuite**: Create a new test suite
- **CreateIntegrationScenario**: Create a scenario within a suite
- **CreateIntegrationStep**: Add a step with screenshot
- **VisualAssert**: Perform AI visual assertion
- **StopIntegrationScenario**: Stop the scenario

## Authentication

Authentication is handled via the `api_key` header, which is automatically set when calling `Create Wopee Session` using the `WOPEE_API_KEY` environment variable.

## Error Handling

The keywords use `expected_status=any` and check for status 200. If the API returns an error, the test will fail with the response details.
