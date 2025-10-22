//
//  MockUserProfileSyncService.swift
//  DomainDataMock
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import Foundation
import Domain

/// Mock implementation of UserProfileSyncServiceProtocol for testing and previews
public actor MockUserProfileSyncService: UserProfileSyncServiceProtocol {
    
    // MARK: - Configuration
    
    /// Profiles to return from sync/local operations
    public var mockProfiles: [UserProfile]
    
    /// Simulates network delay in milliseconds
    public var networkDelay: UInt64
    
    /// If true, sync operations will throw an error
    public var shouldThrowErrorOnSync: Bool
    
    /// If true, local operations will throw an error
    public var shouldThrowErrorOnLocal: Bool
    
    /// Error to throw when simulating failures
    public var errorToThrow: Error
    
    // MARK: - State Tracking (useful for testing)
    
    /// Number of times syncProfiles was called
    public private(set) var syncCallCount: Int = 0
    
    /// Number of times getLocalProfiles was called
    public private(set) var localCallCount: Int = 0
    
    /// Number of times clearLocalProfiles was called
    public private(set) var clearCallCount: Int = 0
    
    /// Whether hasLocalProfiles should return true
    public var hasLocalData: Bool
    
    // MARK: - Initialization
    
    public init(
        mockProfiles: [UserProfile] = UserProfile.mockList,
        networkDelay: UInt64 = 0,
        shouldThrowErrorOnSync: Bool = false,
        shouldThrowErrorOnLocal: Bool = false,
        hasLocalData: Bool = true,
        errorToThrow: Error = MockError.syncFailed
    ) {
        self.mockProfiles = mockProfiles
        self.networkDelay = networkDelay
        self.shouldThrowErrorOnSync = shouldThrowErrorOnSync
        self.shouldThrowErrorOnLocal = shouldThrowErrorOnLocal
        self.hasLocalData = hasLocalData
        self.errorToThrow = errorToThrow
    }
    
    // MARK: - UserProfileSyncServiceProtocol
    
    public func getLocalProfiles() async throws -> [UserProfile] {
        localCallCount += 1
        
        if shouldThrowErrorOnLocal {
            throw errorToThrow
        }
        
        // Simulate slight delay for realism
        if networkDelay > 0 {
            try await Task.sleep(nanoseconds: networkDelay * 1_000_000)
        }
        
        return hasLocalData ? mockProfiles : []
    }
    
    public func syncProfiles() async throws -> [UserProfile] {
        syncCallCount += 1
        
        if shouldThrowErrorOnSync {
            throw errorToThrow
        }
        
        // Simulate network delay
        if networkDelay > 0 {
            try await Task.sleep(nanoseconds: networkDelay * 1_000_000)
        }
        
        // After sync, we have local data
        hasLocalData = true
        
        return mockProfiles
    }
    
    public func hasLocalProfiles() async throws -> Bool {
        if shouldThrowErrorOnLocal {
            throw errorToThrow
        }
        
        return hasLocalData && !mockProfiles.isEmpty
    }
    
    public func clearLocalProfiles() async throws {
        clearCallCount += 1
        
        if shouldThrowErrorOnLocal {
            throw errorToThrow
        }
        
        hasLocalData = false
    }
    
    // MARK: - Test Helpers
    
    /// Reset all call counters
    public func resetCounters() {
        syncCallCount = 0
        localCallCount = 0
        clearCallCount = 0
    }
    
    /// Configure for offline scenario (has local data, sync fails)
    public func configureForOffline() {
        hasLocalData = true
        shouldThrowErrorOnSync = true
        shouldThrowErrorOnLocal = false
    }
    
    /// Configure for online scenario (sync succeeds)
    public func configureForOnline() {
        shouldThrowErrorOnSync = false
        shouldThrowErrorOnLocal = false
    }
    
    /// Configure for no cache scenario
    public func configureForNoCache() {
        hasLocalData = false
        mockProfiles = []
    }
}

// MARK: - Mock Error

public enum MockError: Error, LocalizedError {
    case syncFailed
    case localFetchFailed
    case networkUnavailable
    case noDataAvailable
    
    public var errorDescription: String? {
        switch self {
        case .syncFailed:
            return "Failed to sync profiles from remote"
        case .localFetchFailed:
            return "Failed to fetch profiles from local storage"
        case .networkUnavailable:
            return "Network is unavailable"
        case .noDataAvailable:
            return "No profile data available"
        }
    }
}

// MARK: - Convenience Extensions for Previews

#if DEBUG
extension MockUserProfileSyncService {
    /// Quick mock with default data for previews
    public static var preview: MockUserProfileSyncService {
        MockUserProfileSyncService(
            mockProfiles: UserProfile.mockList,
            networkDelay: 0,
            shouldThrowErrorOnSync: false,
            shouldThrowErrorOnLocal: false,
            hasLocalData: true
        )
    }
    
    /// Mock simulating slow network
    public static var previewSlowNetwork: MockUserProfileSyncService {
        MockUserProfileSyncService(
            mockProfiles: UserProfile.mockList,
            networkDelay: 2000, // 2 seconds
            shouldThrowErrorOnSync: false,
            shouldThrowErrorOnLocal: false,
            hasLocalData: false
        )
    }
    
    /// Mock simulating offline mode (has cached data)
    public static var previewOffline: MockUserProfileSyncService {
        MockUserProfileSyncService(
            mockProfiles: UserProfile.mockList,
            networkDelay: 0,
            shouldThrowErrorOnSync: true,
            shouldThrowErrorOnLocal: false,
            hasLocalData: true,
            errorToThrow: MockError.networkUnavailable
        )
    }
    
    /// Mock simulating error state (no cache, sync fails)
    public static var previewError: MockUserProfileSyncService {
        MockUserProfileSyncService(
            mockProfiles: [],
            networkDelay: 0,
            shouldThrowErrorOnSync: true,
            shouldThrowErrorOnLocal: true,
            hasLocalData: false,
            errorToThrow: MockError.networkUnavailable
        )
    }
    
    /// Mock with empty data
    public static var previewEmpty: MockUserProfileSyncService {
        MockUserProfileSyncService(
            mockProfiles: [],
            networkDelay: 0,
            shouldThrowErrorOnSync: false,
            shouldThrowErrorOnLocal: false,
            hasLocalData: false
        )
    }
    
    /// Mock with many profiles for testing scrolling
    public static var previewManyProfiles: MockUserProfileSyncService {
        let manyProfiles = (0..<20).map { index in
            UserProfile(
                id: index,
                name: "User \(index)",
                age: 20 + (index % 20),
                location: "City \(index), State",
                bio: "This is user number \(index). Lorem ipsum dolor sit amet.",
                profileImageURL: URL(string: "https://example.com/profile\(index).jpg")
            )
        }
        
        return MockUserProfileSyncService(
            mockProfiles: manyProfiles,
            networkDelay: 0,
            shouldThrowErrorOnSync: false,
            shouldThrowErrorOnLocal: false,
            hasLocalData: true
        )
    }
}
#endif

