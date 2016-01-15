//
//  RefreshController+UserMethods.h
//  FitMe
//
//  Created by Softheme iMac on 12/4/15.
//  Copyright © 2015 Artem Tkachuk. All rights reserved.
//

#import "RefreshController.h"
#import "User+CoreDataProperties.h"
#import "CoreDataController+UserMethods.h"

@interface RefreshController (UserMethods)

- (void) loginWithCredentials:(NSDictionary *) parameters withCompilationBlock:(void (^) (id response, NSError *error)) completionBlock;
- (void) registerWithCredentials:(NSDictionary *) parameters withCompilationBlock:(void (^) (id response, NSError *error)) completionBlock;
//- (void) getUserProfileCompletionBlock:(void (^) (NSError *error))completionBlock;
- (void) getCurrentUser;


@end
