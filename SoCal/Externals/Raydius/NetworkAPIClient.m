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
    return __sharedClient;
}

+(id)sharedStagingClient {
    static NetworkAPIClient *__sharedStagingClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedStagingClient = [[NetworkAPIClient alloc] initWithBaseURL:[NSURL URLWithString:[Environment StagingHost]]];
    });
    return __sharedStagingClient;
}

-(id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    }
    
    return self;
}

-(void)cancelHTTPOperationWithPath:(NSString *)path {
    
    [super cancelAllHTTPOperationsWithMethod:@"POST" path:path];
    [NSObject cancelPreviousPerformRequestsWithTarget:nil selector:@selector(postPath:parameters:success:failure:) object:self];
}

@end
