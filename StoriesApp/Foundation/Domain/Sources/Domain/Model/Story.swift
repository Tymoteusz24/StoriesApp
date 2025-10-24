//
//  Story.swift
//  Domain
//
//  Created by Tymoteusz Pasieka on 10/24/25.
//

import Foundation

public struct Story: Identifiable, Hashable, Sendable {
    public let id: Int
    public let userId: Int
    public let userName: String
    public let userProfileImageURL: URL?
    public let mediaURL: URL?
    public let createdAt: Date
    public let duration: TimeInterval
    
    public init(
        id: Int,
        userId: Int,
        userName: String,
        userProfileImageURL: URL?,
        mediaURL: URL?,
        createdAt: Date,
        duration: TimeInterval
    ) {
        self.id = id
        self.userId = userId
        self.userName = userName
        self.userProfileImageURL = userProfileImageURL
        self.mediaURL = mediaURL
        self.createdAt = createdAt
        self.duration = duration
    }
}

#if DEBUG
public extension Story {
    static let mock = Story(
        id: 1,
        userId: 100,
        userName: "John Doe",
        userProfileImageURL: URL(string: "https://example.com/profile.jpg"),
        mediaURL: URL(string: "https://example.com/story.jpg"),
        createdAt: Date(),
        duration: 5.0
    )
}
#endif

