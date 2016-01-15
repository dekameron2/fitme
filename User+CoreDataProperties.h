//
//  User+CoreDataProperties.h
//  FitMe
//
//  Created by Softheme iMac on 12/3/15.
//  Copyright © 2015 Artem Tkachuk. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSString *userId;

-(void) updateWithDictionary:(NSDictionary *) dictionary;

@end

NS_ASSUME_NONNULL_END
