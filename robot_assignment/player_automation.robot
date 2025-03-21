*** Settings ***
Documentation    Web scraping and form submission using Robot Framework
Library          SeleniumLibrary   #Browser automation
Library          OperatingSystem   #File operations
Library          String            #String operations
Library          Collections       #List operations

*** Variables ***
${BROWSER}        Chrome
${PLAYER_URL}     https://hoopshype.com/salaries/players/   # Target data source
${FORM_URL}       https://selenium-practice.netlify.app/     # Form submission page
${CSV_PATH}       player_salaries.csv                        # Output file path

# Player data selectors (HoopsHype-specific)

${NAME_XPATH}     //td[@class='name']
${SALARY_XPATH}   //td[@class='hh-salaries-sorted']

# Form field selectors

${NAME_INPUT}     //input[@id='name']
${DOB_INPUT}      //input[@id='date']
${SUBMIT_BUTTON}  //button[@type='submit']

# Predefined Date of Births (DOB)

@{DOB_LIST}       01-Jan-1981    01-Feb-1982    23-Mar-1976    01-Sep-1978    03-Jul-1945

*** Test Cases ***
Scrape Player Data and Submit Form
    [Documentation]    Scrape first 5 players' data, save to CSV, and submit the form
    Open Browser To Player Page  
    ${names}=    Get Player Names
    ${salaries}=    Get Player Salaries
    Create CSV File    ${names}    ${salaries}
    Close Browser

    Open Browser To Form Page   
    Submit Player Data From CSV      # Process CSV and submit forms
    [Teardown]    Close Browser      # Ensure browser closes on completion

*** Keywords ***
Open Browser To Player Page      # Initialize browser for scraping
    Open Browser    ${PLAYER_URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Element Is Visible    ${NAME_XPATH}    10s   # Wait for page to load

Get Player Names    
    ${elements}=    Get WebElements    ${NAME_XPATH}
    ${names}=    Create List
    FOR    ${element}    IN    @{elements}[1:6]     # Skip header row
        ${raw_name}=    Get Text    ${element}
        ${clean_name}=    Strip String    ${raw_name}
        Append To List    ${names}    ${clean_name}
    END
    RETURN    ${names}

Get Player Salaries     
    ${elements}=    Get WebElements    ${SALARY_XPATH}
    ${salaries}=    Create List
    FOR    ${element}    IN    @{elements}[1:6]   # Skip header row
        ${salary}=    Get Text    ${element}
        ${cleaned_salary}=    Remove String    ${salary}    $    ,    spaces=${True}
        Append To List    ${salaries}    ${cleaned_salary}
    END
    RETURN    ${salaries}

Create CSV File
    [Arguments]    ${names}    ${salaries}

    # Initialize CSV with column headers
    Create File    ${CSV_PATH}    Name,Salary\n 

    # Write first 5 players' data to CSV
    FOR    ${index}    IN RANGE    0    5
        ${name}=    Get From List    ${names}    ${index}
        ${salary}=    Get From List    ${salaries}    ${index}
        Append To File    ${CSV_PATH}    ${name},${salary}\n
    END
    Log    CSV file created at ${CSV_PATH}    console=True

Open Browser To Form Page
    Open Browser    ${FORM_URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Element Is Visible    ${NAME_INPUT}    20s   # Wait for form to load

Submit Player Data From CSV
    ${data}=    Get File    ${CSV_PATH}  # Read generated CSV file
    @{rows}=    Split To Lines    ${data}
    Remove From List    ${rows}    0  # Remove header row

    ${index}=    Set Variable    0
    FOR    ${row}    IN    @{rows}
        @{columns}=    Split String    ${row}    ,
        ${player_name}=    Set Variable    ${columns}[0]
        # Get corresponding DOB from predefined list
        ${dob}=    Get From List    ${DOB_LIST}    ${index}

        Input Text    ${NAME_INPUT}    ${player_name}   # Fill form fields
        Input Text    ${DOB_INPUT}    ${dob}            
        Click Button    ${SUBMIT_BUTTON}

        Log    Submitted: ${player_name} with DOB ${dob}    console=True

        ${index}=    Evaluate    ${index} + 1   # Increment DOB index
    END
