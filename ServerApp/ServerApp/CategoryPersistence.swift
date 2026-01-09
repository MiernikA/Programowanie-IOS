//
//  CategoryPersistence.swift
//  ServerApp
//
//  Created by Adrian on 08/01/2026.
//

import CoreData

func saveCategories(
    _ categories: [CategoryDTO],
    context: NSManagedObjectContext
) throws {

    let fetch: NSFetchRequest<NSFetchRequestResult> =
        CategoryEntity.fetchRequest()
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
    try context.execute(deleteRequest)

    for dto in categories {
        let entity = CategoryEntity(context: context)
        entity.id = Int64(dto.id)
        entity.name = dto.name
    }

    try context.save()
}
