//
//  StoriesLocalRepository.swift
//  DomainData
//
//  Created by Tymoteusz Pasieka on 10/24/25.
//

import Foundation
import SwiftData
import Domain

public actor StoriesLocalRepository {
    private let modelContext: ModelContext
    private let mapper: StoryInteractionStorageMapper
    
    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.mapper = StoryInteractionStorageMapper()
    }
    
    // MARK: - Fetch
    
    public func getInteraction(forStoryId storyId: Int) throws -> StoryInteraction? {
        let descriptor = FetchDescriptor<StoryInteractionDBModel>(
            predicate: #Predicate { $0.storyId == storyId }
        )
        
        guard let dbModel = try modelContext.fetch(descriptor).first else {
            return nil
        }
        
        return mapper.toDomain(dbModel)
    }
    
    public func getAllInteractions() throws -> [StoryInteraction] {
        let descriptor = FetchDescriptor<StoryInteractionDBModel>()
        let dbModels = try modelContext.fetch(descriptor)
        return dbModels.map { mapper.toDomain($0) }
    }
    
    // MARK: - Save/Update
    
    public func markAsSeen(storyId: Int) throws {
        if let existing = try getExistingDBModel(storyId: storyId) {
            existing.isSeen = true
            existing.lastSeenAt = Date()
        } else {
            let newInteraction = StoryInteractionDBModel(
                storyId: storyId,
                isSeen: true,
                isLiked: false,
                lastSeenAt: Date()
            )
            modelContext.insert(newInteraction)
        }
        
        try modelContext.save()
    }
    
    public func toggleLike(storyId: Int) throws {
        if let existing = try getExistingDBModel(storyId: storyId) {
            existing.isLiked.toggle()
        } else {
            let newInteraction = StoryInteractionDBModel(
                storyId: storyId,
                isSeen: false,
                isLiked: true,
                lastSeenAt: nil
            )
            modelContext.insert(newInteraction)
        }
        
        try modelContext.save()
    }
    
    public func setLiked(storyId: Int, isLiked: Bool) throws {
        if let existing = try getExistingDBModel(storyId: storyId) {
            existing.isLiked = isLiked
        } else {
            let newInteraction = StoryInteractionDBModel(
                storyId: storyId,
                isSeen: false,
                isLiked: isLiked,
                lastSeenAt: nil
            )
            modelContext.insert(newInteraction)
        }
        
        try modelContext.save()
    }
    
    public func saveInteraction(_ interaction: StoryInteraction) throws {
        if let existing = try getExistingDBModel(storyId: interaction.id) {
            mapper.updateDBModel(existing, with: interaction)
        } else {
            let newDBModel = mapper.toDBModel(interaction)
            modelContext.insert(newDBModel)
        }
        
        try modelContext.save()
    }
    
    // MARK: - Delete
    
    public func deleteInteraction(forStoryId storyId: Int) throws {
        guard let existing = try getExistingDBModel(storyId: storyId) else {
            return
        }
        
        modelContext.delete(existing)
        try modelContext.save()
    }
    
    public func deleteAllInteractions() throws {
        try modelContext.delete(model: StoryInteractionDBModel.self)
        try modelContext.save()
    }
    
    // MARK: - Private Helpers
    
    private func getExistingDBModel(storyId: Int) throws -> StoryInteractionDBModel? {
        let descriptor = FetchDescriptor<StoryInteractionDBModel>(
            predicate: #Predicate { $0.storyId == storyId }
        )
        return try modelContext.fetch(descriptor).first
    }
}

