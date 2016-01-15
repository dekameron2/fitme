//
//  NewsViewController.h
//  FitMe
//
//  Created by Softheme iMac on 12/22/15.
//  Copyright © 2015 Artem Tkachuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CurrentUser;

@interface NewsViewController : UIViewController

@property (strong, nonatomic) CurrentUser *user;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBarButtonItem;

@end
