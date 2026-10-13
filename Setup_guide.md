# WhatNext Vision Motors

Comprehensive Setup & Implementation Guide

Customer ordering, dealer assignment, stock control and automation on Salesforce


---

1. Project Overview

WhatNext Vision Motors wants to provide a better customer vehicle-ordering experience while reducing manual work.

The Salesforce solution focuses on four major areas:

- Nearest Dealer Assignment: An order is automatically linked to the dealer that matches the customer's location.
- Stock Control: Customers cannot order a vehicle when it is out of stock.
- Scheduled Status Update: Pending orders are automatically changed to Confirmed once stock becomes available.
- Customer Management: Customer, test-drive and service-request information is maintained in Salesforce.

Requirements and Solutions

Requirement	Solution

Store vehicles, stock, dealers and customers	Six custom objects
Assign orders to nearest dealer	Record-Triggered Flow: Auto Assign Dealer
Block orders when vehicle is out of stock	Apex Trigger and Handler Class
Send test-drive reminders	Record-Triggered Flow with Scheduled Path
Periodic stock check and status update	Batch Apex with Scheduled Apex


Skills Covered

- Salesforce Data Modelling
- Custom Objects and Fields
- Object Relationships
- Lightning App Builder
- Record-Triggered Flows
- Apex Triggers
- Apex Handler Classes
- Batch Apex
- Scheduled Apex
- Salesforce Automation


---

2. Milestone 1: Developer Org Setup

Step 1: Create Salesforce Developer Account

1. Open the Salesforce Developer signup page.
2. Enter your first name and last name.
3. Enter your email address.
4. Set Role as Developer.
5. Enter your college name under Company.
6. Select India as the country.
7. Enter the postal code.
8. Create a unique username using email format.
9. Click Sign Me Up.

Step 2: Verify Account

1. Open the verification email.
2. Click Verify Account.
3. Set a password.
4. Set the security question.
5. Click Change Password.
6. You will be redirected to the Salesforce Setup page.


---

3. Milestone 2: Custom Objects and Relationships

The project uses the following custom objects:

Object	Purpose

Vehicle	Stores vehicle details and stock
Dealer	Stores authorized dealer information
Customer	Stores customer information
Vehicle Order	Stores customer vehicle orders
Test Drive	Stores test-drive bookings
Service Request	Stores vehicle service requests


Create a Custom Object

1. Open Setup.
2. Go to Object Manager.
3. Click Create → Custom Object.
4. Enter the object Label.
5. Enter the Plural Label.
6. Set the Record Name.
7. Select the required data type.
8. Enable Allow Reports.
9. Enable Allow Search.
10. Click Save.

Repeat the same process for all six objects.


---

4. Milestone 3: Custom Tabs

1. Go to Setup.
2. Search for Tabs using Quick Find.
3. Under Custom Object Tabs, click New.
4. Select the required custom object.
5. Select a Tab Style.
6. Keep the default settings.
7. Click Save.
8. Repeat the process for all six objects.


---

5. Milestone 4: Lightning Application

App Name

WhatNext Vision Motors

Create Lightning App

1. Go to Setup.
2. Open App Manager.
3. Click New Lightning App.
4. Enter the App Name: WhatNext Vision Motors
5. Add a suitable description.
6. Keep the default colour.
7. Click Next.

Navigation Items

Add:

- Vehicle
- Dealer
- Customer
- Vehicle Order
- Test Drive
- Service Request
- Reports
- Dashboards

Select the required custom objects and click Next.

User Profiles

Add:

- System Administrator

Click Save & Finish.


---

6. Milestone 5: Fields and Relationships

Vehicle

Field	Type

Vehicle Model	Picklist
Stock Quantity	Number
Price	Currency
Dealer	Lookup → Dealer
Status	Picklist


Vehicle Model values:

- Sedan
- SUV
- EV

Status values:

- Available
- Out of Stock
- Discontinued


---

Dealer

Field	Type

Dealer Name	Text
Dealer Location	Text
Dealer Code	Auto Number
Phone	Phone
Email	Email



---

Customer

Field	Type

Customer Name	Text
Email	Email
Phone	Phone
Address	Text
Preferred Vehicle Type	Picklist



---

Vehicle Order

Field	Type

Vehicle Customer	Lookup → Customer
Vehicle	Lookup → Vehicle
Order Date	Date
Status	Picklist


Status values:

- Pending
- Confirmed
- Delivered
- Cancelled


---

Test Drive

Field	Type

Vehicle Customer	Lookup → Customer
Vehicle	Lookup → Vehicle
Test Drive Date	Date
Status	Picklist


Status values:

- Scheduled
- Completed
- Cancelled


---

Service Request

Field	Type

Vehicle Customer	Lookup → Customer
Vehicle	Lookup → Vehicle
Service Date	Date
Issue Description	Text
Status	Picklist


Status values:

- Requested
- In Progress
- Completed


---

7. Creating Fields

1. Go to Setup → Object Manager.
2. Select the required object.
3. Open Fields & Relationships.
4. Click New.
5. Select the field type.
6. Click Next.
7. Enter the field label.
8. For Picklist fields, enter one value per line.
9. For Lookup Relationship fields, select the related object.
10. Click Next → Save.


---

Project Automation Flow

Customer
    ↓
Select Vehicle
    ↓
Check Stock
    ↓
Create Vehicle Order
    ↓
Find Nearest Dealer
    ↓
Assign Dealer
    ↓
Check Availability
    ↓
Pending / Confirmed
    ↓
Customer Notification

Salesforce Technology Stack

Salesforce Developer Org · Custom Objects · Lightning App Builder · Flow Builder · Apex Trigger · Batch Apex · Scheduled Apex
