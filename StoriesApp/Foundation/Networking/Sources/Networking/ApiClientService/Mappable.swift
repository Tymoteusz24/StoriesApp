//
//  Mappable.swift
//  Networking
//
//  Created by Tymoteusz Pasieka on 10/24/25.
//

import Foundation

// Mappable protocol for mapping from Data to Model
public protocol Mappable: Sendable {
    associatedtype Input: Decodable & Sendable
    associatedtype Output: Sendable

    func map(_ input: Input) throws -> Output
}
