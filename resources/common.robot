*** Keywords ***
Generate Timestamp
    ${timestamp}    Evaluate    int(datetime.datetime.now().timestamp())    datetime
    RETURN    ${timestamp}