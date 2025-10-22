//
//  NetworkMock.swift
//  Networking
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import Foundation
import Networking
import Logger

public func createAPIClientServiceMock() -> IAPIClientService {
    return APIClientService(
        logger: NoLogger(label: ""),
        configuration: .init(
            baseURL: URL(string: "https://gateway.datingapp.com"),
            baseHeaders: [
                "accept": "application/json",
                "content-type": "application/json"
            ]
        )
    )
}

