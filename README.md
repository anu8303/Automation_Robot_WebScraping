An automated solution that demonstrates web scraping and form submission using Robot Framework and SeleniumLibrary.

## Overview

This project automates:
1. **Player Data Scraping** from HoopsHype salaries page
2. **CSV File Generation** with cleaned data
3. **Form Submissions** to a practice website using scraped data

**Key Features**:
- XPath-based web element identification
- Dynamic data cleaning/formatting
- CSV file handling
- Predefined data mapping
- Browser automation with ChromeDriver

## Technologies Used
- **Robot Framework** (Test Automation)
- **SeleniumLibrary** (Browser Automation)
- **ChromeDriver** (v115+) 
- **Python** (3.8+)

## Prerequisites
- Python 3.8+
- Chrome Browser (Latest)
- [ChromeDriver](https://chromedriver.chromium.org/)

## Installation Dependencies
- pip install robotframework-seleniumlibrary
  
## Setup & Execution
- Clone the repository: git clone https://github.com/your-username/web-scraping-robot.git
cd web-scraping-robot
- Run the automation script: robot web_scraping.robot

## File Structure

📂 web-scraping-robot
 ├──  web_scraping.robot    # Main Robot Framework script
 ├──  player_salaries.csv   # CSV file storing scraped data
 ├──  README.md             # Project documentation

