//
//  StoryInteraction.swift
//  Domain
//
//  Created by Tymoteusz Pasieka on 10/24/25.
//

import Foundation

public struct StoryInteraction: Identifiable, Hashable, Sendable {
    public let id: Int // storyId
    public let isSeen: Bool
    public let isLiked: Bool
    public let lastSeenAt: Date?
    
    public init(
        id: Int,
        isSeen: Bool,
        isLiked: Bool,
        lastSeenAt: Date?
    ) {
        self.id = id
        self.isSeen = isSeen
        self.isLiked = isLiked
        self.lastSeenAt = lastSeenAt
    }
}

#if DEBUG
public extension StoryInteraction {
    static let mock = StoryInteraction(
        id: 1,
        isSeen: false,
        isLiked: false,
        lastSeenAt: nil
    )
    
    static let mockSeen = StoryInteraction(
        id: 1,
        isSeen: true,
        isLiked: false,
        lastSeenAt: Date()
    )
    
    static let mockLiked = StoryInteraction(
        id: 1,
        isSeen: true,
        isLiked: true,
        lastSeenAt: Date()
    )
}
#endif

