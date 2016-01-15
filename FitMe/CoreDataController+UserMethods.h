//
//  CoreDataController+UserMethods.h
//  FitMe
//
//  Created by Softheme iMac on 12/4/15.
//  Copyright © 2015 Artem Tkachuk. All rights reserved.
//

#import "CoreDataController.h"
#import "User+CoreDataProperties.h"

@interface CoreDataController (UserMethods)

- (User *) fetchOrCreateUserWithID:(NSString *) userID inContext:(NSManagedObjectContext *) context;


@end
