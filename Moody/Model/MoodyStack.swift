//
//  MoodyStack.swift
//  Moody
//
//  Created by Philip Smith on 5/25/19.
//  Copyright © 2019 Philip Smith. All rights reserved.
//
import CoreData


func createMoodyContainer(completion: @escaping (NSPersistentContainer) -> ()) {
    let container = NSPersistentContainer(name: "Moody")
    container.loadPersistentStores { _, error in
        guard error == nil else { fatalError("Failed to load store: \(error!)") }
        DispatchQueue.main.async { completion(container) }
    }
}
