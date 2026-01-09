//
//  ProductPersistence.swift
//  ServerApp
//
//  Created by Adrian on 08/01/2026.
//

import CoreData

func saveProducts(
    _ products: [ProductDTO],
    context: NSManagedObjectContext
) throws {

    let fetchRequest: NSFetchRequest<NSFetchRequestResult> =
        ProductEntity.fetchRequest()

    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    deleteRequest.resultType = .resultTypeObjectIDs

    let result = try context.execute(deleteRequest) as? NSBatchDeleteResult
    let objectIDs = result?.result as? [NSManagedObjectID] ?? []

    let changes: [AnyHashable: Any] = [
        NSDeletedObjectsKey: objectIDs
    ]

    NSManagedObjectContext.mergeChanges(
        fromRemoteContextSave: changes,
        into: [context]
    )

    for dto in products {
        let entity = ProductEntity(context: context)
        entity.id = Int64(dto.id)
        entity.name = dto.name
        entity.price = dto.price
        entity.categoryId = Int64(dto.categoryId)
    }

    try context.save()
}
