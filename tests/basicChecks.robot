*** Keywords ***
printMessage
    [Arguments]    ${arg1}
    Log    ${arg1}

*** Test Cases ***
TC-001: Test 1
    printMessage   Robot container running successfully