//
//  User.m
//  Luncheon
//
//  Created by Rayser on 17/4/13.
//  Copyright (c) 2013 Rayser. All rights reserved.
//

#import "User.h"
#import "UICKeyChainStore.h"

#define KEYCHAIN_SERVICE @"raydiusUserKeychain"
#define KEYCHAIN_GROUP @"ZJN6979MJ3.raydiusUserKeychainGroup"

@implementation User

+(void)registerWithServerWithDelegate:(id<UserDelegate>)aDelegate {
    
    NSString *authToken = [User currentUserAuthToken];
    
    NSLog(@"authToken :::: authToken %@",authToken);
    NSLog(@"registerWithServerWithDelegate******");
    
    if (nil == authToken) {
        
//        if ([self userKeychainAvailable]) {
//            
//            NSDictionary *userDict = [self userDictFromKeychain];
//            
//            [[NSUserDefaults standardUserDefaults] setObject:[userDict objectForKey:@"username"] forKey:RDUsernameKey];
//            [[NSUserDefaults standardUserDefaults] setObject:[userDict objectForKey:@"auth_token"] forKey:RDAuthTokenKey];
//            [[NSUserDefaults standardUserDefaults] setObject:[userDict objectForKey:@"user_id"] forKey:RDUserIDKey];
//            
//            if(aDelegate)
//                [aDelegate userHasUsernameAndAuthToken];
//            
//            return;
//        }
//        else {
        
            [User checkOrGenerateUUID];
            NSString *APNtoken = [[NSUserDefaults standardUserDefaults] objectForKey:RDDeviceAPNKey];
            NSString *myUDID = [[NSUserDefaults standardUserDefaults] objectForKey:RDDeviceUDIDKey];
            NSMutableDictionary *queryInfo = [[NSMutableDictionary alloc] init];
            
            if (nil == APNtoken) {
                [queryInfo setObject: myUDID forKey:@"device_id"];
            }
            else {
                [queryInfo setObject: myUDID forKey:@"device_id"];
                [queryInfo setObject: APNtoken forKey: @"device_token"];
            }
            NSString *pushToken = [[NSUserDefaults standardUserDefaults] objectForKey:RDDeviceAPNKey];
        
            NSLog(@"USER DEVICE PUSH TOKEN %@",pushToken);
        
        NSString * app_name = @"Socal";
        [queryInfo setObject: app_name forKey:@"app_name"];
        
        
            [[NetworkAPIClient sharedClient] postPath:USER_RAYDIUS_SIGN_IN parameters:queryInfo
                                              success:^(AFHTTPRequestOperation *operation, id theResponse) {
                                                  
                                                  NSDictionary *userDict = [theResponse objectForKey:@"user"];
                                                  NSString *username = [userDict objectForKey:@"username"];
                                                  NSString *authtoken = [userDict objectForKey:@"authentication_token"];
                                                  NSNumber *userId = [userDict objectForKey:@"id"];
                                                  NSNumber *userProfanityCounter = [userDict objectForKey:@"profanity_counter"];
                                                  
//                                                  NSString * avatar = [theResponse objectForKey:@"avatar"];
//                                                  NSLog(@"avatar******1 %@",avatar);
//         
// 
//                                                  [[NSUserDefaults standardUserDefaults] setObject:avatar forKey:@"avatar"];
//                                                  
//                                                  NSNumber *dailyPoints = [userDict objectForKey:@"daily_points"];
//                                                  [[NSUserDefaults standardUserDefaults] setObject:dailyPoints forKey:RDDailyPointKey];
//                                                  
//                                                  NSLog(@"dailyPoints*** %@",dailyPoints);

                                                  NSString* savedEmail= [[NSUserDefaults standardUserDefaults] objectForKey:RDEmailKey];
                                                  if (savedEmail  == nil) {
                                                      savedEmail = @"";
                                                      [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:RDEmailKey];
                                                  }
                                                  if ([savedEmail isEqualToString: @""]) {
                                                      [[NSUserDefaults standardUserDefaults] setObject:username forKey:RDUsernameKey];
                                                      [[NSUserDefaults standardUserDefaults] setObject:authtoken forKey:RDAuthTokenKey];
                                                      [[NSUserDefaults standardUserDefaults] setObject:userId forKey:RDUserIDKey];
                                                                                                        }
                                                  if (userProfanityCounter) {
                                                      
                                                      [[NSUserDefaults standardUserDefaults] setObject:userProfanityCounter forKey:RDUserProfanityCounterKey];
                                                      
                                                      if (userProfanityCounter.intValue > 0) {
                                                          
                                                          NSString *offenceDate = [userDict objectForKey:@"offence_date"];
                                                          // check previous offense date
                                                          [[NSUserDefaults standardUserDefaults] setObject:offenceDate forKey:RDUserOffenceDate];
                                                      }
                                                  }
                                                  
                                                  if(aDelegate)
                                                      [aDelegate userHasUsernameAndAuthToken];
                                              }
                                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                  
                                                  if(aDelegate)
                                                      [aDelegate userUnableToRetrieveUsernameAndAuthToken];
                                                  
                                                NSLog(@"ERROR :::%@",error);
                                              }];
    }
    else {
        if(aDelegate)
            [aDelegate userHasUsernameAndAuthToken];
        
    }
}

