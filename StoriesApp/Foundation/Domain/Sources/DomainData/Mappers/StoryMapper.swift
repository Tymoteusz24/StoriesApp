//
//  StoryMapper.swift
//  DomainData
//
//  Created by Tymoteusz Pasieka on 10/24/25.
//

import Foundation
import Domain
import Networking

/// Mapper to convert StoryDTO to Story domain model
public struct StoryMapper: Mappable, Sendable {
    public typealias Input = StoryDTO
    public typealias Output = Story
    
    public init() {}
    
    public func map(_ input: StoryDTO) throws -> Story {
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: input.createdAt) ?? Date()
        
        return Story(
            id: input.storyId,
            userId: input.userId,
            userName: input.userName,
            userProfileImageURL: URL(optionalString: input.userProfileImageUrl),
            mediaURL: URL(optionalString: input.mediaUrl),
            createdAt: date,
            duration: input.duration
        )
    }
}

/// Mapper for list of stories
public struct StoriesMapper: Mappable, Sendable {
    public typealias Input = [StoryDTO]
    public typealias Output = [Story]
    
    private let storyMapper = StoryMapper()
    
    public init() {}
    
    public func map(_ input: [StoryDTO]) throws -> [Story] {
        try input.map { try storyMapper.map($0) }
    }
}

// URL extension with optional string initializer
private extension URL {
    init?(optionalString: String?) {
        guard let urlString = optionalString else {
            return nil
        }
        self.init(string: urlString)
    }
}

