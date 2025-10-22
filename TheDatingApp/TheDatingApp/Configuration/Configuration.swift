//
//  Configuration.swift
//  TheDatingApp
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import Foundation
import Combine
import Logger
import Networking

class Configuration: ObservableObject {
    
    let logger: ILogger
    let apiClientService: IAPIClientService
    init(logger: ILogger, apiClientService: IAPIClientService) {
        self.logger = logger
        self.apiClientService = apiClientService
    }
}

