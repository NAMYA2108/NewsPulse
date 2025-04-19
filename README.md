# NewsPulse
Salesforce and Mulesoft application
# Features

- Fetch live news via MuleSoft API callout
- Store and display headlines, snippets, sources, and categories
- Responsive LWC with a “Fetch News” button
- Grouped news display by category
- Publicly accessible without login

## Tech Stack

- Salesforce: Apex, LWC, Experience Cloud
- MuleSoft: CloudHub, API integration
- NewsAPI: External news data source

## Setup Overview

1. Deploy custom object `NewsPulse__c` with custom fields
2. Set up Named Credential to call MuleSoft `/getNews`
3. Use MuleSoft to connect with NewsAPI and return JSON
4. Display data using `newsPulseFeed` LWC in Experience Site

## Code

Source code and deployment scripts available in this repo.
