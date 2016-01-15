//
//  RefreshController+DeviceMethods.m
//  FitMe
//
//  Created by Softheme iMac on 12/28/15.
//  Copyright © 2015 Artem Tkachuk. All rights reserved.
//

#import "RefreshController+DeviceMethods.h"

@implementation RefreshController (DeviceMethods)

-(void) hideStatusBarAnimated:(BOOL) animated {
    CGRect appFrame = [[UIScreen mainScreen] bounds];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    
    [UIView animateWithDuration:0.25 animations:^{
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        UIViewController *rootVC = window.rootViewController;
        UINavigationController *rootNC = rootVC.navigationController;
        
        rootNC.navigationBar.frame = rootNC.navigationBar.bounds;
        window.frame = CGRectMake(0, 0, appFrame.size.width, appFrame.size.height);
        [rootVC setNeedsStatusBarAppearanceUpdate];
    }];
}

@end