+(void)registerWithServerWithSuccessBlock:(void (^)())block1 andFailureBlock:(void (^)())block2 {
    
    NSString *authToken = [User currentUserAuthToken];
    
    NSLog(@"registerWithServerWithSuccessBlock******");
    if (nil == authToken) {
        
        [User checkOrGenerateUUID];
        NSString *APNtoken = [[NSUserDefaults standardUserDefaults] objectForKey:RDDeviceAPNKey];
        NSString *myUDID = [[NSUserDefaults standardUserDefaults] objectForKey:RDDeviceUDIDKey];
        
        NSMutableDictionary *queryInfo = [[NSMutableDictionary alloc] init];
        
        if (nil == APNtoken) {
            [queryInfo setObject: myUDID forKey:@"device_id"];
        }
        else {
            [queryInfo setObject: myUDID forKey:@"device_id"];
            [queryInfo setObject: APNtoken forKey: @"device_token"];
        }
        
        NSString * app_name = @"Socal";
        [queryInfo setObject: app_name forKey:@"app_name"];
        
        [[NetworkAPIClient sharedClient] postPath:USER_RAYDIUS_SIGN_IN parameters:queryInfo
                                          success:^(AFHTTPRequestOperation *operation, id theResponse) {
                                              
                                              NSDictionary *userDict = [theResponse objectForKey:@"user"];
                                              NSString *username = [userDict objectForKey:@"username"];
                                              NSString *authtoken = [userDict objectForKey:@"authentication_token"];
                                              NSNumber *userId = [userDict objectForKey:@"id"];
                                              NSNumber *userProfanityCounter = [userDict objectForKey:@"profanity_counter"];
                                              
//                                              NSString * avatar = [theResponse objectForKey:@"avatar"];
//                                              
//                                              
//                                              NSLog(@"avatar******2 %@",avatar);
//                                               NSNumber *dailyPoints = [userDict objectForKey:@"daily_points"];
//                                              [[NSUserDefaults standardUserDefaults] setObject:dailyPoints forKey:RDDailyPointKey];
//                                              
//                                              
//                                              [[NSUserDefaults standardUserDefaults] setObject:avatar forKey:@"avatar"];
                                              
                                              NSLog(@"authentication token %@", authtoken);
                                              
                                              NSString* savedEmail= [[NSUserDefaults standardUserDefaults] objectForKey:RDEmailKey];
                                              if (savedEmail  == nil) {
                                                  savedEmail = @"";
                                                  [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:RDEmailKey];
                                              }
                                              if ([savedEmail isEqualToString: @""]) {
                                                  [[NSUserDefaults standardUserDefaults] setObject:username forKey:RDUsernameKey];
                                                  [[NSUserDefaults standardUserDefaults] setObject:authtoken forKey:RDAuthTokenKey];
                                                  [[NSUserDefaults standardUserDefaults] setObject:userId forKey:RDUserIDKey];
                                              }
                                              if (userProfanityCounter) {
                                                  
                                                  [[NSUserDefaults standardUserDefaults] setObject:userProfanityCounter forKey:RDUserProfanityCounterKey];
                                                  
                                                  if (userProfanityCounter.intValue > 0) {
                                                      
                                                      NSString *offenceDate = [userDict objectForKey:@"offence_date"];
                                                      // check previous offense date
                                                      [[NSUserDefaults standardUserDefaults] setObject:offenceDate forKey:RDUserOffenceDate];
                                                  }
                                              }
                                              
                                              block1();

                                          }
                                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              
                                              block2();
                                              
                                              NSLog(@"ERROR :::%@",error);
                                             
                                          }];
    }
    else {
        
    }
}

