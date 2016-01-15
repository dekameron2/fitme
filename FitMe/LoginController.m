//
//  LoginController.m
//  FitMe
//
//  Created by Softheme iMac on 12/4/15.
//  Copyright © 2015 Artem Tkachuk. All rights reserved.
//

#import "LoginController.h"
#import "WebApi+UserMethods.h"

@interface LoginController ()
@property (nonatomic) BOOL silentLogin;
@property (nonatomic, copy) void (^profileCompletionBlock)(id response, NSError *error);
@end

@implementation LoginController

- (instancetype) initWithUser:(User *)user
{
    if (self = [super init]) {
        self.user = user;
    }
    return self;
}
#pragma mark - Login/Logout

- (void) loginWithCredentials:(NSDictionary *) parameters withCompilationBlock:(void (^) (id response, NSError *error)) completionBlock {
    
    [[WebApi defaultSessionManager] loginWithCredentials:parameters withSuccess:^(id response) {
        completionBlock(response, nil);
    } withFailure:^(NSError *error) {
        completionBlock(nil, error);
    }];
}

- (void) registerWithCredentials:(NSDictionary *) parameters withCompilationBlock:(void (^) (id response, NSError *error)) completionBlock {
    [[WebApi defaultSessionManager] registerWithCredentials:parameters withSuccess:^(id response) {
        completionBlock(response, nil);
    } withFailure:^(NSError *error) {
        completionBlock(nil, error);
    }];
}

@end
