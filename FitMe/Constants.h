//
//  Constants.h
//  FitMe
//
//  Created by Softheme iMac on 12/1/15.
//  Copyright © 2015 Artem Tkachuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define PF_ERROR_LOCALIZED_DESCRIPTION(error)  error.userInfo[NSLocalizedDescriptionKey]
#define PF_ERROR(description) description ? [[NSError alloc] initWithDomain:kApiUrlString code:0 userInfo:@{@"NSLocalizedDescription":description}] : nil
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define REQUIRES_NUMBER_VALIDATION (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && [[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString: @"tel://"]])
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

static CGFloat kPFRootLoadAnimationDuration = 0.65;
static NSUInteger kPFSecondsInDay = 86400;

extern NSString *const kWelcomeStoryboardIdentifier;
extern NSString *const kRegisterStoryboardIdentifier;
extern NSString *const kLoginStoryboardIdentifier;
extern NSString *const kApiUrlString;
extern NSString * const ReachabilityChangeConnected;
extern NSString * const ReachabilityChangeDisconnected;
extern NSString * const kCurrentUserID;
extern NSString * const LogOutNotification;
extern NSString * const kMainStoryboard;

