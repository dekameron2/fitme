//
//  RegistrationViewController.m
//  FitMe
//
//  Created by Softheme iMac on 12/2/15.
//  Copyright © 2015 Artem Tkachuk. All rights reserved.
//

#import "RegistrationViewController.h"
#import "PFToastMessage.h"
#import "RefreshController+UserMethods.h"

@interface RegistrationViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;

@property (strong, nonatomic) NSMutableDictionary *parametersToRequest;
@property (strong, nonatomic) UITapGestureRecognizer *tap;

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.parametersToRequest = [[NSMutableDictionary alloc] init];
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didViewTapped:)];
    [self.view addGestureRecognizer:self.tap];
    
    [self setUpInterface];
}

-(void) setUpInterface {
    self.emailAddressTextField.delegate = self;
    self.firstNameTextField.delegate = self;
    self.lastNameTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

-(void) didViewTapped:(id) sender {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

-(void) textFieldDidEndEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.emailAddressTextField]) {
        [self.parametersToRequest setValue:textField.text forKey:@"email"];
    }else if ([textField isEqual:self.firstNameTextField]) {
        [self.parametersToRequest setValue:textField.text forKey:@"first_name"];
    }else if ([textField isEqual:self.passwordTextField]) {
        [self.parametersToRequest setValue:textField.text forKey:@"password"];
    }else if ([textField isEqual:self.lastNameTextField]) {
        [self.parametersToRequest setValue:textField.text forKey:@"last_name"];
    }
}

#pragma mark - Actions

- (IBAction)didSignUpPressed:(id)sender {
    [[RefreshController sharedController] registerWithCredentials:self.parametersToRequest withCompilationBlock:^(id response, NSError *error) {
        if (nil != error) {
            [PFToastMessage showNotificationInViewController:self title:error.localizedDescription subtitle:nil type:PFToastMessageNotificationTypeError];
        }
    }];
}

- (IBAction)facebookSignUpPressed:(id)sender {
}

- (IBAction)twitterSignUpPressed:(id)sender {
}

- (IBAction)googleSignUpPressed:(id)sender {
}

@end