+(void)registerWithServerUpdatedAPN {
    
    if (nil != [User currentUserAuthToken]) {
        
        NSLog(@"save auth & device id");
        
        NSString *APNtoken = [User currentUserAPNKey];
        NSString *authToken = [User currentUserAuthToken];
        
        
        if (nil != APNtoken) {
            
            NSMutableDictionary *queryInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
            
            [queryInfo setObject: authToken forKey:@"auth_token"];
            [queryInfo setObject: APNtoken forKey: @"device_token"];
            
            [[NetworkAPIClient sharedClient] postPath:USER_REGISTER_APN_TOKEN parameters:queryInfo
                                              success:^(AFHTTPRequestOperation *operation, id theResponse) {
                                                  
                                                  NSNumber* daily_points = [theResponse objectForKey:@"daily_points"];
                                                  [[NSUserDefaults standardUserDefaults] setObject:daily_points forKey:RDDailyPointKey];

                                              }
                                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                  
                                                  NSLog(@"RDUser credential retrieving failed with error: %@", [error description]);
                                              }];
        }
    }
    else {
        NSLog(@"register apn delay 20 seconds");
        
        [self performSelector:@selector(registerWithServerUpdatedAPN) withObject:self afterDelay:10.0];
    }
    
    
    NSLog(@"User currentUserAuthToken %@",[User currentUserAuthToken]);
    
}

+(void)checkOrGenerateUUID {
    
    if (nil == [[NSUserDefaults standardUserDefaults] objectForKey:RDDeviceUDIDKey]) {
        
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        CFStringRef string = CFUUIDCreateString(NULL, theUUID);
        CFRelease(theUUID);
        NSString *myUUID = (__bridge NSString *)string;
        
        [[NSUserDefaults standardUserDefaults] setObject:myUUID forKey:RDDeviceUDIDKey];
        
        CFRelease(string);
    }
}

+(void)currentUserClearFirstRun {
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:RDAppFirstRunKey];
}

+(void)storeToKeychain:(NSDictionary *)userDict {
    
    if (![UICKeyChainStore setString:[userDict objectForKey:@"auth_token"] forKey:@"raydius_authtoken" service:KEYCHAIN_SERVICE accessGroup:KEYCHAIN_GROUP]) {
        NSLog(@"error");
    };
    if (![UICKeyChainStore setString:[userDict objectForKey:@"username"] forKey:@"raydius_username" service:KEYCHAIN_SERVICE accessGroup:KEYCHAIN_GROUP]) {
        NSLog(@"error");
    };
    if (![UICKeyChainStore setString:[[userDict objectForKey:@"user_id"] stringValue] forKey:@"raydius_user_id" service:KEYCHAIN_SERVICE accessGroup:KEYCHAIN_GROUP]) {
        NSLog(@"error");
    };
    
}

+(BOOL)userKeychainAvailable {
 
    NSString *authtoken = [UICKeyChainStore stringForKey:@"raydius_authtoken" service:KEYCHAIN_SERVICE accessGroup:KEYCHAIN_GROUP];
    
    if (authtoken) return YES;
    
    return NO;
}

