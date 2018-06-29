//
//  AppDelegate.swift
//  RelationshipCoreData
//
//  Created by Sumit Ghosh on 27/06/18.
//  Copyright © 2018 Sumit Ghosh. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.fetchAllData()
        return true
    }
    
    //MARK: Fetch all data and accordingly fill demo data
    @objc func fetchAllData() -> Void {
        self.getDeviceData()
        self.getUserData()
    }
    
    //MARK: get data for device attribute
    func getDeviceData() -> Void {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Device")
        do {
            if let resultsDevice = try coreDataStack.managedObjectContext.fetch(fetchRequest) as? [Device]  {
                if resultsDevice.count == 0 {
                    self.addTestData()
                }
            }
        } catch {
            print("Cannot fetch device")
        }
        
    }
    
    //MARK: get data for user attribute
    func getUserData() -> Void {
        let fetchUserRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            if let resultUser =  try coreDataStack.managedObjectContext.fetch(fetchUserRequest) as? [User] {
                if resultUser.count == 0 {
                    self.addDataToUsers()
                }
            }
        } catch {
            print("Cannot fetch user")
        }
        
    }
    //MARK: add test data to device attribte
    func addTestData() -> Void {
        //Create the entity
        guard let entity = NSEntityDescription.entity(forEntityName: "Device", in: coreDataStack.managedObjectContext) else {
            fatalError("Could not find entiyu description")
        }
        //Create the NSManagedObject
        
        for i in 1...10 {
            let device = Device.init(entity: entity, insertInto: coreDataStack.managedObjectContext)
            device.name = "Some Device #\(i)"
            device.deviceType = i % 3 == 0 ? "Watch" : "iPhone"
            device.osVersion = i % 3 == 0 ? "watchOS 4.6" : "iOS 11.3"
        }
    }
    
    //MARK: add data to User attribute
    func addDataToUsers() -> Void {
        guard let userEntity = NSEntityDescription.entity(forEntityName: "User", in: coreDataStack.managedObjectContext) else {
            fatalError("Could not find entity User")
        }
        let arrayName = ["Rogers","Stark","Banner","Barten"]
        for i in 0 ..< arrayName.count {
            let device_user = User.init(entity: userEntity, insertInto: coreDataStack.managedObjectContext)
            device_user.name = arrayName[i]
        }
  
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        coreDataStack.saveMainContext()
    }
}

