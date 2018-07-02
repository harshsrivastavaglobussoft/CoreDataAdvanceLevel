//
//  MigrationVer1ToVer2.swift
//  RelationshipCoreData
//
//  Created by Sumit Ghosh on 02/07/18.
//  Copyright © 2018 Sumit Ghosh. All rights reserved.
//

import CoreData

class MigrationVer1ToVer2: NSEntityMigrationPolicy {
    override func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        try super.createDestinationInstances(forSource: sInstance, in: mapping, manager: manager)
        
        //create or look up the device type
        var deviceTypeInstance : NSManagedObject!
        let deviceTypeName = sInstance.value(forKey: "deviceType") as! String
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "DeviceType")
        fetchRequest.predicate = NSPredicate(format: "name == %@",deviceTypeName)
        let results = try manager.destinationContext.fetch(fetchRequest)
        
        if let resultInstance = results.last as? NSManagedObject {
            deviceTypeInstance = resultInstance
        }else{
            let entity = NSEntityDescription.entity(forEntityName: "DeviceType", in: manager.destinationContext)
            deviceTypeInstance = NSManagedObject.init(entity: entity!, insertInto: manager.destinationContext)
            deviceTypeInstance.setValue(deviceTypeName, forKey: "name")
        }
        
        //Get the destination device
        let destResults = manager.destinationInstances(forEntityMappingName: mapping.name, sourceInstances: [sInstance])
        if let destinationDevice = destResults.last {
            destinationDevice.setValue(deviceTypeInstance, forKey: "deviceType")
        }
    }
}