+(NSDictionary *)userDictFromKeychain {
    
    NSString *authtoken = [UICKeyChainStore stringForKey:@"raydius_authtoken" service:KEYCHAIN_SERVICE accessGroup:KEYCHAIN_GROUP];
    NSString *username = [UICKeyChainStore stringForKey:@"raydius_username" service:KEYCHAIN_SERVICE accessGroup:KEYCHAIN_GROUP];
    NSNumber *user_id = [NSNumber numberWithInt:[[UICKeyChainStore stringForKey:@"raydius_user_id" service:KEYCHAIN_SERVICE accessGroup:KEYCHAIN_GROUP] intValue]];
    
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [userDict setObject:authtoken forKey:@"auth_token"];
    [userDict setObject:username forKey:@"username"];
    [userDict setObject:user_id forKey:@"user_id"];
    
    return userDict;
}

//User Data Retrieval Class Methods (From UserDefaults)



+(NSNumber *)currentUserDailyPoint {
    
    NSNumber *dailyPoint = [[NSUserDefaults standardUserDefaults] objectForKey:RDDailyPointKey];
    return dailyPoint;
}

+(NSString *)currentUserAuthToken {
    
    NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:RDAuthTokenKey];
    
    return authToken;
}

+(NSNumber *)currentUserID {
    
    NSNumber *userId = [[NSUserDefaults standardUserDefaults] objectForKey:RDUserIDKey];
    
    return userId;
}

+(NSString *)currentUsername {
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:RDUsernameKey];
    
    return username;
}

+(NSString *)currentUserAPNKey {
    
    NSString *APNKey = [[NSUserDefaults standardUserDefaults] objectForKey:RDDeviceAPNKey];
    
    return APNKey;
}

+(NSNumber *)currentUserCheckedInPlaceID {
    
    NSNumber *placeID = [[NSUserDefaults standardUserDefaults] objectForKey:RDCheckedInPlaceIDKey];
    
    return placeID;
}

+(NSString *)currentUserCheckedInPlaceName {
    
    NSString *placeName = [[NSUserDefaults standardUserDefaults] objectForKey:RDCheckedInPlaceNameKey];
    
    return placeName;
}

+(NSString *)currentUserCheckedInPlaceAddress {
    
    NSString *placeAddress = [[NSUserDefaults standardUserDefaults] objectForKey:RDCheckedInPlaceAddressKey];
    
    return placeAddress;
}

+(NSNumber*) currentUserProfanityCounter {

    NSNumber *user_profanity_counter = [[NSUserDefaults standardUserDefaults] objectForKey:RDUserProfanityCounterKey];
    return user_profanity_counter;
}

+(NSDate*)currentUserOffenceDate {
    
    NSString *strUserOffenceDate = [[NSUserDefaults standardUserDefaults] objectForKey:RDUserOffenceDate];
    if (!strUserOffenceDate) {
        return nil;
    }
    
    NSDate *user_offence_date = [Helpers dateFromString:strUserOffenceDate];
    return user_offence_date;
}

+(BOOL)currentUserAppFirstRun {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:RDAppFirstRunKey])
        return NO;
    else
        return YES;
}

+(BOOL)currentUserAppCompletedInitialDownload {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:RDCompletedInitialDownloadKey])
        return NO;
    else
        return YES;
}

+(BOOL)currentUserAppCompletedBackgroundDownload {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:RDCompletedBackgroundDownloadKey])
        return NO;
    else
        return YES;
}

+(BOOL)isCurrentUserBeingSuspended {
    
    int profanity_counter = [[User currentUserProfanityCounter] intValue];
    
    if (profanity_counter==0) return NO;
    
    if (profanity_counter%3!=0) return NO;
    
    NSDate *offenceDate = [User currentUserOffenceDate];
    if (!offenceDate) return NO;

    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate: offenceDate];
    if (timeInterval >= 24*60*60) return NO;
    else {
     
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Account Temporarily Suspended" message:@"You have been suspended for 24 hours for violating our terms and conditions. You may still browse but you cannot post. Contact an admin for more information." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        return YES;
    }
}

//Raydius Sign In Sign Up Methods

