//
//  DataController.swift
//  VirtualTourist
//
//  Created by manar AL-Towaim on 16/07/2019.
//  Copyright © 2019 manar AL-Towaim. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    static let shard = DataController()

    let persistentContainer = NSPersistentContainer(name: "VirtualTourist")
    
    var viewContaxt: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    func load (){
        persistentContainer.loadPersistentStores { (storeDescribtion, error) in
            guard error == nil else {
                fatalError("coudn't load data >> error: \(error?.localizedDescription ?? "error message is nil")")
            }
        }
    }
}
