*** Settings ***
Library     SeleniumLibrary  screenshot_root_directory=reports/screenshots/selenium

Test Setup       Open Application
Test Teardown    Close Application

*** Variables ***
${BROWSER}      headlesschrome
${URL}          %{WOPEE_PROJECT_URL=https://dronjo.wopee.io/}
${PSWD}         admin


*** Test Cases ***
Login - correct
    Click Link    Sign in

    Input Text        name:user        marcel.veselka@tesena.com
    Input Password    name:password    admin
    Click Button      sign in

    Element Should Be Visible    //a[text()="Log out"]

Login - incorrect
    Click Link    Sign in

    Input Text        name:user        marcel.veselka@gmail.com
    Input Password    name:password    admin
    Click Button      sign in

    Element Should Not Be Visible    //a[text()="Log out"]

Gallery page
    Click Link    Gallery

    Title Should Be    Gallery — dronjo | your one stop shop for the best drones

    Page Should Contain Element    css:.gallery img    limit=3

Check out
    Click Link    Buy Now

    Input Password    id:cardNumberFirstFour     123
    Input Password    id:cardNumberSecondFour    456
    Input Password    id:cardNumberThirdFour     789
    Input Password    id:cardNumberLastFour      111

    Input Password    id:cardHolderName    Marcel Wopee
    Input Password    id:expirationDate    12/25
    Input Password    id:cvc               111

    Click Button    Purchase

    Element Should Contain    css:.confirmation    Thank you for your order!


*** Keywords ***
Open Application
    Open Browser       ${URL}    ${BROWSER}
    Set Window Size    1920      1080

Close Application
    Close Browser