//
//  WLAppDelegate.m
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/11/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import "WLAppDelegate.h"
#import "WLHomeVC.h"
#import "WLMenuVC.h"
#import "WLNavigationController.h"
#import "MMDrawerController.h"
#import "WLDataManager.h"


@interface WLAppDelegate ()


@property (readwrite, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readwrite, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readwrite, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end


@implementation WLAppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self checkContentUpdate];
    
    WLHomeVC *homeVC = [[WLHomeVC alloc] initWithNibName:@"WLHomeVC" bundle:nil];
    WLNavigationController *detailNavigation = [[WLNavigationController alloc] initWithRootViewController:homeVC];
    [[UINavigationBar appearance] setBarTintColor:RGB(48, 23, 0)];

    WLMenuVC *menuVC = [[WLMenuVC alloc] init];
    WLNavigationController *menuNavigation = [[WLNavigationController alloc] initWithRootViewController:menuVC];
    menuVC.detailView = homeVC;
    
    MMDrawerController *drawerController = [[MMDrawerController alloc]
                                            initWithCenterViewController:detailNavigation
                                            leftDrawerViewController:menuNavigation];
    drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
    drawerController.maximumLeftDrawerWidth = 320;

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = drawerController;

    return YES;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}


- (void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
}


#pragma mark - Core Data stack
// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}


// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }

#pragma clang diagnostic push
#pragma ide diagnostic ignored "ResourceNotFoundInspection"
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Weekend_In_Lviv" withExtension:@"momd"];
#pragma clang diagnostic pop

    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Weekend_In_Lviv.sqlite"];

    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }

    return _persistentStoreCoordinator;
}


#pragma mark - Application's Documents directory
// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (void)checkContentUpdate {
    NSString *rootFilePath = [[NSBundle mainBundle] pathForResource:@"Root" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:rootFilePath];
    NSError *error = nil;
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"Root file parsing error:%@", error.localizedDescription);
    }
    else if ([[NSUserDefaults standardUserDefaults] floatForKey:@"currentVersion"] != [rootDict[@"version"] floatValue]) {
        NSLog(@"Update content");
        [[WLDataManager sharedManager] clearPlacesData];
        NSArray *fileNames = rootDict[@"files"];
        for (NSString *fileName in fileNames) {
            NSString *pathToFile = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
            if (!pathToFile) {
                NSLog(@"File not found:%@", fileName);
            }
            else {
                NSData *fileData = [NSData dataWithContentsOfFile:pathToFile];
                NSDictionary *fileDict = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableContainers error:&error];
                if (error) {
                    NSLog(@"File parsing error: %@ \nFile name: %@.json", error.localizedDescription, fileName);
                    error = nil;
                }
                else {

                    [[WLDataManager sharedManager] addPlaceWithOptions:fileDict];
                }
            }
        }
        [[WLDataManager sharedManager] saveContext];
        [[NSUserDefaults standardUserDefaults] setFloat:[rootDict[@"version"] floatValue] forKey:@"currentVersion"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    [[WLDataManager sharedManager] fillPlacesList];
}


@end
