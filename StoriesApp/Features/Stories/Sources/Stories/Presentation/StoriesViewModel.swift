//
//  StoriesViewModel.swift
//  Stories
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import Foundation
import Domain

final class StoriesViewModel: ObservableObject {
    
    let userProfileService: UserProfileSyncServiceProtocol
    
    @Published var profiles: [UserProfile] = []
    
    var topProfile: UserProfile? {
        profiles.first
    }
    
    var nextProfile: UserProfile? {
        guard profiles.count > 1 else {
            return nil
        }
        return profiles[1]
    }
    
    struct Depedencies {
        let userProfileService: UserProfileSyncServiceProtocol
    }
    
    init(dependencies: Depedencies) {
        self.userProfileService = dependencies.userProfileService
    }
    
    @MainActor
    func getCurrentStories() async {
        // if we have local profiles, use them
        if let localProfiles = try? await userProfileService.getLocalProfiles(), !localProfiles.isEmpty {
            self.profiles = localProfiles
            print("Using local profiles")
            return
        }
        
        let profiles = try? await userProfileService.syncProfiles()
        if let profiles = profiles {
            self.profiles = profiles
        }
    }
    
    func removeTopProfile() {
        guard !profiles.isEmpty else { return }
        profiles.removeFirst()
    }
}
