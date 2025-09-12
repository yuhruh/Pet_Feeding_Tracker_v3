# Pet Feeding Tracker Feature Overview

This document outlines the core features of the Pet Feeding Tracker application, focusing on the relationships between Users, Pets, and Trackers.

## Core Models

The application is built around three primary models: `User`, `Pet`, and `Tracker`.

### User

The `User` model represents an individual account in the application.

- **Purpose:** To manage user authentication, personal information, and serve as the root owner for all associated data.
- **Key Attributes:**
    - `email_address`: For login and communication.
    - `password`: Securely stored for authentication.
    - `timezone`: To personalize the user experience based on their location.
- **Relationships:**
    - A `User` **has many** `Pet`s. When a user is deleted, all of their associated pets are also deleted.
    - A `User` **has many** `Dry_Food` records. When a user is deleted, their dry food inventory is also deleted.

### Pet

The `Pet` model represents a user's pet.

- **Purpose:** To create a profile for each pet, allowing tracking to be associated with the correct animal.
- **Key Attributes:**
    - `petname`: The name of the pet.
- **Relationships:**
    - A `Pet` **belongs to** one `User`.
    - A `Pet` **has many** `Tracker`s. When a pet is deleted, all of its associated feeding records are also deleted.

### Tracker

The `Tracker` model is the core of the application, representing a single feeding event.

- **Purpose:** To log the details of each meal a pet consumes.
- **Key Attributes:**
    - `food_type`: The type of food (e.g., "Dry", "Wet").
    - `brand`: The brand name of the food.
    - `description`: Specific details about the food (e.g., "Chicken & Rice Formula").
    - `amount`: The quantity of food consumed, in grams.
- **Relationships:**
    - A `Tracker` **belongs to** one `Pet`.
    - A `Tracker` can optionally **belong to** a `Dry_Food` record. This is used for inventory management.

## Feature Workflow

1.  **User Registration:** A user creates an account with their email address and a password.
2.  **Pet Creation:** Once logged in, the user can add one or more pets by providing a name for each.
3.  **Feeding Tracker:**
    - The user can create a new tracker entry for any of their pets.
    - They fill in the details of the feeding: food type, brand, description, and the amount fed.
4.  **Dry Food Inventory (Optional):**
    - A user can pre-define a bag of `Dry_Food` with its total weight.
    - When creating a `Tracker` for dry food, they can link it to a specific `Dry_Food` record.
    - The application automatically calculates the remaining amount of food in the bag, the average consumption, and estimates how many days the bag will last. This is handled by an `after_commit` callback in the `Tracker` model that calls `update_dry_food_used_amount`.

This structure allows a user to maintain detailed feeding logs for multiple pets and manage their dry food inventory efficiently.
