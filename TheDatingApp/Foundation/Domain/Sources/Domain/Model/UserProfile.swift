//
//  UserProfile.swift
//  Domain
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import Foundation

/// Domain model representing a user profile in the dating app
public struct UserProfile: Identifiable, Sendable, Hashable {
    public let id: Int
    public let name: String
    public let age: Int
    public let location: String
    public let bio: String
    public let profileImageURL: URL?
    
    public init(
        id: Int,
        name: String,
        age: Int,
        location: String,
        bio: String,
        profileImageURL: URL?
    ) {
        self.id = id
        self.name = name
        self.age = age
        self.location = location
        self.bio = bio
        self.profileImageURL = profileImageURL
    }
}

// MARK: - Preview Mock Data
#if DEBUG
extension UserProfile {
    public static let mock = UserProfile(
        id: 13620229,
        name: "Jessica",
        age: 25,
        location: "Ripon, CA",
        bio: "baby stoner, + size \nbig boob haver and enjoyer\nlast pic is most recent :)",
        profileImageURL: URL(string: "https://down-static.s3.us-west-2.amazonaws.com/picks_filter/female_v2/pic00000.jpg")
    )
    
    public static let mockList: [UserProfile] = [
        mock,
        UserProfile(
            id: 13620230,
            name: "Krystina",
            age: 33,
            location: "San Pablo, CA",
            bio: "Looking for new connections",
            profileImageURL: URL(string: "https://down-static.s3.us-west-2.amazonaws.com/picks_filter/female_v2/pic00001.jpg")
        )
    ]
}
#endif

