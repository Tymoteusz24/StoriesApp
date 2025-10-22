# Domain Package

This package contains the domain models, DTOs, and API endpoints for TheDatingApp.

## Structure

```
Domain/
├── Sources/
│   ├── Domain/              # Domain models (business logic)
│   │   ├── UserProfile.swift
│   │   ├── UserProfileService.swift (protocol)
│   │   └── ...
│   ├── DomainData/          # Data layer (API, DTOs, Mappers)
│   │   ├── DTO/
│   │   │   └── UserProfileDTO.swift
│   │   ├── ApiEndpoints/
│   │   │   └── DatingAPIEndpoint.swift
│   │   ├── Mappers/
│   │   │   └── UserProfileMapper.swift
│   │   └── Services/
│   │       └── UserProfileService.swift
│   └── DomainDataMock/      # Mock implementations for testing
│       ├── MockUserProfileService.swift
│       └── Resources/
│           └── sample_profiles.json
└── Tests/
    └── DomainTests/
```

## Usage

### Fetching User Profiles

```swift
import Domain
import DomainData
import Networking

// Create API client
let logger = NoLogger(label: "DatingApp")
let apiClient = APIClientService(logger: logger)

// Create service
let profileService = UserProfileService(apiClient: apiClient)

// Fetch profiles
Task {
    do {
        let profiles = try await profileService.fetchProfiles()
        print("Fetched \(profiles.count) profiles")
        
        for profile in profiles {
            print("\(profile.name), \(profile.age) - \(profile.location)")
        }
    } catch {
        print("Error fetching profiles: \(error)")
    }
}
```

### Using Mock Data (for Previews/Testing)

```swift
import Domain
import DomainDataMock

// For SwiftUI previews
let mockService = MockUserProfileService.preview

// For testing with simulated delay
let mockServiceWithDelay = MockUserProfileService(delay: 1.0)

// For testing error states
let failingMockService = MockUserProfileService(shouldFail: true)

// Use in preview
struct ProfilesView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilesView(service: mockService)
    }
}
```

## API Endpoint

The app fetches user profiles from:
- **URL**: `https://raw.githubusercontent.com/downapp/sample/main/sample.json`
- **Method**: GET
- **Response**: Array of user profiles

### Response Format

```json
[
  {
    "name": "Jessica",
    "user_id": 13620229,
    "age": 25,
    "loc": "Ripon, CA",
    "about_me": "bio text...",
    "profile_pic_url": "https://..."
  }
]
```

## Models

### UserProfile (Domain Model)
- `id: Int` - Unique identifier
- `name: String` - User's display name
- `age: Int` - User's age
- `location: String` - User's location
- `bio: String` - User's bio/about me
- `profileImageURL: URL?` - URL to profile picture

### UserProfileDTO (Data Transfer Object)
- Maps API response fields to domain model
- Uses `CodingKeys` to handle snake_case to camelCase conversion

## Architecture

This package follows Clean Architecture principles:

1. **Domain Layer** (`Domain`) - Business entities, independent of data sources
2. **Data Layer** (`DomainData`) - API implementation, DTOs, Mappers
3. **Mock Layer** (`DomainDataMock`) - Test doubles for development and testing

### Benefits
- ✅ Separation of concerns
- ✅ Testable business logic
- ✅ Easy to mock for UI development
- ✅ API changes isolated to Data layer
- ✅ Type-safe networking with Codable