+(void)signUpWithRaydiusUsingEmail:(NSString *)emailStr password:(NSString *)passStr withCompletionBlock:(void (^)(NSInteger statusCode))block {
    
    NSMutableDictionary *queryInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [queryInfo setObject:emailStr forKey:@"email"];
    [queryInfo setObject:passStr forKey:@"password"];
    [queryInfo setObject:[User currentUserAuthToken] forKey:@"auth_token"];
    
    [[NetworkAPIClient sharedClient] postPath:USER_RAYDIUS_SIGN_UP parameters:queryInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self processSignInUpAPIResponse:responseObject andStatusCode:operation.response.statusCode withCompletionBlock:block];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        id responseObject = nil;
        if ([operation.responseData length] == 0) {
            responseObject = nil;
        } else {
            responseObject = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
//            responseObject = AFJSONDecode(operation.responseData, &error);
        }
        
        [self processSignInUpAPIResponse:responseObject andStatusCode:operation.response.statusCode withCompletionBlock:block];
    }];
}

+(void)signInWithRaydiusUsingEmail:(NSString *)emailStr password:(NSString *)passStr withCompletionBlock:(void (^)(NSInteger statusCode))block {
    
    NSMutableDictionary *queryInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [queryInfo setObject:emailStr forKey:@"email"];
    [queryInfo setObject:passStr forKey:@"password"];
    
    [[NetworkAPIClient sharedClient] postPath:USER_RAYDIUS_SIGN_IN parameters:queryInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self processSignInUpAPIResponse:responseObject andStatusCode:operation.response.statusCode withCompletionBlock:block];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        id responseObject = nil;
        if ([operation.responseData length] == 0) {
            responseObject = nil;
        } else {
            
            responseObject = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
//            responseObject =  AFJSONDecode(operation.responseData, &error);
        }
        
        [self processSignInUpAPIResponse:responseObject andStatusCode:operation.response.statusCode withCompletionBlock:block];
    }];
}

+(void)processSignInUpAPIResponse:(id)responseObject andStatusCode:(NSInteger)statusCode withCompletionBlock:(void (^)(NSInteger statusCode))block {
    
    NSInteger responseStatusCode = statusCode;
    
    NSDictionary *mainDict = nil;
    
    if (statusCode != 400 && ![responseObject objectForKey:@"success"]) {
        mainDict = [responseObject objectForKey:@"user"];
    }
    else {
        mainDict = responseObject;
    }
    
    NSDictionary *userDict = [mainDict objectForKey:@"user"];
    
    if (responseStatusCode == 200) {
        
        int successCode = [[mainDict objectForKey:@"success"] intValue];
        
        NSLog(@"mainDict : %@", mainDict);
        NSLog(@"userDict : %@", userDict);
        NSLog(@"success code: %d", successCode);
        
        NSString *username = [userDict objectForKey:@"username"];
        NSString *authtoken = [userDict objectForKey:@"authentication_token"];
        NSNumber *userId = [userDict objectForKey:@"id"];
        NSNumber *userProfanityCounter = [userDict objectForKey:@"profanity_counter"];
        
        NSString* savedEmail= [[NSUserDefaults standardUserDefaults] objectForKey:RDEmailKey];
        if (savedEmail  == nil) {
            savedEmail = @"";
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:RDEmailKey];
        }
        if ([savedEmail isEqualToString: @""]) {
            [[NSUserDefaults standardUserDefaults] setObject:username forKey:RDUsernameKey];
            [[NSUserDefaults standardUserDefaults] setObject:authtoken forKey:RDAuthTokenKey];
            [[NSUserDefaults standardUserDefaults] setObject:userId forKey:RDUserIDKey];
        }
        if (userProfanityCounter) {
            
            [[NSUserDefaults standardUserDefaults] setObject:userProfanityCounter forKey:RDUserProfanityCounterKey];
            
            if (userProfanityCounter.intValue > 0) {
                
                NSString *offenceDate = [userDict objectForKey:@"offence_date"];
                // check previous offense date
                [[NSUserDefaults standardUserDefaults] setObject:offenceDate forKey:RDUserOffenceDate];
            }
        }
        
        switch (successCode) {
            
            case SIGN_UP_SUCCESSFUL:
                
                [self setRaydiusLogInStatus:YES];
                block(SIGN_UP_SUCCESSFUL);
                break;
                
            case SIGN_IN_SUCCESSFUL:
                
                [self setRaydiusLogInStatus:YES];
                [self registerWithServerUpdatedAPN];
                block(SIGN_IN_SUCCESSFUL);
                break;
                
            default:
                break;
        }
    }
    
    if(responseStatusCode == 400) {
        
        NSArray *errCodes = [mainDict objectForKey:@"error"];
        for (id errCode in errCodes) {
            
            int errorCode = [errCode intValue];
            
            switch (errorCode) {
             
                case SIGN_IN_ERROR_EMAIL_DOES_NOT_EXIST:
                    block(SIGN_IN_ERROR_EMAIL_DOES_NOT_EXIST);
                    break;
                    
                case SIGN_IN_ERROR_WRONG_PASSWORD:
                    block(SIGN_IN_ERROR_WRONG_PASSWORD);
                    break;
                    
                default:
                    break;
            }
        }
    }
}

