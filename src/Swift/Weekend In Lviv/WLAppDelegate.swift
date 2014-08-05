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

    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool
    {
        self.checkContentUpdate()
        
        var homeVC = WLHomeVCSw(nibName:"WLHomeVCSw",  bundle:nil)
        var detailNavigation = WLNavigationController(rootViewController: homeVC)
        UINavigationBar.appearance()!.barTintColor = RGB(48, 23, 0)
        
        var menuVC = WLMenuVCSw(style: UITableViewStyle.Plain)
        var menuNavigation = WLNavigationController(rootViewController: menuVC)
        menuVC.detailView = homeVC
        
        var drawerController = MMDrawerController(centerViewController: detailNavigation, leftDrawerViewController: menuNavigation)
        drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.All
        drawerController.maximumLeftDrawerWidth = 320
        
        self.window = UIWindow(frame: UIScreen.mainScreen()!.bounds)
        self.window!.rootViewController = drawerController
        self.window!.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication)
    {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication)
    {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
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
        if managedObjectContext != nil {
            if managedObjectContext.hasChanges && !managedObjectContext.save(&error) {
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
        if !_managedObjectContext {
            let coordinator = self.persistentStoreCoordinator
            if coordinator != nil {
                _managedObjectContext = NSManagedObjectContext()
                _managedObjectContext!.persistentStoreCoordinator = coordinator
            }
        }
        return _managedObjectContext!
    }
    var _managedObjectContext: NSManagedObjectContext? = nil

    // Returns the managed object model for the application.
    // If the model doesn't already exist, it is created from the application's model.
    var managedObjectModel: NSManagedObjectModel
    {
        if !_managedObjectModel {
            let modelURL = NSBundle.mainBundle().URLForResource("Weekend_In_Lviv", withExtension: "momd")
            _managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL)
        }
        return _managedObjectModel!
    }
    var _managedObjectModel: NSManagedObjectModel? = nil

    // Returns the persistent store coordinator for the application.
    // If the coordinator doesn't already exist, it is created and the application's store added to it.
    var persistentStoreCoordinator: NSPersistentStoreCoordinator
    {
        if !_persistentStoreCoordinator {
            let storeURL = self.applicationDocumentsDirectory().URLByAppendingPathComponent("Weekend_In_Lviv.sqlite")
            var error: NSError? = nil
            _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
            if _persistentStoreCoordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil, error: &error) == nil {
                /*
                Replace this implementation with code to handle the error appropriately.

                abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                Typical reasons for an error here include:
                * The persistent store is not accessible;
                * The schema for the persistent store is incompatible with current managed object model.
                Check the error message to determine what the actual problem was.


                If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.

                If you encounter schema incompatibility errors during development, you can reduce their frequency by:
                * Simply deleting the existing store:
                NSFileManager.defaultManager().removeItemAtURL(storeURL, error: nil)

                * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
                [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true}

                Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.

                */
                //println("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
        }
        return _persistentStoreCoordinator!
    }
    var _persistentStoreCoordinator: NSPersistentStoreCoordinator? = nil

    // #pragma mark - Application's Documents directory
                                    
    // Returns the URL to the application's Documents directory.
    func applicationDocumentsDirectory() -> NSURL
    {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.endIndex-1] as NSURL
    }
    
    func checkContentUpdate()
    {
        let rootFilePath:String = NSBundle.mainBundle().pathForResource("Root", ofType:"json")
        var jsonData:NSData     = NSData.dataWithContentsOfFile(rootFilePath, options: nil, error: nil)
        var error:NSError?      = nil
        var rootDict:Dictionary<String, AnyObject> = NSJSONSerialization.JSONObjectWithData(jsonData, options:NSJSONReadingOptions.MutableContainers, error:&error) as Dictionary<String, AnyObject>

        if error {
            println("App delegate: root file parsing error:error")
        }
        else if ((NSUserDefaults.standardUserDefaults().floatForKey("currentVersion")) != rootDict["version"]!.floatValue) {
            
            println("App delegate: update content")
            WLDataManager.sharedManager.clearPlacesData()
            var fileNames:NSArray = rootDict["files"] as NSArray
            
            for fileName : AnyObject in fileNames {
                let pathToFile:String? = NSBundle.mainBundle()!.pathForResource(fileName as String, ofType: "json")
                if let pathToFile_ = pathToFile {
                    
                    var fileData:NSData = NSData(contentsOfFile: pathToFile)
                    var fileDict:Dictionary<String, AnyObject> = NSJSONSerialization.JSONObjectWithData(fileData,
                                                                                                        options:NSJSONReadingOptions.MutableContainers,
                                                                                                        error:&error) as Dictionary<String, AnyObject>
                    if error {
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





