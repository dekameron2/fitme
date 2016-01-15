//
//  WebApi.m
//  FitMe
//
//  Created by Softheme iMac on 12/3/15.
//  Copyright © 2015 Artem Tkachuk. All rights reserved.
//

#import "WebApi.h"
#import <AFNetworkActivityIndicatorManager.h>
#import "AppDelegate.h"
#import "Reachability.h"

@interface WebApi ()
@property (nonatomic) NSMutableSet *suspendedTasksArray;
@end

@implementation WebApi

+ (WebApi *) defaultSessionManager
{
    static WebApi *_defaultSessionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _defaultSessionManager = [[WebApi alloc] initWithBaseURL:[NSURL URLWithString:kApiUrlString] sessionConfiguration:configuration];
        
    });
    return _defaultSessionManager;
}

- (id)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration{
    
    if (self = [super initWithBaseURL:url sessionConfiguration:configuration]) {
        self.requestSerializer.timeoutInterval = 20;
        self.suspendedTasksArray = [self loadAndRunSuspendedTasks];
        __weak typeof(self) weakSelf = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(writePendingRequestsToFile) name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserverForName:ReachabilityChangeConnected object:nil queue:nil usingBlock:^(NSNotification *note) {
            [weakSelf.suspendedTasksArray enumerateObjectsUsingBlock:^(NSURLSessionDataTask *task, BOOL *stop) {
                [task resume];
            }];
        }];
    }
    return self;
}

- (void) writePendingRequestsToFile{
    NSString *filePath = [[self cacheIncomingDataFolderPath] stringByAppendingPathComponent:@"suspendedTasks"];
    NSSet *requests = [self.suspendedTasksArray valueForKeyPath:NSStringFromSelector(@selector(originalRequest))];
    if (requests.count > 0) {
        if (![NSKeyedArchiver archiveRootObject:requests toFile:filePath]) {
            DLog(@"Couldn't archive suspended tasks");
        }
    }
}

- (NSMutableSet *) loadAndRunSuspendedTasks{
    NSString *filePath = [[self cacheIncomingDataFolderPath] stringByAppendingPathComponent:@"suspendedTasks"];
    id objects = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    NSMutableSet *tasksSet = [NSMutableSet new];
    if ([objects isKindOfClass:[NSSet class]]) {
        [objects enumerateObjectsUsingBlock:^(NSURLRequest *request, NSUInteger idx, BOOL *stop) {
            NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:nil];
            [tasksSet addObject:task];
        }];
    }
    return tasksSet;
}

+ (WebApi *) backgroundSessionManager
{
    return [WebApi backgroundSessionManagerWithIdentifier:@"com.pushfor.pushfor.backgroundSession"];
}

+ (WebApi *) backgroundSessionManagerWithIdentifier:(NSString *) identifier
{
    static WebApi *_backgroundSessionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identifier];
        _backgroundSessionManager = [[WebApi alloc] initWithBaseURL:[NSURL URLWithString:kApiUrlString] sessionConfiguration:configuration];
        [_backgroundSessionManager configureDownloadFinished];
        [_backgroundSessionManager configureBackgroundSessionFinished];
    });
    return _backgroundSessionManager;
}

- (void)configureDownloadFinished
{
    [self setTaskDidCompleteBlock:^(NSURLSession *session, NSURLSessionTask *task, NSError *error) {
        if (error) {
            NSLog(@"%@: %@", [task.originalRequest.URL lastPathComponent], error);
        }
    }];
}


- (void)configureBackgroundSessionFinished
{
    typeof(self) __weak weakSelf = self;
    [self setDidFinishEventsForBackgroundURLSessionBlock:^(NSURLSession *session) {
        if (weakSelf.backgroundSessionCompletionHandler) {
            weakSelf.backgroundSessionCompletionHandler();
            weakSelf.backgroundSessionCompletionHandler = nil;
        }
    }];
}

#pragma mark - Constructors

- (void)postRequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters completionBlock:(void (^)(id responseObject, NSError *error))completionBlock{
    NSError *serializationError;
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:[[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    
    if (serializationError) {
        if (completionBlock) {
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                completionBlock(nil, serializationError);
            });
        }
        return;
    }
    NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if ([self.suspendedTasksArray containsObject:task]) {
            [self.suspendedTasksArray removeObject:task];
        }
        if ([(NSHTTPURLResponse *)response statusCode] == 401) {
            //logout
            [[NSNotificationCenter defaultCenter] postNotificationName:LogOutNotification object:nil];
        }
        if (completionBlock) {
            completionBlock(responseObject, error);
        }
    }];
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable ) {
        [self.suspendedTasksArray addObject:task];
    }else{
        [task resume];
    }
}

#pragma mark - Cache methods

