//
//  CurrentUser.m
//  FitMe
//
//  Created by Softheme iMac on 12/4/15.
//  Copyright © 2015 Artem Tkachuk. All rights reserved.
//

#import "CurrentUser.h"
#import "User.h"

@implementation CurrentUser

-(instancetype)initWithDictionary:(NSDictionary *) dictionary {
    self = [super init];
    
    self.email = dictionary[@"email"];
    self.firstName = dictionary[@"firstName"];
    self.lastName = dictionary[@"lastName"];
    
    return self;
}

-(void)updateWithDictionary:(NSDictionary *)dictionary {
    self.email = dictionary[@"email"];
    self.firstName = dictionary[@"firstName"];
    self.lastName = dictionary[@"lastName"];
}

-(instancetype)initWithUser:(User *)user {
    self = [super init];
    
    self.email = user.email;
    self.firstName = user.firstName;
    self.lastName = user.lastName;
    
    return self;
}

-(void) updateWithUser:(User *) user {
    self.email = user.email;
    self.firstName = user.firstName;
    self.lastName = user.lastName;
}

@end