+(void)signOutOfRaydiusWithCompletionBlock:(void (^)(BOOL success))block {
    
    if ([self loggedInToRaydius]) {
        
        [self flushRaydiusUserInfo];
        [self setRaydiusLogInStatus:NO];
        [self registerWithServerWithSuccessBlock:^{
            
            block(YES);
            
        } andFailureBlock:^{
            
            block(NO);
        }];
    }
    else {
        
        //Don't have to sign out? haha
    }
}

//Raydius Login

+(void)setRaydiusLogInStatus:(BOOL)status {
    
    if (status) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:RDLogInStatusKey];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:RDLogInStatusKey];
    }
}

+(BOOL)loggedInToRaydius {
    
    NSNumber *loggedIn = [NSNumber numberWithInt:[[[NSUserDefaults standardUserDefaults] objectForKey:RDLogInStatusKey] intValue]];
    
    if ([loggedIn intValue] == 1) {
        return YES;
    }
    
    return NO;
}

+(void)flushRaydiusUserInfo {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:RDDeviceUDIDKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:RDAuthTokenKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:RDUserIDKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:RDUsernameKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:RDEmailKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:RDDeviceAPNKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:RDCheckedInPlaceIDKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:RDCheckedInPlaceNameKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:RDCheckedInPlaceAddressKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:RDCheckedInPlaceLatitudeKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:RDCheckedInPlaceLongitudeKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:RDPlacesCheckedInExpiryKey];
}

//Facebook Login

+(NSNumber *)currentUserFBUserID {
    
    NSNumber *userid = [[NSUserDefaults standardUserDefaults] objectForKey:FBUserIDKey];
    
    return userid;
}

+(NSString *)currentUserFBUserName {
    
    NSString *fbName = [NSString stringWithString:[[NSUserDefaults standardUserDefaults] objectForKey:FBUsernameKey]];
    
    return fbName;
}

+(NSString *)currentUserFBProfilePicURL {
    
    NSString *fbPicURL = nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:FBUserProfilePicURLKey]) {
        fbPicURL = [NSString stringWithString:[[NSUserDefaults standardUserDefaults] objectForKey:FBUserProfilePicURLKey]];
    }
    
    return fbPicURL;
}

//+(void)retrieveFromDBFBFriendsList {
//
//    [[RDOperations sharedWorkerQueue] addOperationWithBlock:^{
//        [[RDDBControl sharedDBController] dbOpen];
//        fbFriendsList = [[NSArray arrayWithArray:[[RDDBControl sharedDBController] fbFriendsList]] retain];
//        NSLog(@"fbFriendsList retrieved from database.");
//        [[RDDBControl sharedDBController] dbClose];
//    }];
//}

