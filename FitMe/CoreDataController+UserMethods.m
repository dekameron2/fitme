//
//  CoreDataController+UserMethods.m
//  FitMe
//
//  Created by Softheme iMac on 12/4/15.
//  Copyright © 2015 Artem Tkachuk. All rights reserved.
//

#import "CoreDataController+UserMethods.h"

@implementation CoreDataController (UserMethods)

- (User *) fetchOrCreateUserWithID:(NSString *) userID inContext:(NSManagedObjectContext *) context{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@", userID];
    // Specify how the fetched objects should be sorted
    User *newUser = nil;
    NSArray *fetchedObjects = [self fetchEntityName:NSStringFromClass([User class]) inContext:context withPredicate:predicate sortDescriptor:nil];
    if (fetchedObjects.count == 0) {
        newUser = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([User class]) inManagedObjectContext:context];
        newUser.userId = userID;
    } else if(fetchedObjects.count == 1)
    {
        newUser = fetchedObjects.firstObject;
    } else
    {
        DLog(@"error fetching users: more than 1 fetched");
    }
    
    return newUser;
}

@end
