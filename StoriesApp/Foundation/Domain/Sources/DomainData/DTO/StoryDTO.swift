//
//  StoryDTO.swift
//  DomainData
//
//  Created by Tymoteusz Pasieka on 10/24/25.
//

import Foundation

public struct StoryDTO: Codable, Sendable {
    public let storyId: Int
    public let userId: Int
    public let userName: String
    public let userProfileImageUrl: String?
    public let mediaUrl: String?
    public let createdAt: String
    public let duration: Double
    
    enum CodingKeys: String, CodingKey {
        case storyId = "story_id"
        case userId = "user_id"
        case userName = "user_name"
        case userProfileImageUrl = "user_profile_image_url"
        case mediaUrl = "media_url"
        case createdAt = "created_at"
        case duration
    }
    
    public init(
        storyId: Int,
        userId: Int,
        userName: String,
        userProfileImageUrl: String?,
        mediaUrl: String?,
        createdAt: String,
        duration: Double
    ) {
        self.storyId = storyId
        self.userId = userId
        self.userName = userName
        self.userProfileImageUrl = userProfileImageUrl
        self.mediaUrl = mediaUrl
        self.createdAt = createdAt
        self.duration = duration
    }
}

