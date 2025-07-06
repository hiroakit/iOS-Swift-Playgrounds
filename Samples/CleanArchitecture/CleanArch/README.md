# CleanArch - Clean Architecture iOS Sample

This project demonstrates a Clean Architecture implementation in iOS using Swift and SwiftUI. It follows the principles of Clean Architecture as defined by Robert C. Martin (Uncle Bob) with clear separation of concerns and dependency inversion.

## 🏗️ Architecture Overview

The project is organized into four main layers following Clean Architecture principles:

### 1. Enterprise Business Rules (Entities)
- **Location**: `EnterpriseBusinessRules/`
- **Purpose**: Contains the core business entities and rules that are independent of any external concerns
- **Components**:
  - `Entities/User.swift` - Core User entity
  - `Repositories/UserRepository.swift` - Repository interfaces

### 2. Application Business Rules (Use Cases)
- **Location**: `ApplicationBusinessRules/`
- **Purpose**: Contains application-specific business rules and use cases
- **Components**:
  - `UseCases/FetchUserUseCase.swift` - Use case interface
  - `UseCases/FetchUserUseCaseImpl.swift` - Use case implementation

### 3. Interface Adapters
- **Location**: `InterfaceAdapters/`
- **Purpose**: Contains adapters that convert data between use cases and external agencies
- **Components**:
  - `Gateways/UserRepositoryImpl.swift` - Repository implementation
  - `Provider/DataStoreProvider.swift` - Data store provider

### 4. Frameworks and Drivers
- **Location**: `FrameworksAndDrivers/`
- **Purpose**: Contains frameworks, tools, and delivery mechanisms
- **Components**:
  - `App/CleanArchApp.swift` - Main app entry point
  - `SwiftUI/` - UI components (ContentView, UserDetailView)
  - `DataStore/` - Data persistence layer
    - `GRDB/` - SQLite implementation using GRDB
    - `Realm/` - Realm database implementation
    - `DatabaseProviderFactory.swift` - Factory for creating database providers
    - `EncryptionKeyProvider.swift` - Encryption key management

## 🚀 Features

- **Clean Architecture**: Strict separation of concerns with dependency inversion
- **Multiple Data Sources**: Support for both SQLite (GRDB) and Realm databases
- **Dependency Injection**: Factory pattern for database provider selection
- **SwiftUI**: Modern declarative UI framework
- **Encryption**: Secure key management for sensitive data
- **Testing**: Comprehensive unit tests for all layers

## 📁 Project Structure

```
CleanArch/
├── EnterpriseBusinessRules/
│   ├── Entities/
│   │   └── User.swift
│   └── Repositories/
│       └── UserRepository.swift
├── ApplicationBusinessRules/
│   └── UseCases/
│       ├── FetchUserUseCase.swift
│       └── FetchUserUseCaseImpl.swift
├── InterfaceAdapters/
│   ├── Gateways/
│   │   └── UserRepositoryImpl.swift
│   └── Provider/
│       └── DataStoreProvider.swift
└── FrameworksAndDrivers/
    ├── App/
    │   └── CleanArchApp.swift
    ├── SwiftUI/
    │   ├── ContentView.swift
    │   └── UserDetailView.swift
    ├── DataStore/
    │   ├── GRDB/
    │   │   ├── SQLiteProvider.swift
    │   │   ├── SQLiteSchemaMigrator.swift
    │   │   └── UserGRDBRow.swift
    │   ├── Realm/
    │   │   ├── RealmProvider.swift
    │   │   └── UserRealmObject.swift
    │   ├── DatabaseProviderFactory.swift
    │   └── EncryptionKeyProvider.swift
    └── Resources/
        └── Assets.xcassets/
```

## 🛠️ Setup and Installation

1. **Prerequisites**:
   - Xcode 16.4 or later
   - iOS 18.5 or later
   - Swift 6 or later

2. **Dependencies**:
   - GRDB v7 (for SQLite operations)
   - Realm v20 (for Realm database operations)

3. **Build and Run**:
   ```bash
   # Open the project in Xcode
   open CleanArch.xcodeproj
   
   # Or use xcodebuild
   xcodebuild -project CleanArch.xcodeproj -scheme CleanArch -destination 'platform=iOS Simulator,name=iPhone 16'
   ```

## 🧪 Testing

The project includes comprehensive unit tests for all layers:

```bash
# Run all tests
xcodebuild test -project CleanArch.xcodeproj -scheme CleanArch -destination 'platform=iOS Simulator,name=iPhone 16'
```

### Test Structure:
- `DataStoreProviderFactoryTests.swift` - Tests for database provider factory
- `EncryptionKeyProviderTests.swift` - Tests for encryption key management
- `FetchUserUseCaseTests.swift` - Tests for use case implementation
- `RealmProviderTests.swift` - Tests for Realm database operations
- `SQLiteProviderTests.swift` - Tests for SQLite database operations
- `UserRepositoryTests.swift` - Tests for repository implementation

## 🔄 Data Flow

1. **UI Layer** (`SwiftUI/`) triggers a use case
2. **Use Case** (`ApplicationBusinessRules/`) orchestrates the business logic
3. **Repository** (`InterfaceAdapters/`) handles data operations
4. **Data Store** (`FrameworksAndDrivers/DataStore/`) persists data using the selected database

## 🗄️ Database Support

The project supports multiple database providers:

### SQLite (GRDB)
- Located in `FrameworksAndDrivers/DataStore/GRDB/`
- Provides SQLite database operations
- Includes schema migration support

### Realm
- Located in `FrameworksAndDrivers/DataStore/Realm/`
- Provides Realm database operations
- Object-oriented database approach

## 🔐 Security

- `EncryptionKeyProvider.swift` handles secure key management
- Supports encryption for sensitive data storage
- Follows iOS security best practices

## 📱 UI Components

- `ContentView.swift` - Main app interface
- `UserDetailView.swift` - User details display
- Built with SwiftUI for modern, declarative UI

## 📄 License

This project is part of the iOS Swift Playgrounds collection. See the main LICENSE file for details.

---

**Note**: This is a sample implementation demonstrating Clean Architecture principles in iOS. It's designed for educational purposes and can be used as a reference for implementing Clean Architecture in your own projects. 