- (NSString *) cachedDataFilePath :(NSString *) method
{
    NSString *folderPath = [self cacheIncomingDataFolderPath];
    NSString *plistPath = [folderPath stringByAppendingPathComponent:method];
    return plistPath;
}

-(NSString*) cacheIncomingDataFolderPath {
    
    NSArray *paths = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSString *documentsDirectory = [(NSURL *)paths[0] path];
    BOOL isDir;
    NSString *cacheName = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserID];
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:cacheName];
    if(![[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:&isDir])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:nil];
        
    }
    return folderPath;
}

-(NSString*) cacheThumbnailDirectory {
    
    NSString *documentsDirectory = [self cacheIncomingDataFolderPath];
    BOOL isDir;
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:@"ThumbnailSizeImages"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:&isDir])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:nil];
        
    }
    
    return folderPath;
}
- (NSString *) avatarDirectory
{
    NSString *documentsDirectory = [self cacheIncomingDataFolderPath];
    BOOL isDir;
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:@"UserAvatars"];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:&isDir])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:nil];
        
    }
    return folderPath;
}

- (NSString*) cacheFullsizeDirectory {
    
    NSString *documentsDirectory = [self cacheIncomingDataFolderPath];
    BOOL isDir;
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:@"FullSizeImages"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:&isDir])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return folderPath;
}

- (void) cleanupCacheFolder: (NSString *) folderPath
{
    NSURL *folder = [NSURL fileURLWithPath:folderPath isDirectory:YES];
    
    //if the size of folder is greater then 1Gb clean up it to fit this size
    if ([self contentSizeOfDirectoryAtURL:folder] > 1 * 1024 * 1024 * 1024)
    {
        NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtURL:folder includingPropertiesForKeys:@[NSURLAttributeModificationDateKey, NSURLPathKey] options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:NULL];
        
        NSMutableArray *items = [NSMutableArray array];
        id value = nil;
        
        for (NSURL *item in enumerator)
        {
            NSMutableDictionary *fileData = [@{}mutableCopy];
            if([item getResourceValue:&value forKey:NSURLPathKey error:nil])
            {
                NSString *path = value;
                fileData[@"path"] = path;
            }
            if([item getResourceValue:&value forKey:NSURLAttributeModificationDateKey error:nil])
            {
                NSDate *date = value;
                fileData[@"date"] = date;
            }
            [items addObject:fileData];
        }
        
        //sort from oldest to newest files
        NSArray *sorted = [items sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
            NSComparisonResult comp = [obj1[@"date"] compare:
                                       obj2[@"date"]];
            // invert ordering
            if (comp == NSOrderedDescending) {
                comp = NSOrderedAscending;
            }
            else if(comp == NSOrderedAscending){
                comp = NSOrderedDescending;
            }
            return comp;
            
        }];
        
        //delete the oldest file
        [[NSFileManager defaultManager] removeItemAtPath:(sorted.lastObject)[@"path"] error:nil];
    }
}

- (unsigned long long)contentSizeOfDirectoryAtURL:(NSURL *)directoryURL
{
    unsigned long long contentSize = 0;
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtURL:directoryURL includingPropertiesForKeys:@[NSURLFileSizeKey] options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:NULL];
    NSNumber *value = nil;
    for (NSURL *itemURL in enumerator) {
        if ([itemURL getResourceValue:&value forKey:NSURLFileSizeKey error:NULL]) {
            contentSize += value.unsignedLongLongValue;
        }
    }
    return contentSize;
}

- (void) sendRequestWithType:(NSString *) type withPath:(NSString *)path parameters:(NSDictionary *) parameters withSuccess:(void (^) (id response))success  withFailure:(void (^) (NSError *error)) failure {
    
    
    
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kApiUrlString, path]]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10];
    
    [request setHTTPMethod:type];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    if (parameters) {
        NSData *dictData = [NSJSONSerialization dataWithJSONObject:parameters
                                                           options:0
                                                             error:nil];
        [request setHTTPBody:dictData];
    }
    
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Fail with error %@", [error localizedDescription]);
        
        NSError *newError = [self determineError:error];
        
        failure (newError);
    }];
    
    [requestOperation start];

}

- (NSError *) determineError:(NSError *) error {
    NSData *data = [error.userInfo valueForKey:@"com.alamofire.serialization.response.error.data"];
    NSError *error2;
    NSDictionary *dict;
    
    if (data != nil) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error2];
        if ([jsonDict valueForKey:@"error_message"] != nil) {
            dict = @{
                     NSLocalizedDescriptionKey : [jsonDict valueForKey:@"error_message"]
                     };
        }else{
            dict = @{
                     NSLocalizedDescriptionKey : @"Something went wrong"
                     };
        }
    }else{
        dict = @{
                 NSLocalizedDescriptionKey : error.localizedDescription
                 };
    }
    NSError *newError = [NSError errorWithDomain:kApiUrlString code:error.code userInfo:dict];
    
    return newError;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
