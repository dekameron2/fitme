//
//  CurrentUser.h
//  FitMe
//
//  Created by Softheme iMac on 12/4/15.
//  Copyright © 2015 Artem Tkachuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface CurrentUser : NSObject

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *userId;

-(instancetype)initWithDictionary:(NSDictionary *) dictionary;
-(instancetype) initWithUser:(User *) user;
-(void) updateWithDictionary:(NSDictionary *) dictionary;
-(void) updateWithUser:(User *) user;


@end
