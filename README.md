````md
# SAP RAP Travel Booking Management System

A cloud-ready Travel Booking Management application developed using SAP ABAP Cloud and the RESTful ABAP Programming Model (RAP). The application enables users to create and manage travel plans, maintain booking details, validate business rules, and process travel workflows through a Fiori Elements user interface.

---

## Project Overview

This project was built using modern SAP ABAP Cloud development practices following SAP Clean Core principles. It demonstrates end-to-end RAP development including CDS View Entities, Behavior Definitions, Behavior Implementations, OData V4 service exposure, and Fiori Elements UI integration.

The application allows users to:

- Create and manage travel plans
- Maintain booking information
- Perform status-based travel actions
- Validate business rules
- View travel and booking details in a Fiori UI

---

## Technologies Used

- SAP ABAP Cloud
- RAP (RESTful ABAP Programming Model)
- CDS View Entities
- Behavior Definitions & Implementations
- OData V4
- SAP BTP ABAP Environment
- Fiori Elements
- Eclipse ADT

---

## Features

### Travel Management
- Create, Update and Delete Travel Plans
- Customer Information Management
- Travel Purpose Management
- Source and Destination Tracking
- Automatic Initial Status Determination

### Booking Management
- Create and Delete Bookings
- Passenger Information Management
- Flight Name and Seat Number Management
- Flight Date Validation

### Business Validations
- Start Date cannot be in the past
- End Date must be greater than Start Date
- Source City and Destination City cannot be identical
- Passenger Name cannot be empty
- Customer Name cannot be empty
- Flight Date must fall within Travel Dates

### Custom Actions
- Accept Travel
- Reject Travel
- Cancel Travel

### UI Enhancements
- Fiori Elements List Report
- Fiori Object Page
- Booking Facet Integration
- Status Criticality with Color Indicators
- Responsive UI using Metadata Extensions

---

## RAP Architecture

```text
Travel
│
├── Travel Details
│
└── Booking
    ├── Passenger Name
    ├── Flight Name
    ├── Seat Number
    └── Flight Date
````

---

## Project Structure

```text
cds/          -> CDS View Entities
behavior/     -> BDEF and Behavior Implementation
service/      -> Service Definition and Binding
metadata/     -> Metadata Extensions
screenshots/  -> Application Screenshots
```

---

## Key RAP Concepts Implemented

* Managed Business Objects
* Composition Relationship
* Determinations
* Validations
* Custom Actions
* Metadata Extensions
* Fiori Elements Integration
* OData V4 Service Exposure

---

## Screenshots

### Travel List Report

<img width="1899" height="875" alt="image" src="https://github.com/user-attachments/assets/40cd5c35-3b29-4d1e-a2e8-4bdc2916e7af" />


### Travel Object Page

<img width="1901" height="870" alt="image" src="https://github.com/user-attachments/assets/f2aa94a0-9480-4547-895d-3adf0af7ff81" />


### Booking Object Page

<img width="1881" height="673" alt="image" src="https://github.com/user-attachments/assets/ff1b4f27-2d17-463e-8ab2-32cf952d53cf" />


### Validation Example

<img width="1896" height="880" alt="image" src="https://github.com/user-attachments/assets/84fb17b0-0030-4534-a870-64c27423c318" />



---

## Author

Vasudeva Reddy Kondreddy

SAP Certified Associate – Back-End Developer (ABAP Cloud)

```
```
