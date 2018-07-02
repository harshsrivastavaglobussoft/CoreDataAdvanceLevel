//
//  Device+CoreDataProperties.swift
//  RelationshipCoreData
//
//  Created by Sumit Ghosh on 30/06/18.
//  Copyright © 2018 Sumit Ghosh. All rights reserved.
//
//

import Foundation
import CoreData


extension Device {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Device> {
        return NSFetchRequest<Device>(entityName: "Device")
    }

    @NSManaged public var deviceType: DeviceType?
    @NSManaged public var name: String
    @NSManaged public var osVersion: String
    @NSManaged public var purchaseDate: String?
    @NSManaged public var image: NSData?
    @NSManaged public var owner: User?

}
