//
//  UserProfileDBModel.swift
//  DomainData
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import Foundation
@preconcurrency import SwiftData

/// SwiftData model for persisting user profiles locally
@Model
public final class UserProfileDBModel {
    @Attribute(.unique) public var id: Int
    public var name: String
    public var age: Int
    public var location: String
    public var bio: String
    public var profileImageURLString: String?
    public var lastUpdated: Date
    
    public init(
        id: Int,
        name: String,
        age: Int,
        location: String,
        bio: String,
        profileImageURLString: String?,
        lastUpdated: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.age = age
        self.location = location
        self.bio = bio
        self.profileImageURLString = profileImageURLString
        self.lastUpdated = lastUpdated
    }
}

