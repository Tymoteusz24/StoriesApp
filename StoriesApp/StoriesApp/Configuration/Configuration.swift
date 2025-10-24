//
//  Configuration.swift
//  StoriesApp
//
//  Created by Tymoteusz Pasieka on 10/24/25.
//

import Foundation
import Combine
import Logger
import DomainData

@MainActor
class Configuration: ObservableObject {
    
    let logger: ILogger
    nonisolated(unsafe) let storiesService: StoriesService
    
    init(logger: ILogger, storiesService: StoriesService) {
        self.logger = logger
        self.storiesService = storiesService
    }
}

