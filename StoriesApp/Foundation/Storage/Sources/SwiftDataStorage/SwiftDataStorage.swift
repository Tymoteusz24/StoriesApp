//
//  SwiftDataStorage.swift
//  Storage
//
//  Created by Tymoteusz Pasieka on 10/24/25.
//

import Foundation
@preconcurrency import SwiftData
import Storage

public actor ModelRepository<DBModel: PersistentModel, DomainModel>: StorageRespository {
    private let context: ModelContext
    public var mapper: any StorageMapper<DBModel, DomainModel>

    public init(context: ModelContext, mapper: any StorageMapper<DBModel, DomainModel>) {
        self.context = context
        self.mapper = mapper
    }

    public func getAll() throws -> [DomainModel] {
        let params = FetchDescriptor<DBModel>()

        let result = try context.fetch(params)

        return result.map { mapper.mapToDomain($0) }
    }

    public func deleteEntities(_ models: [DBModel]) {
        for model in models {
            context.delete(model)
        }
    }

    /// Save changes made to the local data store
    public func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }

    /// Add models to the local data store
    public func create(_ models: [DBModel]) {
        for model in models {
            context.insert(model)
        }
    }
}
