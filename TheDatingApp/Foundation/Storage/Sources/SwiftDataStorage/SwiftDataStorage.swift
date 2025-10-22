//
//  SwiftDataStorage.swift
//  Storage
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import Foundation
import SwiftData

actor ModelRepository<DBModel: PersistentModel, DomainModel>: StorageRespository {
    private let context: ModelContext
    var mapper: any StorageMapper<DBModel, DomainModel>

    init(context: ModelContext, mapper: any StorageMapper<DBModel, DomainModel>) {
        self.context = context
        self.mapper = mapper
    }

    func getAll() throws -> [DomainModel] {
        let params = FetchDescriptor<DBModel>()

        let result = try context.fetch(params)

        return result.map { mapper.mapToDomain($0) }
    }

    func deleteEntities(_ models: [DBModel]) {
        for model in models {
            context.delete(model)
        }
    }

    /// Save changes made to the local data store
    func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }

    /// Add models to the local data store
    func create(_ models: [DBModel]) {
        for model in models {
            context.insert(model)
        }
    }
}
