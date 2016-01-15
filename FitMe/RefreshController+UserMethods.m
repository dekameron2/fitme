//
//  RefreshController+UserMethods.m
//  FitMe
//
//  Created by Softheme iMac on 12/4/15.
//  Copyright © 2015 Artem Tkachuk. All rights reserved.
//

#import "RefreshController+UserMethods.h"
#import "CurrentUser.h"

@implementation RefreshController (UserMethods)

- (void) loginWithCredentials:(NSDictionary *) parameters withCompilationBlock:(void (^) (id response, NSError *error)) completionBlock {
    __weak typeof(self) weakSelf = self;
    [self.loginController loginWithCredentials:parameters withCompilationBlock:^(id response, NSError *error) {
        if (!error) {
            [self proceedLoginData:response weakSelf:weakSelf];
        }
        completionBlock(response, error);
    }];
}

- (void) registerWithCredentials:(NSDictionary *) parameters withCompilationBlock:(void (^) (id response, NSError *error)) completionBlock {
    __weak typeof(self) weakSelf = self;
    [self.loginController registerWithCredentials:parameters withCompilationBlock:^(id response, NSError *error) {
        if (!error) {
            [self proceedLoginData:response weakSelf:weakSelf];
        }
        completionBlock(response, error);
    }];
}

- (void)proceedLoginData:(id)response weakSelf:(__weak RefreshController *)weakSelf
{
    if (response[@"userId"]) {
        [[NSUserDefaults standardUserDefaults] setObject:response[@"userId"] forKey:kCurrentUserID];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSManagedObjectContext *context = [weakSelf.coreDataController backgroundContext];
    [context performBlock:^{
        User *user = [weakSelf.coreDataController fetchOrCreateUserWithID:[NSString stringWithFormat:@"%@", response[@"userId"]] inContext:context];
        [user updateWithDictionary:response];
        [weakSelf.coreDataController saveContextsCompletionBlock:nil];
    }];
    
    CurrentUser *user = [[CurrentUser alloc] initWithDictionary:response];
    weakSelf.currentUser = user;
    [weakSelf loadMainScreenWithCompletionBlock:nil];
}

- (void) getCurrentUser {
    
}



@end
