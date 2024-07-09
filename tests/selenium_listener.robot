*** Settings ***
Library     SeleniumLibrary
Library     wopee_rf.Listener


*** Test Cases ***
Test Browser Framework SeleniumLibrary Fullpage Using Listener
    Open Browser    https://wopee.io    headlesschrome
    Log    test