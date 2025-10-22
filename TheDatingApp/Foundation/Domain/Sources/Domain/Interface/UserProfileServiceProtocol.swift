//
//  UserProfileService.swift
//  Domain
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import Foundation

/// Protocol for fetching user profiles
/// This abstraction lives in the Domain layer following Clean Architecture principles
public protocol UserProfileServiceProtocol {
    func fetchProfiles() async throws -> [UserProfile]
}

