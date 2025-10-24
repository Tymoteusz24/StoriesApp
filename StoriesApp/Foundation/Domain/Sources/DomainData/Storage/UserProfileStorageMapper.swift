//
//  UserProfileStorageMapper.swift
//  DomainData
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import Foundation
import Domain
import Storage

/// Maps between UserProfile domain model and UserProfileDBModel
public struct UserProfileStorageMapper: StorageMapper, Sendable {
    public typealias DBModel = UserProfileDBModel
    public typealias DomainModel = UserProfile
    
    public init() {}
    
    public func mapToDomain(_ dbModel: UserProfileDBModel) -> UserProfile {
        UserProfile(
            id: dbModel.id,
            name: dbModel.name,
            age: dbModel.age,
            location: dbModel.location,
            bio: dbModel.bio,
            profileImageURL: dbModel.profileImageURLString.flatMap { URL(string: $0) }
        )
    }
    
    public func mapToDB(_ domainModel: UserProfile) -> UserProfileDBModel {
        UserProfileDBModel(
            id: domainModel.id,
            name: domainModel.name,
            age: domainModel.age,
            location: domainModel.location,
            bio: domainModel.bio,
            profileImageURLString: domainModel.profileImageURL?.absoluteString
        )
    }
}

