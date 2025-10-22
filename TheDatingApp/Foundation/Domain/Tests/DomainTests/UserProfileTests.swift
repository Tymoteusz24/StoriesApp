//
//  UserProfileTests.swift
//  DomainTests
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import Testing
import Foundation
@testable import Domain
@testable import DomainData
@testable import DomainDataMock
@testable import Networking

@Suite("User Profile Tests")
struct UserProfileTests {
    
    @Test("DTO decodes correctly from JSON")
    func userProfileDTODecoding() throws {
        let json = """
        {
            "name": "Jessica",
            "user_id": 13620229,
            "age": 25,
            "loc": "Ripon, CA",
            "about_me": "Test bio",
            "profile_pic_url": "https://example.com/pic.jpg"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let dto = try decoder.decode(UserProfileDTO.self, from: json)
        
        #expect(dto.name == "Jessica")
        #expect(dto.userId == 13620229)
        #expect(dto.age == 25)
        #expect(dto.location == "Ripon, CA")
        #expect(dto.aboutMe == "Test bio")
        #expect(dto.profilePicUrl == "https://example.com/pic.jpg")
    }
    
    @Test("Mapper converts DTO to domain model")
    func userProfileMapper() throws {
        let dto = UserProfileDTO(
            name: "Jessica",
            userId: 13620229,
            age: 25,
            location: "Ripon, CA",
            aboutMe: "Test bio",
            profilePicUrl: "https://example.com/pic.jpg"
        )
        
        let mapper = UserProfileMapper()
        let profile = try mapper.map(dto)
        
        #expect(profile.id == 13620229)
        #expect(profile.name == "Jessica")
        #expect(profile.age == 25)
        #expect(profile.location == "Ripon, CA")
        #expect(profile.bio == "Test bio")
        #expect(profile.profileImageURL?.absoluteString == "https://example.com/pic.jpg")
    }
    
    @Test("Mock service returns profiles successfully")
    func mockUserProfileServiceSuccess() async throws {
        let service = MockUserProfileService(shouldFail: false, delay: 0)
        let profiles = try await service.fetchProfiles()
        
        #expect(!profiles.isEmpty, "Mock service should return profiles")
        #expect(profiles.count == 10, "Mock service should return 10 profiles from sample data")
        
        // Verify first profile
        let firstProfile = try #require(profiles.first)
        #expect(firstProfile.name == "Jessica")
        #expect(firstProfile.age == 25)
        #expect(firstProfile.location == "Ripon, CA")
    }
    
    @Test("Mock service throws error when configured to fail")
    func mockUserProfileServiceFailure() async throws {
        let service = MockUserProfileService(shouldFail: true, delay: 0)
        
        await #expect(throws: Error.self) {
            try await service.fetchProfiles()
        }
    }
    
    @Test("Dating API endpoint configuration is correct")
    func datingAPIEndpoint() {
        let endpoint = DatingAPIEndpoint.getProfiles
        
        #expect(endpoint.baseUrl?.absoluteString == "https://raw.githubusercontent.com")
        #expect(endpoint.path == "/downapp/sample/main/sample.json")
        #expect(endpoint.httpMethod == HTTPMethod.get)
        #expect(endpoint.urlQueries == nil)
        #expect(endpoint.headers != nil)
        #expect(endpoint.bodyParameters == nil)
    }
}

@Suite("User Profile DTO Edge Cases")
struct UserProfileDTOEdgeCaseTests {
    
    @Test("DTO handles missing optional fields")
    func dtoWithMissingOptionals() throws {
        let json = """
        {
            "name": "Test",
            "user_id": 1,
            "age": 20,
            "loc": "Test City",
            "about_me": "",
            "profile_pic_url": ""
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let dto = try decoder.decode(UserProfileDTO.self, from: json)
        
        #expect(dto.name == "Test")
        #expect(dto.aboutMe.isEmpty)
    }
}

@Suite("User Profile Mapper Edge Cases")
struct UserProfileMapperEdgeCaseTests {
    
    @Test("Mapper handles invalid URL")
    func mapperWithInvalidURL() throws {
        let dto = UserProfileDTO(
            name: "Test",
            userId: 1,
            age: 20,
            location: "Test",
            aboutMe: "Test",
            profilePicUrl: nil
        )
        
        let mapper = UserProfileMapper()
        let profile = try mapper.map(dto)
        
        #expect(profile.profileImageURL == nil, "Invalid URL should result in nil")
    }
}
