//
//  RefreshController.h
//  FitMe
//
//  Created by Softheme iMac on 12/4/15.
//  Copyright © 2015 Artem Tkachuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrentUser.h"
#import "CoreDataController.h"
#import "LoginController.h"

@interface RefreshController : NSObject
@property (nonatomic, strong) CurrentUser *currentUser;
@property (nonatomic, strong) CoreDataController *coreDataController;
@property (nonatomic, strong) LoginController *loginController;
@property (nonatomic) BOOL loadedLoginController;

+(RefreshController *) sharedController;

- (void) loadMainScreenWithCompletionBlock:(void (^)(void)) completionBlock;
- (void) loadLoginscreen;
- (void) initialScreen;
- (void) setCurrentUserWithUser:(User *) user;

@end
