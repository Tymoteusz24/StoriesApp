//
//  UserProfileSyncService.swift
//  DomainData
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import Foundation
@preconcurrency import SwiftData
import Domain
import Networking

/// Service that orchestrates fetching profiles from remote API and syncing with local SwiftData storage
public final actor UserProfileSyncService: UserProfileSyncServiceProtocol {
    private let remoteRepository: UserProfileRemoteRespository
    private let localRepository: UserProfileLocalRepository
    
    /// Initialize sync service with API client and model context
    /// - Parameters:
    ///   - apiClient: API client for remote requests
    ///   - modelContext: SwiftData model context for local storage44
    public init(apiClient: IAPIClientService, modelContext: ModelContext) {
        self.remoteRepository = UserProfileRemoteRespository(apiClient: apiClient)
        self.localRepository = UserProfileLocalRepository(modelContext: modelContext)
    }
    
    /// Fetch profiles from local storage
    /// - Returns: Array of user profiles from local storage
    /// - Throws: Error if fetching from local storage fails
    public func getLocalProfiles() async throws -> [UserProfile] {
        try await localRepository.fetchProfiles()
    }
    
    /// Fetch profiles from remote API and sync to local storage
    /// This method will:
    /// 1. Fetch fresh profiles from the remote API
    /// 2. Save them to local storage (replacing existing profiles)
    /// 3. Return the fetched profiles
    ///
    /// - Returns: Array of user profiles from remote API
    /// - Throws: Error if remote fetch or local save fails
    public func syncProfiles() async throws -> [UserProfile] {
        // Fetch from remote
        let profiles = try await remoteRepository.fetchProfiles()
        
        // Save to local storage
        try await localRepository.saveProfiles(profiles)
        
        return profiles
    }
    
    /// Check if local storage has any profiles
    /// - Returns: True if local storage contains profiles, false otherwise
    /// - Throws: Error if checking local storage fails
    public func hasLocalProfiles() async throws -> Bool {
        try await localRepository.hasProfiles()
    }
    
    /// Clear all profiles from local storage
    /// - Throws: Error if clearing local storage fails
    public func clearLocalProfiles() async throws {
        try await localRepository.deleteAllProfiles()
    }
    
    /// Fetch profiles with automatic fallback strategy:
    /// 1. Try to fetch from remote and sync to local
    /// 2. If remote fails, fallback to local storage
    /// 3. If both fail, throw the remote error
    ///
    /// This is useful for offline-first scenarios where you want to always show data
    /// - Returns: Array of user profiles
    /// - Throws: Error only if both remote and local fetch fail
    public func fetchProfilesWithFallback() async throws -> [UserProfile] {
        do {
            // Try remote first
            return try await syncProfiles()
        } catch {
            // If remote fails, try local
            do {
                let localProfiles = try await getLocalProfiles()
                if !localProfiles.isEmpty {
                    return localProfiles
                }
            } catch {
                // Local also failed, ignore this error and throw remote error
            }
            
            // Both failed, throw remote error
            throw error
        }
    }
}

