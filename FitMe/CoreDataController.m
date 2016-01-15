//
//  CoreDataController.m
//  FitMe
//
//  Created by Softheme iMac on 12/3/15.
//  Copyright © 2015 Artem Tkachuk. All rights reserved.
//

#import "CoreDataController.h"

@interface CoreDataController ()
@property (nonatomic, strong) NSObject *backgroundContextSaveNotifiation;
@property (nonatomic, strong) NSObject *mainContextSaveNotifiation;
@property (nonatomic, strong) NSArray *channels;

@end

@implementation CoreDataController

+ (instancetype) sharedController
{
    static CoreDataController *_sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedController = [[CoreDataController alloc] init];
        
    });
    return _sharedController;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self.backgroundContextSaveNotifiation];
    [[NSNotificationCenter defaultCenter] removeObserver:self.mainContextSaveNotifiation];
    
}


- (void) setupNotifications{
    
    __weak typeof(self) weakSelf = self;
    self.backgroundContextSaveNotifiation = [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:self.backgroundContext queue:nil usingBlock:^(NSNotification* note)
                                             {
                                                 NSManagedObjectContext *moc = weakSelf.mainContext;
                                                 if (note.object != moc)
                                                     [moc performBlockAndWait:^(){
                                                         [moc mergeChangesFromContextDidSaveNotification:note];
                                                     }];
                                             }];
}

- (void) saveContextsCompletionBlock:(void (^)(void)) completionBlock
{
    if ([self.backgroundContext hasChanges]) {
        [self.backgroundContext performBlockAndWait:^{
            NSError *error;
            if (![self.backgroundContext save:&error]) {
                [self.backgroundContext reset];
                DLog(@"error saving context %@", error.userInfo);
            }
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock();
                });
            }
        }];
    }else if (completionBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock();
        });
    }
}

- (NSArray *) fetchEntityName:(NSString *) name inContext:(NSManagedObjectContext *) context withPredicate:(NSPredicate *)predicate sortDescriptor:(NSArray *)descriptors{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:descriptors];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"error fetching %@", error.userInfo);
    }
    return fetchedObjects;
}

#pragma mark - Core Data stack

/*
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) mainContext
{
    if (_mainContext != nil) {
        return _mainContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self storeCoordonator];
    if (coordinator != nil) {
        _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_mainContext setPersistentStoreCoordinator: coordinator];
    }
    [self setupNotifications];
    return _mainContext;
}

- (NSManagedObjectContext *) backgroundContext
{
    if (_backgroundContext != nil) {
        return _backgroundContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self storeCoordonator];
    if (coordinator != nil) {
        _backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _backgroundContext.persistentStoreCoordinator = [self storeCoordonator];
    }
    return _backgroundContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@".momd"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:[modelURL path]]) {
        NSURL *defaultStoreURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@".momd"];
        if (defaultStoreURL) {
            [fileManager copyItemAtURL:defaultStoreURL toURL:modelURL error:NULL];
        }
    }
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

/*
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)storeCoordonator
{
    if (_storeCoordonator != nil) {
        return _storeCoordonator;
    }
    
    NSURL *storeURL = [[self cacheIncomingDataFolderPath] URLByAppendingPathComponent:@"PFLiteDataBase.sqlite"];
    DLog(@"database url %@", storeURL);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:[storeURL path]]) {
        NSURL *defaultStoreURL = [[NSBundle mainBundle] URLForResource:@"PFLiteDataBase" withExtension:@"sqlite"];
        if (defaultStoreURL) {
            [fileManager copyItemAtURL:defaultStoreURL toURL:storeURL error:NULL];
        }
    }
    
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
    _storeCoordonator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    NSError *error;
    if (![_storeCoordonator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        DLog(@"Unresolved error %@, %@", error, [error userInfo]);
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        if (![_storeCoordonator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
            abort();
        }
    }
    
    return _storeCoordonator;
}

-(void) deleteDataBase
{
    NSURL *storeURL = [[self cacheIncomingDataFolderPath] URLByAppendingPathComponent:@"PFLiteDataBase.sqlite"];
    NSError *error;
    [_mainContext reset];//to drop pending changes
    //delete the store from the current managedObjectContext
    if ([_storeCoordonator removePersistentStore:[[_storeCoordonator persistentStores] lastObject] error:&error])
    {
        // remove the file containing the data
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
        //recreate the new store
        NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
        NSError *error;
        if (![_storeCoordonator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
            DLog(@"Unresolved error %@, %@", error, [error userInfo]);
            [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
            if (![_storeCoordonator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
                DLog(@"error adding persistent store %@", error.userInfo);
                abort();
            }
        }
    }
}

-(NSURL*) cacheIncomingDataFolderPath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    BOOL isDir;
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory isDirectory:&isDir])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return [NSURL fileURLWithPath:documentsDirectory];
}


@end
