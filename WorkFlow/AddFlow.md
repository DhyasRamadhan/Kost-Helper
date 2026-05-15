# Additional Feature Proposal — Profile API Integration

## Phase 0.5 — User Profile API Integration

### Purpose

Currently, the frontend profile pages still rely on temporary hardcoded or locally stored user data after login. To support real-time profile synchronization and future profile editing workflows, a dedicated Profile API should be implemented.

This Profile API will allow the frontend to always retrieve the latest authenticated user information directly from the backend database.

---

# Backend Requirements

## Create Profile Endpoint

### Route

GET /api/profile

### Authentication

Protected using Sanctum authentication middleware.

### Response Example

```json
{
  "data": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "08123456789",
    "role": "tenant",
    "verification_status": "approved"
  }
}
```

---

# Backend Controller Logic

The endpoint should:

1. Retrieve the currently authenticated user
2. Return user profile information
3. Be reusable for Owner, Tenant, and Admin roles

Optional future enhancement:

* Include tenant profile relation
* Include owner statistics
* Include profile photo support

---

# Frontend Integration Requirements

## Create Profile Service

The frontend should:

1. Create a ProfileService to call GET /profile
2. Create a ProfileController for state handling
3. Replace all hardcoded profile data in the UI
4. Dynamically display authenticated user information

---

# Affected Views

## Tenant Profile View

Replace temporary hardcoded user data with API response data.

## Owner Profile View

Use the same API endpoint to display owner information.

## Admin Profile View

Use the same API endpoint for admin account information.

---

# Benefits

Implementing a dedicated Profile API provides:

* Real-time user data synchronization
* Cleaner frontend architecture
* Better scalability
* Easier profile editing implementation
* Proper separation between authentication and profile management
* Better support for approval-based profile updates

---

# Future Workflow Compatibility

This feature is important for future workflows such as:

* Tenant profile update approvals
* Profile editing
* Phone number changes
* Address updates
* Profile image uploads
* Session persistence and profile refresh

Without a dedicated Profile API, frontend profile pages may become inconsistent with database changes after approval workflows.
