//
//  UserProfileService.swift
//  Domain
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import Foundation

/// Protocol for fetching user profiles
/// This abstraction lives in the Domain layer following Clean Architecture principles
public protocol UserProfileServiceProtocol: Actor {
    /// Fetch profiles from remote source
    func fetchProfiles() async throws -> [UserProfile]
}

/// Protocol for managing user profiles with both remote and local operations
public protocol UserProfileSyncServiceProtocol: Actor {
    /// Fetch profiles from local storage
    func getLocalProfiles() async throws -> [UserProfile]
    
    /// Fetch profiles from remote and sync to local storage
    func syncProfiles() async throws -> [UserProfile]
    
    /// Check if local storage has profiles
    func hasLocalProfiles() async throws -> Bool
    
    /// Clear all local profiles
    func clearLocalProfiles() async throws
}

