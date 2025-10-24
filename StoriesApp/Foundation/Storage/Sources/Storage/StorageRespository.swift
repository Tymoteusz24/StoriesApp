//
//  StorageRespository.swift
//  Storage
//
//  Created by Tymoteusz Pasieka on 10/24/25.
//

import Foundation
import SwiftData

public protocol StorageRespository: Actor {
    associatedtype DBModel
    associatedtype DomainModel

    func getAll() throws -> [DomainModel]
    func deleteEntities(_ models: [DBModel])
    func create(_ models: [DBModel])
    func save() throws
}

public protocol StorageMapper<DBModel, DomainModel>: Sendable {
    associatedtype DBModel
    associatedtype DomainModel: Sendable

    func mapToDomain(_ dbModel: DBModel) -> DomainModel
    func mapToDB(_ domainModel: DomainModel) -> DBModel
}

