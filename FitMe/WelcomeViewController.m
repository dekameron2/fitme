//
//  WelcomeViewController.m
//  FitMe
//
//  Created by Softheme iMac on 11/13/15.
//  Copyright © 2015 Artem Tkachuk. All rights reserved.
//

#import "WelcomeViewController.h"
#import "UIStoryboard+FitMe.h"
#import "RegistrationViewController.h"
#import "LoginViewController.h"


@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didSignUpPressed:(id)sender {
    
    RegistrationViewController *registrationVC = [[UIStoryboard registrationStoryboard] instantiateViewControllerWithIdentifier:[RegistrationViewController description]];
    
    [self.navigationController pushViewController:registrationVC animated:YES];
}

- (IBAction)didLoginPressed:(id)sender {
    LoginViewController *loginVC = [[UIStoryboard loginStoryboard] instantiateViewControllerWithIdentifier:[LoginViewController description]];
    
    [self.navigationController pushViewController:loginVC animated:YES];
}

@end
