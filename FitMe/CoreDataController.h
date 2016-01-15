//
//  CoreDataController.h
//  FitMe
//
//  Created by Softheme iMac on 12/3/15.
//  Copyright © 2015 Artem Tkachuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "User+CoreDataProperties.h"

typedef enum {
    ObjectSynced = 0,
    ObjectCreated,
    ObjectDeleted,
} ObjectSyncStatus;

@interface CoreDataController : NSObject

@property (nonatomic) NSPersistentStore *store;
@property (nonatomic) NSPersistentStoreCoordinator *storeCoordonator;
@property (nonatomic) NSManagedObjectContext *mainContext;
@property (nonatomic) NSManagedObjectContext *backgroundContext;
@property (nonatomic) NSManagedObjectModel *managedObjectModel;

+ (instancetype) sharedController;
- (NSArray *) fetchEntityName:(NSString *) name inContext:(NSManagedObjectContext *) context withPredicate:(NSPredicate *)predicate sortDescriptor:(NSArray *)descriptors;

#pragma mark - Utilty methods
- (void) saveContextsCompletionBlock:(void (^)(void)) completionBlock;
- (void) deleteDataBase;

@end
