//
//  DeviceType+CoreDataProperties.swift
//  RelationshipCoreData
//
//  Created by Sumit Ghosh on 02/07/18.
//  Copyright © 2018 Sumit Ghosh. All rights reserved.
//
//

import Foundation
import CoreData


extension DeviceType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DeviceType> {
        return NSFetchRequest<DeviceType>(entityName: "DeviceType")
    }

    @NSManaged public var name: String
    @NSManaged public var device: NSSet

}

// MARK: Generated accessors for device
extension DeviceType {

    @objc(addDeviceObject:)
    @NSManaged public func addToDevice(_ value: Device)

    @objc(removeDeviceObject:)
    @NSManaged public func removeFromDevice(_ value: Device)

    @objc(addDevice:)
    @NSManaged public func addToDevice(_ values: NSSet)

    @objc(removeDevice:)
    @NSManaged public func removeFromDevice(_ values: NSSet)

}
