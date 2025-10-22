//
//  Mappable.swift
//  Networking
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import Foundation

// Mappable protocol for mapping from Data to Model
public protocol Mappable {
    associatedtype Input: Decodable
    associatedtype Output

    func map(_ input: Input) throws -> Output
}
