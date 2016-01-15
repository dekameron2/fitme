//
//  WebApi.h
//  FitMe
//
//  Created by Softheme iMac on 12/3/15.
//  Copyright © 2015 Artem Tkachuk. All rights reserved.
//

#import <AFNetworking.h>
#import <Foundation/Foundation.h>
#import "User+CoreDataProperties.h"

@class WebApi;

@interface WebApi : AFHTTPSessionManager
{
    NSString *baseURLString;
    
}
@property (nonatomic, weak) void (^backgroundSessionCompletionHandler)();


+ (WebApi *) defaultSessionManager;
+ (WebApi *) backgroundSessionManager;
+ (WebApi *) backgroundSessionManagerWithIdentifier:(NSString *) identifier;

#pragma mark - Cache
- (NSString *) cachedDataFilePath :(NSString *) method;
- (NSString*) cacheFullsizeDirectory;
- (void) cleanupCacheFolder: (NSString *) folderPath;

#pragma  mark - Constructors
- (void) postRequestWithPath:(NSString *) path parameters:(NSDictionary *) parameters completionBlock:(void (^)(id responseObject, NSError *error)) completionBlock;

#pragma mark - POST 
- (void) sendRequestWithType:(NSString *) type withPath:(NSString *)path parameters:(NSDictionary *) parameters withSuccess:(void (^) (id response))success  withFailure:(void (^) (NSError *error)) failure;

@end
