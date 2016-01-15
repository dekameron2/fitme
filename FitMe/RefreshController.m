//
//  RefreshController.m
//  FitMe
//
//  Created by Softheme iMac on 12/4/15.
//  Copyright © 2015 Artem Tkachuk. All rights reserved.
//

#import "RefreshController.h"
#import "NewsViewController.h"
#import "UIStoryboard+FitMe.h"
#import "CoreDataController+UserMethods.h"

@interface RefreshController ()

@end



@implementation RefreshController

+(RefreshController *) sharedController {
    
    static RefreshController *_refreshController = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        _refreshController = [[RefreshController alloc] init];
        _refreshController.loginController = [[LoginController alloc] init];
        _refreshController.coreDataController = [[CoreDataController alloc] init];
    });
    
    return _refreshController;
}

- (void) loadMainScreenWithCompletionBlock:(void (^)(void)) completionBlock
{
    self.loadedLoginController = NO;
    CoreDataController *coredataController = [[CoreDataController alloc] init];
    self.coreDataController = coredataController;
    UIStoryboard *sb = [UIStoryboard mainStoryboard];
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    UINavigationController *rootController = [sb instantiateInitialViewController];
    NewsViewController *homeController = (NewsViewController *)rootController.topViewController;
    homeController.user = self.currentUser;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    if (window.rootViewController) {
        [UIView transitionFromView:window.rootViewController.view
                            toView:rootController.view
                          duration:kPFRootLoadAnimationDuration
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        completion:^(BOOL finished){
                            window.rootViewController = rootController;
                            if (completionBlock) {
                                completionBlock();
                            }
                        }];
    }
    else{
        [window setRootViewController:rootController];
    }
}

- (void) loadLoginscreen
{
    if (self.loadedLoginController) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self.coreDataController.backgroundContext performBlock:^{
        RefreshController *strongSelf = weakSelf;
        [strongSelf.coreDataController deleteDataBase];
        strongSelf.coreDataController = nil;
    }];
    
    UIStoryboard *loginSB = [UIStoryboard loginStoryboard];
    UINavigationController *rootController = [loginSB instantiateInitialViewController];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.rootViewController) {
        [UIView transitionFromView:window.rootViewController.view
                            toView:rootController.view
                          duration:kPFRootLoadAnimationDuration
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        completion:^(BOOL finished){
                            window.rootViewController = rootController;
                        }];
    }
    else{
        [window setRootViewController:rootController];
    }
    self.loadedLoginController = YES;
}

- (void) initialScreen{
    
    if ([self loggedIn]) {
        [self setCurrentUserWithUser:(User *)[self.coreDataController fetchOrCreateUserWithID:[[[NSUserDefaults standardUserDefaults] valueForKey:kCurrentUserID] stringValue] inContext:self.coreDataController.backgroundContext]];
        [self loadMainScreenWithCompletionBlock:nil];
    }else{
        [self loadLoginscreen];
    }
}

- (BOOL) loggedIn
{
    BOOL loggedIn = NO;
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserID];
    
    if (userID) {
        loggedIn = YES;
    }
    
    return loggedIn;
}


- (void) setCurrentUserWithUser:(User *) user {
    if (!self.currentUser) {
        self.currentUser = [[CurrentUser alloc] initWithUser:user];
    }else{
        [self.currentUser updateWithUser:user];
    }
}

@end
