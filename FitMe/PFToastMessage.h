//
//  PFToastMessage.h
//  Pushfor
//
//  Created by Tanya Karagodova on 5/12/15.
//  Copyright © 2015 Artem Tkachuk. All rights reserved.
//

#import <CRToast.h>

typedef enum{
    PFToastMessageNotificationTypeMessage = 0,
    PFToastMessageNotificationTypeWarning,
    PFToastMessageNotificationTypeError,
    PFToastMessageNotificationTypeSuccess
} PFToastMessageNotificationType;

/** This enum can be passed to the duration parameter */
typedef NS_ENUM(NSInteger,PFToastMessageNotificationDuration) {
    PFToastMessageNotificationDurationAutomatic = 0,
    PFToastMessageNotificationDurationEndless = -1 // The notification is displayed until the user dismissed it or it is dismissed by calling dismissActiveNotification
};


@interface PFToastMessage : CRToastManager
+ (void)showNotificationWithTitle:(NSString *)message type:(PFToastMessageNotificationType)type;
+ (void)showNotificationWithTitle:(NSString *)title subtitle:(NSString *)subtitle type:(PFToastMessageNotificationType)type;
+ (void)showNotificationInViewController:(UIViewController *)viewController title:(NSString *)title subtitle:(NSString *)subtitle type:(PFToastMessageNotificationType)type;
+ (void)showNotificationInViewController:(UIViewController *)viewController title:(NSString *)title subtitle:(NSString *)subtitle type:(PFToastMessageNotificationType)type duration:(NSTimeInterval)duration;
+ (BOOL)dismissActiveNotification;
@end
