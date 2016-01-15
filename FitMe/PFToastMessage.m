//
//  PFToastMessage.m
//  Pushfor
//
//  Created by Tanya Karagodova on 5/12/15.
//  Copyright © 2015 Artem Tkachuk. All rights reserved.
//

#import "PFToastMessage.h"

@interface PFToastMessage ()
@property (nonatomic) UINavigationController *placeholderController;
@end
@implementation PFToastMessage

+ (void)showNotificationWithTitle:(NSString *)message type:(PFToastMessageNotificationType)type{
    [PFToastMessage showNotificationWithTitle:message subtitle:nil type:type];
}

+ (BOOL)dismissActiveNotification{
    [CRToastManager dismissNotification:NO];
    return YES;
}

+ (void)showNotificationWithTitle:(NSString *)title subtitle:(NSString *)subtitle type:(PFToastMessageNotificationType)type{
    
    [CRToastManager dismissNotification:NO];
    NSMutableDictionary *options = [@{
                              kCRToastTextKey : title,
                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                              kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeLinear),
                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeLinear),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastTimeIntervalKey : @(2)
                              
                              } mutableCopy];
    switch (type) {
        case  PFToastMessageNotificationTypeError:
        {
            options[kCRToastBackgroundColorKey] = [UIColor colorWithRed:238.0/255 green:45.0/255 blue:86.0/255 alpha:0.9];
        }
            break;
        case PFToastMessageNotificationTypeMessage:
//            options[kCRToastBackgroundColorKey] = [UIColor pf_darkBlue];

            break;
        case PFToastMessageNotificationTypeWarning:
            options[kCRToastBackgroundColorKey] = [UIColor colorWithRed:241.0/255 green:149.0/255 blue:4.0/255 alpha:0.9];

            break;
        case PFToastMessageNotificationTypeSuccess:
            options[kCRToastBackgroundColorKey] = [UIColor colorWithRed:81.0/255 green:217.0/255 blue:100.0/255 alpha:0.9];
            break;
        default:
            break;
    }
    
    if (subtitle.length > 0) {
        options[kCRToastSubtitleTextKey] = subtitle;
    }
    [CRToastManager showNotificationWithOptions:options
                                        completionBlock:^{
                                            NSLog(@"Completed");
                                        }];
    
}


+ (void)showNotificationInViewController:(UIViewController *)viewController title:(NSString *)title subtitle:(NSString *)subtitle type:(PFToastMessageNotificationType)type{
    [self showNotificationWithTitle:title subtitle:subtitle type:type];

}

+ (void)showNotificationInViewController:(UIViewController *)viewController title:(NSString *)title subtitle:(NSString *)subtitle type:(PFToastMessageNotificationType)type duration:(NSTimeInterval)duration{
    
    [self showNotificationWithTitle:title subtitle:subtitle type:type];
}


@end