//+(BOOL)userIDIsMyFriend:(NSNumber *)user_id {
//
//    if ([RDUser loggedInToFacebook]) {
//        if (!fbFriendsList) {
//            [RDUser retrieveFromDBFBFriendsList];
//            for (NSDictionary *aFriend in fbFriendsList) {
//                
//                if ([user_id intValue] == [[aFriend objectForKey:@"raydius_id"] intValue]) {
//                    return YES;
//                }
//            }
//        }
//        else {
//            for (NSDictionary *aFriend in fbFriendsList) {
//                
//                if ([user_id intValue] == [[aFriend objectForKey:@"raydius_id"] intValue]) {
//                    return YES;
//                }
//            }
//        }
//    }
//    
//    return NO;
//}

+(void)setFacebookLogInStatus:(BOOL)status {
    
    if (status) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:FBLogInStatusKey];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:FBLogInStatusKey];
    }
}

+(BOOL)loggedInToFacebook {
    
    NSNumber *loggedIn = [NSNumber numberWithInt:[[[NSUserDefaults standardUserDefaults] objectForKey:FBLogInStatusKey] intValue]];
    
    if ([loggedIn intValue] == 1) {
        return YES;
    }
    
    return NO;
}

//#pragma mark Quid limit methods
//
//+(void)dailyQuidUsed:(int)noOfQuidUsed {
//    
//    int remainingDailyQuid = [self remainingDailyQuid];
//    
//    if (remainingDailyQuid > 0) {
//        remainingDailyQuid = remainingDailyQuid-noOfQuidUsed;
//        
//        NSNumber *nRemainingDailyQuid = [[NSNumber alloc] initWithInt:remainingDailyQuid];
//        [[NSUserDefaults standardUserDefaults] setObject:nRemainingDailyQuid forKey:RDRemainingDailyQuidKey];
//    }
//    
//    NSDate *newExpiry = [NSDate date];
//    [[NSUserDefaults standardUserDefaults] setObject:newExpiry forKey:RDDailyQuidExpiryKey];
//}
//
//+(int)remainingDailyQuid {
//    
//
//    int remainingDailyQuid;
//    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:RDDailyPointKey];
//    remainingDailyQuid = [obj intValue] ;
//    
//    NSLog(@"remain daily quid %d", remainingDailyQuid);
//    return remainingDailyQuid;
//    
//}
//
//
//
//+(BOOL)reachedDailyQuidLimit {
//    
//    int remainingDailyQuid = [self remainingDailyQuid];
//    
//    NSDate *current = [NSDate date];
//    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:RDDailyQuidExpiryKey];
//    
//    if (!date) {
//        [[NSUserDefaults standardUserDefaults] setObject:current forKey:RDDailyQuidExpiryKey];
//        remainingDailyQuid = RD_DAILY_QUID_LIMIT;
//        NSNumber *nRemainingDailyQuid = [[NSNumber alloc] initWithInt: remainingDailyQuid];
//        [[NSUserDefaults standardUserDefaults] setObject:nRemainingDailyQuid forKey:RDRemainingDailyQuidKey];
//        return NO;
//    }
//    else {
//        if ([Helpers dayFromDate:current] != [Helpers dayFromDate:date]) {
//            remainingDailyQuid = RD_DAILY_QUID_LIMIT;
//            
//            NSNumber *nRemainingDailyQuid = [[NSNumber alloc] initWithInt:remainingDailyQuid];
//            [[NSUserDefaults standardUserDefaults] setObject:nRemainingDailyQuid forKey:RDRemainingDailyQuidKey];
//            [[NSUserDefaults standardUserDefaults] setObject:current forKey:RDDailyQuidExpiryKey];
//            return NO;
//        }
//        else {
//            if ( remainingDailyQuid > 0 )
//                return NO;
//            else
//                return YES;
//        }
//    }
//}

#pragma mark - Honor Methods

+(void)setPositiveHonorPoints:(int)points {

    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:points] forKey:RDUserPositivePointsKey];
    
}

+(void)setNegativeHonorPoints:(int)points {

    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:points] forKey:RDUserNegativePointsKey];
}

+(void)setHonoredCount:(int)count {

    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:count] forKey:RDUserHonoredCountKey];
}

