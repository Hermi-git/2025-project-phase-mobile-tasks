##  Project Architecture

This app is built using **Clean Architecture** to maintain a well-organized and scalable codebase. The structure separates concerns into the following layers:

- `core/` – Shared utilities, error handling, and base classes used across features.
- `features/` – Each feature is isolated in its own module.
  - `domain/` – Contains business logic: entities and use cases.
  - `data/` – Contains models, data sources, and repository implementations.
  - `presentation/` – Contains UI and state management.
##  Data Flow

1. **UI (Presentation Layer)** → Triggers actions and uses **UseCases**.
2. **Domain Layer** → Defines business rules via abstract repository contracts.
3. **Data Layer** → Implements those contracts, communicates with APIs/local DBs.
   - Converts raw data (usually JSON) into **Models**
   - Models extend **Entities** and add JSON conversion logic.
##  Testing

- **Unit tests** are written for models like `ProductModel` to ensure:
  - Proper JSON deserialization (`fromJson`)
  - Correct serialization (`toJson`)
  - Model compatibility with the domain `Product` entity

- Tests can be run with:
  ```bash
  flutter test
