//
//  Core_Data_PersistenceAppDelegate.h
//  Core Data Persistence
//
//  Created by Marc Mauger on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class PersistenceViewController;
@interface Core_Data_PersistenceAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    PersistenceViewController *rootController;
	
@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) IBOutlet PersistenceViewController *rootController;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;

@end

