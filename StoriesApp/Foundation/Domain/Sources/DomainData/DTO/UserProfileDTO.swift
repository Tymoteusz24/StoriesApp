//
//  UserProfileDTO.swift
//  DomainData
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import Foundation

/// Data Transfer Object for user profile from API
/// Matches the structure from: https://raw.githubusercontent.com/downapp/sample/main/sample.json
public struct UserProfileDTO: Codable, Sendable {
    public let name: String
    public let userId: Int
    public let age: Int
    public let location: String
    public let aboutMe: String
    public let profilePicUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case userId = "user_id"
        case age
        case location = "loc"
        case aboutMe = "about_me"
        case profilePicUrl = "profile_pic_url"
    }
    
    public init(
        name: String,
        userId: Int,
        age: Int,
        location: String,
        aboutMe: String,
        profilePicUrl: String?
    ) {
        self.name = name
        self.userId = userId
        self.age = age
        self.location = location
        self.aboutMe = aboutMe
        self.profilePicUrl = profilePicUrl
    }
}

/// Response wrapper for the profiles list
public typealias UserProfilesDTO = [UserProfileDTO]

