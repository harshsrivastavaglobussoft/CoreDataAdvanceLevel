//
//  CoreDataStack.swift
//  RelationshipCoreData
//
//  Created by Harsh Srivastava on 29/06/18.
//  Copyright © 2018 Harsh Srivastava. All rights reserved.
//

/* One can use this in any project just replace the moduleName with your module name and remove the core data stack part from you app delegate this makes your app delegate more clean and short using this one can add core data in exsisting projects no need to check use core data while creating a new project*/

import Foundation
import CoreData

class CoreDataStack: NSObject {
    //MARK: Core Data Stack 
    static let moduleName = "RelationshipCoreData"
    
    //Loading the Core Data Model of the applicaiton using NSBundle
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: CoreDataStack.moduleName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    //Accessing the Document Directory
    lazy var applicationDocumentDirectoty: NSURL = {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return urls.last! as NSURL
    }()
    
    //Accessing / Creating Persistent Store Coordinator -PersistentStoreCoordinator manages your persistent store one can have multiple persistet store
    //(*Persistent Store represents the actual file on disk with your data)
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let persistentStoreURL = self.applicationDocumentDirectoty.appendingPathComponent("\(CoreDataStack.moduleName).sqlite")//Creating or accessing the persistent store
        
        do{
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreURL, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: false]) //adding the persistent store in persistent container
        }catch{
            fatalError("Persistent Store error! \(error)")
        }
        return coordinator
    }()
    
    //Accessing / Creating the NSManagedObjectContext - It is the workspace which contains the Managed Objects (*managed object represents a single data in your data model)
    lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    //MARK: Save ManagedObjectContext
    //If the Managed object context has some changes it saves the changes 
    func saveMainContext() -> Void {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                fatalError("Error saving main managed object context \(error)")
            }
        }
    }
}
