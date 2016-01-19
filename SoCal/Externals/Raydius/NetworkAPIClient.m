//
//  NetworkAPIClient.m
//  RaydiusMobile
//
//  Created by Rayser on 19/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NetworkAPIClient.h"
#import <AFNetworkActivityIndicatorManager.h>

#define NETWORK_RETRY_DURATION 5.0

@implementation NetworkAPIClient

+(id)sharedClient {
    static NetworkAPIClient *__sharedClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedClient = [[NetworkAPIClient alloc] initWithBaseURL:[NSURL URLWithString:[Environment BaseHost]]];
    });
    __sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
    __sharedClient.requestSerializer.HTTPMethodsEncodingParametersInURI =[NSSet setWithArray:@[@"POST", @"GET", @"HEAD"]];
    return __sharedClient;
}

//+(id)sharedStagingClient {
//    static NetworkAPIClient *__sharedStagingClient;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        __sharedStagingClient = [[NetworkAPIClient alloc] initWithBaseURL:[NSURL URLWithString:[Environment StagingHost]]];
//    });
//    return __sharedStagingClient;
//}

//-(id)initWithBaseURL:(NSURL *)url {
//    self = [super initWithBaseURL:url];
//    if (self) {
//        
//        AFJSONResponseSerializer *serializer = [[AFJSONResponseSerializer alloc] init];
//        [self setResponseSerializer:serializer];
//    }
//    
//    return self;
//}

-(id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        
        wasDown = NO;
        AFJSONResponseSerializer *serializer = [[AFJSONResponseSerializer alloc] init];
        [self setResponseSerializer:serializer];
        
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        
        
        [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            
            if (self.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
                
                wasDown = YES;
                
                NSLog(@"Device appears to be offline.");
                
                //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Data Connection"
                //                                                                message:@"Your device appears to be offline. Please check your cell data / Wi-Fi settings."
                //                                                               delegate:nil
                //                                                      cancelButtonTitle:@"OK"
                //                                                      otherButtonTitles:nil];
                //
                //                [alert show];
                //                [alert release];
            }
            
            if (wasDown == YES) {
                
                if (self.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi ||
                    self.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
                    
                    wasDown = NO;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_data" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_chat_data" object:nil];
                }
            }
        }];
        
        [self.reachabilityManager startMonitoring];
    }
    
    return self;
}

-(void)cancelHTTPOperationsWithPath:(NSString *)path {
    
    for (AFHTTPRequestOperation *operation in self.operationQueue.operations) {
        
        if ([Helpers string:operation.request.URL.absoluteString containsString:path]) {
            
            [operation cancel];
        }
    }
}

-(void)postPath:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    
    NSLog(@"*** parameters %ld %ld %ld", (long)self.reachabilityManager.networkReachabilityStatus, (long)AFNetworkReachabilityStatusReachableViaWiFi, (long)AFNetworkReachabilityStatusReachableViaWWAN);
    
    if (self.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi ||
        self.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
        
        NSLog(@"Reachabiliy Manager");
        
        [super POST:path parameters:parameters success:success failure:failure];
    }
    else {
        
        //attempt every 10secs
        //this method checks for networkReachabilityStatus before actually trying to connect to the API
        NSLog(@"attempt every 10secs");
        [self performBlock:^{
            
            [self postPath:path parameters:parameters success:success failure:failure];
            
        } afterDelay:NETWORK_RETRY_DURATION];
    }
}

-(void)getPath:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    
    if (self.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi ||
        self.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
        
        [super GET:path parameters:parameters success:success failure:failure];
    }
    else {
        
        //attempt every 10secs
        //this method checks for networkReachabilityStatus before actually trying to connect to the API
        [self performBlock:^{
            
            [self getPath:path parameters:parameters success:success failure:failure];
            
        } afterDelay:NETWORK_RETRY_DURATION];
    }
}

@end
