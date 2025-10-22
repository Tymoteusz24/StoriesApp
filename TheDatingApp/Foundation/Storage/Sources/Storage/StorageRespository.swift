//
//  StorageRespository.swift
//  Storage
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import Foundation
import SwiftData

protocol StorageRespository: Actor {
    associatedtype DBModel
    associatedtype DomainModel

    func getAll() throws -> [DomainModel]
    func deleteEntities(_ models: [DBModel])
    func create(_ models: [DBModel])
    func save() throws
}

protocol StorageMapper<DBModel, DomainModel> {
    associatedtype DBModel
    associatedtype DomainModel

    func mapToDomain(_ dbModel: DBModel) -> DomainModel
    func mapToDB(_ domainModel: DomainModel) -> DBModel
}

