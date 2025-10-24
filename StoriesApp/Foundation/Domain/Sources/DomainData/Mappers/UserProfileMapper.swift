//
//  UserProfileMapper.swift
//  DomainData
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import Foundation
import Domain
import Networking

/// Mapper to convert UserProfileDTO to UserProfile domain model
public struct UserProfileMapper: Mappable, Sendable {
    public typealias Input = UserProfileDTO
    public typealias Output = UserProfile
    
    public init() {}
    
    public func map(_ input: UserProfileDTO) throws -> UserProfile {
        UserProfile(
            id: input.userId,
            name: input.name,
            age: input.age,
            location: input.location,
            bio: input.aboutMe,
            profileImageURL: URL(optionalString: input.profilePicUrl) ?? nil
        )
    }
}

/// Mapper for list of profiles
public struct UserProfilesMapper: Mappable, Sendable {
    public typealias Input = UserProfilesDTO
    public typealias Output = [UserProfile]
    
    private let profileMapper = UserProfileMapper()
    
    public init() {}
    
    public func map(_ input: UserProfilesDTO) throws -> [UserProfile] {
        try input.map { try profileMapper.map($0) }
    }
}

// url extension with optional string initliser
private extension URL {
    init?(optionalString: String?) {
        guard let urlString = optionalString else {
            return nil
        }
        self.init(string: urlString)
    }
}