+(void)setPoints:(int)points {
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:points] forKey:RDUserPointsKey];
}

+(int)getPositiveHonorPoints {

    NSNumber *currentPoints = [[NSUserDefaults standardUserDefaults] objectForKey:RDUserPositivePointsKey];
    if (!currentPoints) {
        [User setPositiveHonorPoints:0];
        return 0;
    }
    return currentPoints.intValue;
}

+(int)getNegativeHonorPoints {

    NSNumber *currentPoints = [[NSUserDefaults standardUserDefaults] objectForKey:RDUserNegativePointsKey];
    if (!currentPoints) {
        [User setNegativeHonorPoints:0];
        return 0;
    }
    return currentPoints.intValue;
}

+(int)getHonoredCount {

    NSNumber *currentCount = [[NSUserDefaults standardUserDefaults] objectForKey:RDUserHonoredCountKey];
    if (!currentCount) {
        [User setHonoredCount:0];
        return 0;
    }
    return currentCount.intValue;
}

+(void)addPositiveHonorPoints:(int)points {

    [self setPositiveHonorPoints: [User getPositiveHonorPoints]+points];
    
//    NSNumber *currentPoints = [[NSUserDefaults standardUserDefaults] objectForKey:RDUserPositivePointsKey];
//    if (currentPoints)
//        [User setPositiveHonorPoints:points+currentPoints.intValue];
//    else
//        [User setPositiveHonorPoints:points];
}

+(void)addNegativeHonorPoints:(int)points {
    
    [self setNegativeHonorPoints: [User getNegativeHonorPoints]+points];
    
//    NSNumber *currentPoints = [[NSUserDefaults standardUserDefaults] objectForKey:RDUserNegativePointsKey];
//    if (currentPoints)
//        [User setNegativeHonorPoints:points+currentPoints.intValue];
//    else
//        [User setNegativeHonorPoints:points];
    
}

+(void)addHonoredCount {
    
    [self setHonoredCount: [User getHonoredCount]+1];
    
//    NSNumber *currentCount = [[NSUserDefaults standardUserDefaults] objectForKey:RDUserHonorCountKey];
//    if (currentCount)
//        [User setHonorCount:currentCount.intValue+1];
//    else
//        [User setHonorCount:1];
}

+(int)getTotalHonorPoints {

    return [User getPositiveHonorPoints] - [User getNegativeHonorPoints];
}

+(int)getPoints {

    NSNumber *points = [[NSUserDefaults standardUserDefaults] objectForKey:RDUserPointsKey];
    if (!points) {
        [User setPoints:0];
        return 0;
    }
    
//    points = [NSNumber numberWithInt:100];
    return points.intValue;
}

//+(BOOL)useTotalAmountOfQuid:(int)totalQuid outFreeQuid:(int*)outFreeQuid outOwnQuid:(int*)outOwnQuid {
//
//    int nOwnQuid = [User getPoints];
//    int nDailyFreeQuid = 0;
//    
//    if (![User reachedDailyQuidLimit]) {
//        nDailyFreeQuid = [User remainingDailyQuid];
//    }
//    
//    int nOwnQuidToUse = 0;
//    int nDailyFreeQuidToUse = 0;
//    
//    if (totalQuid <= nDailyFreeQuid) {
//        nDailyFreeQuidToUse = totalQuid;
//    }
//    else if (nDailyFreeQuid < totalQuid) {
//        
//        nDailyFreeQuidToUse = nDailyFreeQuid;
//        
//        int diff = totalQuid - nDailyFreeQuid;
//        if (nOwnQuid < diff) {
//            return NO;
//        }
//        else {
//            
//            nOwnQuidToUse = diff;
//        }
//    }
//    
//    NSLog(@"*****Before return: no of Daily Free Quid to use : no of Own Quid to use %d %d", nDailyFreeQuidToUse, nOwnQuidToUse);
//    
//    *outFreeQuid = nDailyFreeQuidToUse;
//    *outOwnQuid = nOwnQuidToUse;
//
//    return YES;
//}

@end
