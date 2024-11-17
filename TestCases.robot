*** Settings ***
Documentation   Auto1/QA Task
Library         SeleniumLibrary
Library         String
Library         helpers.HelpLib
Library         Collections    
Suite Setup     Open URL Locally
Suite Teardown  Close Browser

*** Variables ***
${CHROME_OPTIONS}    --headless --disable-gpu --disable-notifications --start-maximized

*** Test Cases ***
TC1 - Check Filters on Advanced Search Page
    Given Open URL AutoHero
    And User is on Advanced Search Page
    When User Select Filter for First registration
    And User Select Filter for Price Descending
    Then Verify all cars are filtered by First Registration
    And Verify all Cars are Filtered By Price Descending

*** Keywords ***
Open Tests in Source Labs
    ${desired_capabilities}=    Create Dictionary
    Set to Dictionary    ${desired_capabilities}    build    test_run
    Set to Dictionary    ${desired_capabilities}    platformName    Windows 10
    Set to Dictionary    ${desired_capabilities}    name    Auto1
    Set to Dictionary    ${desired_capabilities}    browserName    chrome

    ${executor}=    Evaluate          str('http://milan.novovic:0f772a45-b623-4d44-a01f-9a1db40f0d5d@ondemand.saucelabs.com:80/wd/hub')
    Create WebDriver    Remote    desired_capabilities=${desired_capabilities}    command_executor=${executor}

Open URL Locally
    # Set up Chrome with options
    Create WebDriver    Chrome    options=${CHROME_OPTIONS}
    Maximize Browser Window

Open URL AutoHero
    Go To    https://www.autohero.com/

User is on Advanced Search Page
    Sleep   5s
    Click Element    //button[contains(text(),'Erweiterte Suche')]
    Wait Until Element Is Visible    //span[contains(text(),'Erstzulassung ab')]

User Select Filter for First registration
    Click Element    //span[contains(text(),'Erstzulassung ab')]
    Wait Until Element Is Visible    //select[@name='yearRange.min']/*[text()='2014']   
    Click Element    //select[@name='yearRange.min']/*[text()='2014']
    Sleep   3s
    Click Element    //a[contains(text(),'Ergebnisse')]

Verify all cars are filtered by First Registration
    Sleep   3s
    @{locators}    Get Webelements    //*[contains(@class,'specItem___')][1]
    @{result}=    Create List
    
    :FOR   ${locator}   IN    @{locators}
        \    ${name}=    Get Text    ${locator}
        \    ${matches}=    Get Regexp Matches    ${name}    \d{4}
        \    Append To List    ${result}    ${matches}
    ${flat}    Evaluate    [item for sublist in ${result} for item in (sublist if isinstance(sublist, list) else [sublist])]
    
    ${numbs}=    Convert To Integer    2014

    :FOR   ${locator}   IN    @{flat}
    \    Log    ${locator}
    \    Run Keyword Unless    ${locator} >= ${numbs}    Pass

User Select Filter for Price Descending
    Wait Until Element Is Visible    //select[contains(@name,'sort')]  
    Click Element    //select[contains(@name,'sort')]
    Sleep   2s
    Click Element    //*[text()='Höchster Preis']

Verify all Cars are Filtered By Price Descending
    Sleep   2s
    @{locators}    Get Webelements    //*[contains(@class,'totalPrice')][1]
    ${priceAll}=    Create List
    :FOR   ${locator}   IN    @{locators}
        \    ${name}=    Get Text    ${locator}
        \    ${matches}=    Get Regexp Matches    ${name}    \d+(\.\d{1,2})?
        \    Append To List    ${priceAll}    ${matches}
    
    ${flat}    Evaluate    [item for sublist in ${priceAll} for item in (sublist if isinstance(sublist, list) else [sublist])]
    ${sortPrices}=    Evaluate    sorted(${flat}, reverse=True)

    Should Be Equal As Strings    ${flat}    ${sortPrices}

    Log    ${sortPrices}
    Log    ${flat}
