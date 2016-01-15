//
//  WebApi+UserMethods.m
//  FitMe
//
//  Created by Softheme iMac on 12/3/15.
//  Copyright © 2015 Artem Tkachuk. All rights reserved.
//

#import "WebApi+UserMethods.h"

@implementation WebApi (UserMethods)

-(void) loginWithCredentials:(NSDictionary *) credentials withSuccess:(void (^) (id response))success  withFailure:(void (^) (NSError *error)) failure {
    NSString *email = credentials[@"email"];
    NSString *password = credentials[@"password"];
    NSString *path = [NSString stringWithFormat:@"api/login?email=%@&password=%@",email,password];
    
    [self sendRequestWithType:@"GET" withPath:path parameters:nil withSuccess:^(id response) {
        success(response);
    } withFailure:^(NSError *error) {
        failure(error);
    }];
}

-(void) registerWithCredentials:(NSDictionary *) credentials withSuccess:(void (^) (id response))success  withFailure:(void (^) (NSError *error)) failure {
    
    NSString *pathDocs = [NSString stringWithFormat:@"api/users/registration"];
    NSMutableDictionary *parameters = [credentials mutableCopy];
    
    [self sendRequestWithType:@"POST" withPath:pathDocs parameters:parameters withSuccess:^(id response) {
        success(response);
    } withFailure:^(NSError *error) {
        failure(error);
    }];
    
}

@end
