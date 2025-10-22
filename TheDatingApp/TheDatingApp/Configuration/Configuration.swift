//
//  Configuration.swift
//  TheDatingApp
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import Foundation
import Combine
import Logger
import DomainData

class Configuration: ObservableObject {
    
    let logger: ILogger
    let userProfileService: UserProfileSyncService
    init(logger: ILogger, userProfileService: UserProfileSyncService) {
        self.logger = logger
        self.userProfileService = userProfileService
    }
}

