//
//  User+CoreDataProperties.m
//  FitMe
//
//  Created by Softheme iMac on 12/3/15.
//  Copyright © 2015 Artem Tkachuk. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

@dynamic email;
@dynamic firstName;
@dynamic lastName;
@dynamic userId;

-(void)updateWithDictionary:(NSDictionary *)dictionary {
    self.email = dictionary[@"email"];
    self.firstName = dictionary[@"firstName"];
    self.lastName = dictionary[@"lastName"];
    
}

@end
