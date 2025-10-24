//
//  MockUsageExample.swift
//  DomainDataMock
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//
//  This file demonstrates how to use MockUserProfileSyncService in SwiftUI previews
//

#if DEBUG
import SwiftUI
import Domain

// MARK: - Example 1: Basic Preview Usage

/*
 
 struct FeedView: View {
     let syncService: UserProfileSyncServiceProtocol
     @State private var profiles: [UserProfile] = []
     @State private var isLoading = false
     
     var body: some View {
         List(profiles) { profile in
             ProfileRow(profile: profile)
         }
         .task {
             await loadProfiles()
         }
     }
     
     private func loadProfiles() async {
         isLoading = true
         defer { isLoading = false }
         
         do {
             profiles = try await syncService.syncProfiles()
         } catch {
             print("Error: \(error)")
         }
     }
 }

 // MARK: - Previews

 #Preview("Default - With Data") {
     FeedView(syncService: MockUserProfileSyncService.preview)
 }

 #Preview("Loading State - Slow Network") {
     FeedView(syncService: MockUserProfileSyncService.previewSlowNetwork)
 }

 #Preview("Offline Mode - Cached Data") {
     FeedView(syncService: MockUserProfileSyncService.previewOffline)
 }

 #Preview("Error State") {
     FeedView(syncService: MockUserProfileSyncService.previewError)
 }

 #Preview("Empty State") {
     FeedView(syncService: MockUserProfileSyncService.previewEmpty)
 }

 #Preview("Many Profiles - Scrolling") {
     FeedView(syncService: MockUserProfileSyncService.previewManyProfiles)
 }
 
 */

// MARK: - Example 2: Custom Configuration

/*
 
 #Preview("Custom Configuration") {
     let mock = MockUserProfileSyncService(
         mockProfiles: [
             UserProfile(
                 id: 1,
                 name: "Custom User",
                 age: 28,
                 location: "Custom City",
                 bio: "Custom bio",
                 profileImageURL: nil
             )
         ],
         networkDelay: 500,  // 500ms delay
         shouldThrowErrorOnSync: false,
         shouldThrowErrorOnLocal: false,
         hasLocalData: true
     )
     
     FeedView(syncService: mock)
 }
 
 */

// MARK: - Example 3: Testing Offline/Online Scenarios

/*
 
 struct FeedViewWithRefresh: View {
     let syncService: MockUserProfileSyncService
     @State private var profiles: [UserProfile] = []
     
     var body: some View {
         List(profiles) { profile in
             ProfileRow(profile: profile)
         }
         .refreshable {
             await refresh()
         }
         .task {
             await loadCached()
         }
     }
     
     private func loadCached() async {
         do {
             profiles = try await syncService.getLocalProfiles()
         } catch {
             print("No cache")
         }
     }
     
     private func refresh() async {
         do {
             profiles = try await syncService.syncProfiles()
         } catch {
             print("Sync failed, keeping cached data")
         }
     }
 }

 #Preview("Start Offline, Can Refresh") {
     let mock = MockUserProfileSyncService.preview
     Task {
         await mock.configureForOffline()
     }
     return FeedViewWithRefresh(syncService: mock)
 }
 
 */

// MARK: - Example 4: With @Observable Coordinator

/*
 
 @Observable
 final class FeedCoordinator {
     private let syncService: UserProfileSyncServiceProtocol
     var profiles: [UserProfile] = []
     var isLoading = false
     var error: Error?
     
     init(syncService: UserProfileSyncServiceProtocol) {
         self.syncService = syncService
     }
     
     @MainActor
     func loadProfiles() async {
         isLoading = true
         error = nil
         
         do {
             profiles = try await syncService.syncProfiles()
         } catch {
             self.error = error
         }
         
         isLoading = false
     }
 }

 struct FeedViewWithCoordinator: View {
     @State private var coordinator: FeedCoordinator
     
     init(syncService: UserProfileSyncServiceProtocol) {
         _coordinator = State(initialValue: FeedCoordinator(syncService: syncService))
     }
     
     var body: some View {
         // Your view implementation
         EmptyView()
     }
 }

 #Preview("With Coordinator") {
     FeedViewWithCoordinator(syncService: MockUserProfileSyncService.preview)
 }
 
 */

// MARK: - Example 5: Testing Edge Cases

/*
 
 #Preview("Network Error After Success") {
     let mock = MockUserProfileSyncService.preview
     
     // First load will succeed, then simulate network failure
     Task {
         // Wait a bit then simulate network failure
         try? await Task.sleep(for: .seconds(3))
         await mock.configureForOffline()
     }
     
     return FeedView(syncService: mock)
 }

 #Preview("Gradual Loading") {
     let mock = MockUserProfileSyncService(
         mockProfiles: [],
         networkDelay: 0,
         hasLocalData: false
     )
     
     // Simulate profiles being added over time
     Task {
         for i in 0..<5 {
             try? await Task.sleep(for: .seconds(1))
             await mock.mockProfiles.append(
                 UserProfile(
                     id: i,
                     name: "User \(i)",
                     age: 25,
                     location: "City",
                     bio: "Bio",
                     profileImageURL: nil
                 )
             )
         }
     }
     
     return FeedView(syncService: mock)
 }
 
 */

// MARK: - Example 6: Verifying Call Counts (for Unit Tests)

/*
 
 func testSyncServiceCallCount() async throws {
     let mock = MockUserProfileSyncService.preview
     
     // Perform operations
     _ = try await mock.syncProfiles()
     _ = try await mock.syncProfiles()
     _ = try await mock.getLocalProfiles()
     
     // Verify
     let syncCount = await mock.syncCallCount
     let localCount = await mock.localCallCount
     
     assert(syncCount == 2, "Expected 2 sync calls")
     assert(localCount == 1, "Expected 1 local call")
 }
 
 */

#endif

