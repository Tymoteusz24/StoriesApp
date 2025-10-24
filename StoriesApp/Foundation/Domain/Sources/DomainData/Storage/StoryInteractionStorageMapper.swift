//
//  StoryInteractionStorageMapper.swift
//  DomainData
//
//  Created by Tymoteusz Pasieka on 10/24/25.
//

import Foundation
import Domain

public struct StoryInteractionStorageMapper {
    public init() {}
    
    public func toDomain(_ dbModel: StoryInteractionDBModel) -> StoryInteraction {
        return StoryInteraction(
            id: dbModel.storyId,
            isSeen: dbModel.isSeen,
            isLiked: dbModel.isLiked,
            lastSeenAt: dbModel.lastSeenAt
        )
    }
    
    public func toDBModel(_ interaction: StoryInteraction) -> StoryInteractionDBModel {
        return StoryInteractionDBModel(
            storyId: interaction.id,
            isSeen: interaction.isSeen,
            isLiked: interaction.isLiked,
            lastSeenAt: interaction.lastSeenAt
        )
    }
    
    public func updateDBModel(_ dbModel: StoryInteractionDBModel, with interaction: StoryInteraction) {
        dbModel.isSeen = interaction.isSeen
        dbModel.isLiked = interaction.isLiked
        dbModel.lastSeenAt = interaction.lastSeenAt
    }
}

