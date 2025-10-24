//
//  StoryInteractionDBModel.swift
//  DomainData
//
//  Created by Tymoteusz Pasieka on 10/24/25.
//

import Foundation
import SwiftData

@Model
public final class StoryInteractionDBModel {
    @Attribute(.unique) public var storyId: Int
    public var isSeen: Bool
    public var isLiked: Bool
    public var lastSeenAt: Date?
    
    public init(
        storyId: Int,
        isSeen: Bool,
        isLiked: Bool,
        lastSeenAt: Date?
    ) {
        self.storyId = storyId
        self.isSeen = isSeen
        self.isLiked = isLiked
        self.lastSeenAt = lastSeenAt
    }
}

