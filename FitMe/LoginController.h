//
//  LoginController.h
//  FitMe
//
//  Created by Softheme iMac on 12/4/15.
//  Copyright © 2015 Artem Tkachuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebApi+UserMethods.h"

@interface LoginController : NSObject

@property (nonatomic) BOOL isLoggedIn;
@property (nonatomic, strong) User *user;

- (instancetype) initWithUser:(User *) user;
- (void) loginWithCredentials:(NSDictionary *) parameters withCompilationBlock:(void (^) (id response, NSError *error)) completionBlock;
- (void) logoutWithCompletion:(void (^)(NSError * error)) completionBlock;
- (void) loginWithLinkedinCompletionBlock:(void (^) (id response, NSError *error)) completionBlock;
- (void) loginWithFacebookWithCompletionBlock:(void (^)(id response, NSError *))completionBlock;
- (void) loginWithGoogleCompletionBlock:(void (^)(id response, NSError *error)) completionBlock;
- (void) disconnectSocialNetworks;
- (void) registerWithCredentials:(NSDictionary *) parameters withCompilationBlock:(void (^) (id response, NSError *error)) completionBlock;

@end
