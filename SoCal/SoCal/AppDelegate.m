//
//  AppDelegate.m
//  SoCal
//
//  Created by Rayser on 24/1/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import "AppDelegate.h"

static NSString *baseHostURL;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSString *currentBundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *previousBundleVersion = [[NSUserDefaults standardUserDefaults] objectForKey: @"bundle_version"];
    if (previousBundleVersion) {
        if (![previousBundleVersion isEqualToString: currentBundleVersion]) {
            
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            
//            //clear image cache
//            [[RDImageLoader sharedImageLoader] clearWholeImageCache];
            
            //clear keys
            NSArray *array = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys];
            for (NSString *key in array) {
                
                if ([key isEqualToString:RDDeviceUDIDKey] ||
                    [key isEqualToString:RDDeviceAPNKey] ||
                    [key isEqualToString:RDUserIDKey] ||
                    [key isEqualToString:RDUsernameKey] ||
                    [key isEqualToString:RDAuthTokenKey] ||
                    [key isEqualToString:RDEmailKey]) {
                    
                    //don't delete
                }
                else {
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
                }
            }
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:currentBundleVersion forKey:@"bundle_version"];
    
//    NSSetUncaughtExceptionHandler(&exceptionHandler);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.mainVC = [[MainVC alloc] initWithNibName:@"MainVC" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc]  initWithRootViewController:self.mainVC];
    
    [navigationController setNavigationBarHidden:YES];
    
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    
    
    
    
    if (![User currentUserAuthToken]) {
        
        
        [self getAnonymousUserWithCompletionBlock:^(BOOL completed) {
            
            NSLog(@"Getting Anonymous user");
            
        }];
        
    }
    else {
        [self userHasUsernameAndAuthToken];
    }
    
    if ([User currentUserAppFirstRun]) {
        
        NSLog(@"App first run");
        
        [User currentUserClearFirstRun];
    }
    
    
    [Environment registerAPN];

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)userHasUsernameAndAuthToken {
    
    NSLog(@"Retrieved credentials from Raydius");
    
//    [self.mainVC setLblGreetings];
    
//    [MyFavrsController downloadFavrTopicsForUserWithCompletionBlock:^{
//        
//    }];
    
    NSLog(@"User ID: %@", [User currentUserID]);
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([[url absoluteString] hasPrefix:@"socal://open_event?invitation_code="]) {
        
        NSString *inviteCode = [[url absoluteString] stringByReplacingOccurrencesOfString:@"socal://open_event?invitation_code=" withString:@""];
        
        [self.mainVC openEventVC:inviteCode];
        
        return YES;
    }
    
    return NO;
}


#pragma mark - User Methods

- (void)getAnonymousUserWithCompletionBlock:(void(^)(BOOL completed))completion {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:RDAuthTokenKey] != nil) {
        
        currentAuthToken = [[NSUserDefaults standardUserDefaults] objectForKey:RDAuthTokenKey];
        currentUserID = [[NSUserDefaults standardUserDefaults] objectForKey:RDUserIDKey];
        currentUsername = [[NSUserDefaults standardUserDefaults] objectForKey:RDUsernameKey];
        currentPushToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"push_token"];
        
        completion(YES);
        
    }
    else {
        
        NSString *uuid = [[NSUUID UUID] UUIDString];
        
        NSDictionary *queryInfo = @{ @"device_id":uuid };
        
        baseHostURL = [Environment BaseHost];
        self.sharedManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:baseHostURL]];
        [self.sharedManager GET:@"api/users/create_anonymous_user" parameters:queryInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"Response obj : %@", responseObject);
            
            NSDictionary *userDict = [responseObject objectForKey:@"user"];
            NSString *userName = [userDict objectForKey:@"username"];
            NSString *authToken = [userDict objectForKey:@"authentication_token"];
            NSNumber *userID = [userDict objectForKey:@"id"];
            
            [[NSUserDefaults standardUserDefaults] setObject:userName forKey:RDUsernameKey];
            [[NSUserDefaults standardUserDefaults] setObject:authToken forKey:RDAuthTokenKey];
            [[NSUserDefaults standardUserDefaults] setObject:userID forKey:RDUserIDKey];
            [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:@"push_token"];
            
            currentAuthToken = [[NSUserDefaults standardUserDefaults] objectForKey:RDAuthTokenKey];
            currentUserID = [[NSUserDefaults standardUserDefaults] objectForKey:RDUserIDKey];
            currentUsername = [[NSUserDefaults standardUserDefaults] objectForKey:RDUsernameKey];
            currentPushToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"push_token"];
            
            completion(YES);
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"Error getting anonymous user account %@",error);
            
            completion(NO);
        }];
    }
    
}


- (void)verifyCurrentUser {
    
    NSDictionary *queryInfo = @{ @"auth_token":[self currentAuthToken], @"push_token":[self currentPushToken] };
    
    [self.sharedManager POST:@"api/users/verify_user_account" parameters:queryInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
}

- (NSString *)currentAuthToken {
    
    if (!currentAuthToken) {
        currentAuthToken = [[NSUserDefaults standardUserDefaults] objectForKey:RDAuthTokenKey];
    }
    
    return currentAuthToken;
}

- (NSString *)currentUsername {
    
    if (!currentUsername) {
        currentUsername = [[NSUserDefaults standardUserDefaults] objectForKey:RDUsernameKey];
    }
    
    return currentUsername;
}

- (NSNumber *)currentUserID {
    
    if (!currentUserID) {
        currentUserID = [[NSUserDefaults standardUserDefaults] objectForKey:RDUserIDKey];
    }
    
    return currentUserID;
}

- (NSString *)currentPushToken {
    
    if (!currentPushToken) {
        currentPushToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"push_notification_token"];
    }
    
    return currentPushToken;
}

@end
