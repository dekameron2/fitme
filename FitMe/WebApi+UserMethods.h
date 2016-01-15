//
//  WebApi+UserMethods.h
//  FitMe
//
//  Created by Softheme iMac on 12/3/15.
//  Copyright © 2015 Artem Tkachuk. All rights reserved.
//

#import "WebApi.h"


@interface WebApi (UserMethods)

-(void) registerWithCredentials:(NSDictionary *) credentials withSuccess:(void (^) (id response))success  withFailure:(void (^) (NSError *error)) failure;
-(void) loginWithCredentials:(NSDictionary *) credentials withSuccess:(void (^) (id response))success  withFailure:(void (^) (NSError *error)) failure;


@end
