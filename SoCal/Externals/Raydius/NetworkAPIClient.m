//
//  NetworkAPIClient.m
//  RaydiusMobile
//
//  Created by Rayser on 19/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NetworkAPIClient.h"

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

-(id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        
        AFJSONResponseSerializer *serializer = [[AFJSONResponseSerializer alloc] init];
        [self setResponseSerializer:serializer];
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

@end
