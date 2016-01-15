//
//  LoginViewController.m
//  FitMe
//
//  Created by Softheme iMac on 12/4/15.
//  Copyright © 2015 Artem Tkachuk. All rights reserved.
//

#import "LoginViewController.h"
#import "RefreshController+UserMethods.h"
#import "PFToastMessage.h"

@interface LoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) NSMutableDictionary *parametersToRequest;
@property (strong, nonatomic) UITapGestureRecognizer *tap;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.parametersToRequest = [[NSMutableDictionary alloc] init];
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didViewTapped:)];
    [self.view addGestureRecognizer:self.tap];
    
    [self setUpInterface];
}

-(void) didViewTapped:(id) sender {
    [self.view endEditing:YES];
}

-(void) setUpInterface {
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

#pragma mark - UITextFieldDelegate

-(void) textFieldDidEndEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.emailTextField]) {
        [self.parametersToRequest setValue:textField.text forKey:@"email"];
    }else if ([textField isEqual:self.passwordTextField]) {
        [self.parametersToRequest setValue:textField.text forKey:@"password"];
    }
}

- (IBAction)didLoginWasPressed:(id)sender {
    if (self.emailTextField.text.length == 0) {
        [PFToastMessage showNotificationInViewController:self title:@"Email is missing" subtitle:nil type:PFToastMessageNotificationTypeError];
        return;
    }else if (self.passwordTextField.text.length == 0) {
        [PFToastMessage showNotificationInViewController:self title:@"Password is missing" subtitle:nil type:PFToastMessageNotificationTypeError];
        return;
    }
    
    [[RefreshController sharedController] loginWithCredentials:self.parametersToRequest withCompilationBlock:^(id response, NSError *error) {
        if (nil != error) {
            [PFToastMessage showNotificationInViewController:self title:error.localizedDescription subtitle:nil type:PFToastMessageNotificationTypeError];
        }
    }];
}

@end
