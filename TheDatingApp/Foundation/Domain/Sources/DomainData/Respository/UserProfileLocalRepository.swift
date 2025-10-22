//
//  UserProfileLocalRepository.swift
//  DomainData
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import Foundation
@preconcurrency import SwiftData
import Domain
import Storage
import SwiftDataStorage

/// Local repository for managing user profiles in SwiftData
public actor UserProfileLocalRepository {
    private let storage: ModelRepository<UserProfileDBModel, UserProfile>
    
    public init(modelContext: ModelContext) {
        let mapper = UserProfileStorageMapper()
        self.storage = ModelRepository(context: modelContext, mapper: mapper)
    }
    
    /// Fetch all profiles from local storage
    public func fetchProfiles() async throws -> [UserProfile] {
        try await storage.getAll()
    }
    
    /// Save profiles to local storage (replaces existing)
    public func saveProfiles(_ profiles: [UserProfile]) async throws {
        // Get all existing profiles
        let existingProfiles = try await storage.getAll()
        
        // Delete existing profiles
        let mapper = UserProfileStorageMapper()
        let dbModels = existingProfiles.map { mapper.mapToDB($0) }
        await storage.deleteEntities(dbModels)
        
        // Insert new profiles
        let newDBModels = profiles.map { mapper.mapToDB($0) }
        await storage.create(newDBModels)
        
        // Save changes
        try await storage.save()
    }
    
    /// Update or insert profiles (upsert operation)
    public func upsertProfiles(_ profiles: [UserProfile]) async throws {
        let mapper = UserProfileStorageMapper()
        let newDBModels = profiles.map { mapper.mapToDB($0) }
        await storage.create(newDBModels)
        try await storage.save()
    }
    
    /// Delete all profiles from local storage
    public func deleteAllProfiles() async throws {
        let existingProfiles = try await storage.getAll()
        let mapper = UserProfileStorageMapper()
        let dbModels = existingProfiles.map { mapper.mapToDB($0) }
        await storage.deleteEntities(dbModels)
        try await storage.save()
    }
    
    /// Check if local storage has any profiles
    public func hasProfiles() async throws -> Bool {
        let profiles = try await storage.getAll()
        return !profiles.isEmpty
    }
}

