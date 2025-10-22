# Usage Examples

## Integration with your App

### 1. Add Domain Package Dependency

In your main app's project, the Domain package is already linked via `TheDatingApp.xcodeproj`.

### 2. Basic Usage - Fetching Profiles

```swift
import SwiftUI
import Domain
import DomainData
import Networking
import Logger

@MainActor
class ProfilesViewModel: ObservableObject {
    @Published var profiles: [UserProfile] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let service: UserProfileServiceProtocol
    
    init(service: UserProfileServiceProtocol) {
        self.service = service
    }
    
    func loadProfiles() async {
        isLoading = true
        error = nil
        
        do {
            profiles = try await service.fetchProfiles()
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
}

// View
struct ProfilesListView: View {
    @StateObject private var viewModel: ProfilesViewModel
    
    init(service: UserProfileServiceProtocol) {
        _viewModel = StateObject(wrappedValue: ProfilesViewModel(service: service))
    }
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading profiles...")
                } else if let error = viewModel.error {
                    ErrorView(error: error) {
                        Task {
                            await viewModel.loadProfiles()
                        }
                    }
                } else {
                    List(viewModel.profiles) { profile in
                        ProfileRow(profile: profile)
                    }
                }
            }
            .navigationTitle("Profiles")
            .task {
                await viewModel.loadProfiles()
            }
        }
    }
}

struct ProfileRow: View {
    let profile: UserProfile
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: profile.profileImageURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray
            }
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(profile.name)
                        .font(.headline)
                    Text("\\(profile.age)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Text(profile.location)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(profile.bio)
                    .font(.caption)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }
}

struct ErrorView: View {
    let error: Error
    let retry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text("Oops!")
                .font(.title2)
                .bold()
            
            Text(error.localizedDescription)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Button("Try Again", action: retry)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
```

### 3. Dependency Injection Setup

```swift
import SwiftUI
import Domain
import DomainData
import DomainDataMock
import Networking
import Logger

@main
struct TheDatingAppApp: App {
    // Choose between real and mock service
    #if DEBUG
    private let useMockData = true
    #else
    private let useMockData = false
    #endif
    
    private var profileService: UserProfileServiceProtocol {
        if useMockData {
            return MockUserProfileService.preview
        } else {
            let logger = NoLogger(label: "TheDatingApp")
            let apiClient = APIClientService(
                logger: logger,
                configuration: .default
            )
            return UserProfileService(apiClient: apiClient)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ProfilesListView(service: profileService)
        }
    }
}
```

### 4. SwiftUI Previews with Mock Data

```swift
#Preview("Profiles List") {
    ProfilesListView(service: MockUserProfileService.preview)
}

#Preview("Loading State") {
    ProfilesListView(service: MockUserProfileService(delay: 10))
}

#Preview("Error State") {
    ProfilesListView(service: MockUserProfileService(shouldFail: true))
}

#Preview("Single Profile") {
    ProfileRow(profile: .mock)
}
```

### 5. Unit Testing

```swift
import XCTest
@testable import YourApp
@testable import Domain
@testable import DomainDataMock

final class ProfilesViewModelTests: XCTestCase {
    
    @MainActor
    func testLoadProfilesSuccess() async {
        let mockService = MockUserProfileService(delay: 0)
        let viewModel = ProfilesViewModel(service: mockService)
        
        await viewModel.loadProfiles()
        
        XCTAssertFalse(viewModel.profiles.isEmpty)
        XCTAssertNil(viewModel.error)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    @MainActor
    func testLoadProfilesFailure() async {
        let mockService = MockUserProfileService(shouldFail: true, delay: 0)
        let viewModel = ProfilesViewModel(service: mockService)
        
        await viewModel.loadProfiles()
        
        XCTAssertTrue(viewModel.profiles.isEmpty)
        XCTAssertNotNil(viewModel.error)
        XCTAssertFalse(viewModel.isLoading)
    }
}
```

## API Reference

### Service Protocol

```swift
protocol UserProfileServiceProtocol: Sendable {
    func fetchProfiles() async throws -> [UserProfile]
}
```

### Real Implementation

```swift
let service = UserProfileService(apiClient: apiClient)
let profiles = try await service.fetchProfiles()
```

### Mock Implementation

```swift
// Instant response
let mockService = MockUserProfileService(delay: 0)

// With network delay simulation
let mockService = MockUserProfileService(delay: 1.5)

// Force error
let mockService = MockUserProfileService(shouldFail: true)
```

## Models

### UserProfile (Domain Model)

```swift
struct UserProfile: Identifiable, Sendable {
    let id: Int              // User ID
    let name: String         // Display name
    let age: Int             // Age
    let location: String     // Location (city, state/country)
    let bio: String          // About me text
    let profileImageURL: URL? // Profile picture URL
}
```

### Available Mock Data

- `UserProfile.mock` - Single mock profile
- `UserProfile.mockList` - Array of 2 mock profiles
- JSON file with 10 profiles in `DomainDataMock/Resources/sample_profiles.json`

## Tips

1. **Use mock data during development** - Faster iteration, no network required
2. **Test both success and failure states** - Use `shouldFail: true` parameter
3. **Simulate network delays** - Use `delay` parameter for realistic UX
4. **Dependency injection** - Pass service through initializer for testability
5. **SwiftUI previews** - Use `MockUserProfileService.preview` for instant results

