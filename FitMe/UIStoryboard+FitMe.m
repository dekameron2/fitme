//
//  UIStoryboard+FitMe.m
//  FitMe
//
//  Created by Softheme iMac on 12/1/15.
//  Copyright © 2015 Artem Tkachuk. All rights reserved.
//

#import "UIStoryboard+FitMe.h"

@implementation UIStoryboard (FitMe)

+(UIStoryboard *)welcomeStoryboard {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kWelcomeStoryboardIdentifier bundle:nil];
    
    return storyboard;
}

+(UIStoryboard *)loginStoryboard {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kLoginStoryboardIdentifier bundle:nil];
    
    return storyboard;
}

+(UIStoryboard *)registrationStoryboard {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kRegisterStoryboardIdentifier bundle:nil];
    
    return storyboard;
}

+(UIStoryboard *) mainStoryboard {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kMainStoryboard bundle:nil];
    
    return storyboard;
}

@end
