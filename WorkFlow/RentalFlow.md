# Digital Boarding House Management System Workflow

## 1. User Registration & Authentication

### Owner Registration

1. User registers as an **Owner**
2. System stores owner data in `users` table
3. Owner verification status is automatically set to `pending`
4. Admin reviews owner verification request
5. Admin can:

   * Approve owner account
   * Reject owner account
6. Only approved owners can access owner features

### Tenant Registration

1. User registers as a **Tenant**
2. System stores tenant data in `users` table
3. System automatically creates tenant profile in `tenants` table
4. Tenant account is automatically approved
5. Tenant can immediately login and access tenant features

---

# 2. Owner Room Management Workflow

### Create Room

1. Owner logs into the system
2. Owner opens Room Management page
3. Owner creates room data:

   * Room number
   * Price
   * Room description
   * Room facilities
   * Room status
4. System stores room data linked to owner account
5. Room status defaults to `available`

### Manage Room

Owner can:

* View all owned rooms
* Edit room information
* Delete room
* View room occupancy status

---

# 3. Tenant Room Browsing Workflow

### Browse Available Rooms

1. Tenant logs into the system
2. Tenant opens Available Rooms page
3. System displays all rooms with status `available`
4. Tenant can view:

   * Room information
   * Monthly price
   * Owner information
   * Room facilities
   * Room status

### Room Selection

1. Tenant selects a desired room
2. Tenant opens room detail page
3. Tenant can submit rental application

---

# 4. Rental Application Workflow

## Submit Rental Application

1. Tenant fills rental application form
2. Tenant optionally writes application message
3. System creates rental application record with:

   * Tenant ID
   * Room ID
   * Owner ID
   * Application message
   * Status = `pending`

---

# 5. Owner Rental Approval Workflow

## Review Rental Application

1. Owner opens Rental Application Management page
2. System displays all incoming applications
3. Owner reviews:

   * Tenant profile
   * Selected room
   * Application message

### Owner Decision

Owner can:

* Approve application
* Reject application

---

# 6. Automatic Contract Creation Workflow

## If Application Approved

1. System automatically creates rental contract

2. System stores:

   * Tenant ID
   * Room ID
   * Owner ID
   * Rental period
   * Monthly rent
   * Contract status

3. System automatically updates room status:

   * `available` → `occupied`

4. Tenant now officially rents the room

---

# 7. Payment Workflow

## Generate Payment

1. Owner opens contract detail
2. Owner clicks "Generate Payment"
3. System automatically:

   * Retrieves contract data
   * Retrieves monthly rent
   * Creates payment record
   * Generates Midtrans payment token

## Payment Status

Payment status may become:

* pending
* paid
* failed
* expired
* cancelled

---

# 8. Midtrans Payment Workflow

## Tenant Payment Process

1. Tenant opens payment page
2. Tenant selects pending payment
3. Tenant clicks "Pay Now"
4. System opens Midtrans payment gateway
5. Tenant completes payment

## Midtrans Callback

1. Midtrans sends callback notification
2. System validates transaction
3. System automatically updates payment status

---

# 9. Electricity Usage Workflow

## Owner Electricity Input

1. Owner opens electricity management page
2. Owner inputs:

   * Meter start
   * Meter end
   * Usage date
   * Electricity tariff
3. System calculates:

   * Total kWh usage
   * Estimated electricity bill

## Tenant Electricity Monitoring

Tenant can:

* View electricity usage
* View monthly bill estimation
* Monitor room electricity consumption

---

# 10. Tenant Profile Update Request Workflow

## Submit Update Request

1. Tenant opens profile page

2. Tenant selects "Edit Profile Request"

3. Tenant submits updated information:

   * Phone number
   * Address
   * Emergency contact
   * Other sensitive data

4. System stores update request with status:

   * pending

---

# 11. Owner Approval for Tenant Update

## Review Update Request

1. Owner opens tenant update request page
2. Owner reviews requested changes
3. Owner can:

   * Approve update
   * Reject update

## If Approved

1. System updates tenant profile data
2. Request status changes to `approved`

## If Rejected

1. Tenant data remains unchanged
2. Request status changes to `rejected`

---

# 12. Dashboard Workflow

## Owner Dashboard

Displays:

* Total rooms
* Occupied rooms
* Available rooms
* Total tenants
* Active contracts
* Pending payments
* Total income
* Electricity bill statistics

## Tenant Dashboard

Displays:

* Current room
* Active contract
* Pending payments
* Payment history
* Electricity usage
* Profile information

## Admin Dashboard

Displays:

* Pending owner verification requests
* Owner approval management

---

# 13. Logout Workflow

1. User clicks logout button
2. System removes Sanctum token
3. Session is terminated
4. User is redirected to login page

---

# System Architecture Overview

## Main Roles

* Admin
* Owner
* Tenant

## Main Modules

* Authentication
* Room Management
* Rental Application
* Contract Management
* Payment Management
* Electricity Monitoring
* Tenant Update Approval
* Dashboard Analytics

## External Service

* Midtrans Payment Gateway

---

# Final System Concept

The system is designed as a complete digital boarding house ecosystem where owners can manage rooms, contracts, electricity usage, and payments, while tenants can browse rooms, apply for rentals, monitor bills, and manage profile requests through an approval-based workflow system.
