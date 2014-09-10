//
//  AppDelegate.swift
//  Weekend In Lviv
//
//  Created by Admin on 12.06.14.
//  Copyright (c) 2014 rnd. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class WLAppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    var _managedObjectContext: NSManagedObjectContext?             = nil
    var _persistentStoreCoordinator: NSPersistentStoreCoordinator? = nil
    var _managedObjectModel: NSManagedObjectModel?                 = nil
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool
    {
        self.checkContentUpdate()
        
        var homeVC           = WLHomeVCSw(nibName:"WLHomeVCSw",  bundle:nil)
        var detailNavigation = WLNavigationController(rootViewController: homeVC)
        UINavigationBar.appearance()!.barTintColor = RGB(48, 23, 0)
        
        var menuVC           = WLMenuVCSw(style: UITableViewStyle.Plain)
        var menuNavigation   = WLNavigationController(rootViewController: menuVC)
        menuVC.detailView    = homeVC
        
        var drawerController = MMDrawerController(centerViewController: detailNavigation, leftDrawerViewController: menuNavigation)
        drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.All
        drawerController.maximumLeftDrawerWidth = 320
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = drawerController
        self.window!.makeKeyAndVisible()

        return true
    }

    func applicationWillTerminate(application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    func saveContext ()
    {
        var error: NSError? = nil
        var managedObjectContext = self.managedObjectContext
        if _managedObjectContext != nil {
            if _managedObjectContext!.hasChanges &&
               !_managedObjectContext!.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                //println("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
        }
    }

    // #pragma mark - Core Data stack

    // Returns the managed object context for the application.
    // If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
    var managedObjectContext: NSManagedObjectContext
    {
        if _managedObjectContext != nil {
            return _managedObjectContext!
        }
        var coordinator:NSPersistentStoreCoordinator? = self.persistentStoreCoordinator
            
        if coordinator != nil {
            _managedObjectContext = NSManagedObjectContext()
            _managedObjectContext!.persistentStoreCoordinator = coordinator
        }
        return _managedObjectContext!
    }

    // Returns the managed object model for the application.
    // If the model doesn't already exist, it is created from the application's model.
    var managedObjectModel: NSManagedObjectModel
    {
        if _managedObjectModel == nil {
            let modelURL        = NSBundle.mainBundle().URLForResource("Weekend_In_Lviv", withExtension: "momd")
            _managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL!)
        }
        return _managedObjectModel!
    }

    // Returns the persistent store coordinator for the application.
    // If the coordinator doesn't already exist, it is created and the application's store added to it.
    var persistentStoreCoordinator: NSPersistentStoreCoordinator
    {
        if _persistentStoreCoordinator == nil {
            let storeURL        = self.applicationDocumentsDirectory().URLByAppendingPathComponent("Weekend_In_Lviv.sqlite")
            var error: NSError? = nil
            _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
            if _persistentStoreCoordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil, error: &error) == nil {
                //println("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
        }
        return _persistentStoreCoordinator!
    }

    // #pragma mark - Application's Documents directory
                                    
    // Returns the URL to the application's Documents directory.
    func applicationDocumentsDirectory() -> NSURL
    {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.endIndex-1] as NSURL
    }
    
    func checkContentUpdate()
    {
        let rootFilePath:String = NSBundle.mainBundle().pathForResource("Root", ofType:"json")!
        var jsonData:NSData     = NSData.dataWithContentsOfFile(rootFilePath, options: nil, error: nil)
        var error:NSError?      = nil
        var rootDict:Dictionary<String, AnyObject> = NSJSONSerialization.JSONObjectWithData(jsonData, options:NSJSONReadingOptions.MutableContainers, error:&error) as Dictionary<String, AnyObject>

        if error != nil {
            println("App delegate: root file parsing error:error")
        }
        else if ((NSUserDefaults.standardUserDefaults().floatForKey("currentVersion")) != rootDict["version"]!.floatValue) {
            
            println("App delegate: update content")
            WLDataManager.sharedManager.clearPlacesData()
            var fileNames:NSArray = rootDict["files"] as NSArray
            
            for fileName : AnyObject in fileNames {
                let pathToFile:String? = NSBundle.mainBundle().pathForResource(fileName as? String, ofType: "json")
                
                if let pathToFile_ = pathToFile {
                    var fileData:NSData = NSData(contentsOfFile: pathToFile!)
                    var fileDict:Dictionary<String, AnyObject> = NSJSONSerialization.JSONObjectWithData(fileData,
                                                                                                        options:NSJSONReadingOptions.MutableContainers,
                                                                                                        error:&error) as Dictionary<String, AnyObject>
                    if error != nil {
                        println("App delegate: File parsing error: \(error) \nFile name: \(fileName).json")
                    }
                    else {
                        WLDataManager.sharedManager.addPlaceWithOptions(fileDict)
                    }
                }
                else {
                    NSLog("App delegate: file not found:%@", fileName as String)
                }
            }
            WLDataManager.sharedManager.saveContext()
            NSUserDefaults.standardUserDefaults().setFloat(rootDict["version"]!.floatValue, forKey: "currentVersion")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        WLDataManager.sharedManager.fillPlacesList()
    }
}





