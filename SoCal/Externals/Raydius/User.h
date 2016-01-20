//
//  User.h
//  Luncheon
//
//  Created by Rayser on 17/4/13.
//  Copyright (c) 2013 Rayser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

#define SIGN_UP_SUCCESSFUL                  10
#define SIGN_IN_SUCCESSFUL                  20
#define EDIT_SUCCESSFUL                     30
#define FACEBOOK_SUCCESSFUL                 40

#define SIGN_UP_ERROR_EMAIL_EXISTS          11
#define SIGN_IN_ERROR_EMAIL_DOES_NOT_EXIST  21
#define SIGN_IN_ERROR_WRONG_PASSWORD        22
#define EDIT_ERROR_EMAIL_EXIISTS            31
#define EDIT_ERROR_USERNAME_EXISTS          32
#define EDIT_ERROR_USERNAME_INAPPROPRIATE   33
#define SIGN_IN_ERROR_FB_WRONG_R_ACCT       41

@protocol UserDelegate;

@interface User : NSObject
{
    id<UserDelegate> delegate;
    
    int positiveHonor;
    int negativeHonor;
    int honorTimes;
    int points;
}

+(void)registerWithServerWithDelegate:(id<UserDelegate>)aDelegate;
+(void)registerWithServerWithSuccessBlock:(void (^)())block1 andFailureBlock:(void (^)())block2;
+(void)registerWithServerUpdatedAPN;
+(void)currentUserClearFirstRun;

//User Data Retrieval Class Methods (From UserDefaults)

+(NSString *)currentUserAuthToken;
+(NSNumber *)currentUserID;
+(NSString *)currentUsername;
+(NSString *)currentUserAPNKey;
+(NSNumber *)currentUserCheckedInPlaceID;
+(NSString *)currentUserCheckedInPlaceName;
+(NSString *)currentUserCheckedInPlaceAddress;

+(BOOL)currentUserAppFirstRun;
+(BOOL)currentUserAppCompletedInitialDownload;
+(BOOL)currentUserAppCompletedBackgroundDownload;

//Raydius Login

+(void)signUpWithRaydiusUsingEmail:(NSString *)emailStr password:(NSString *)passStr withCompletionBlock:(void (^)(NSInteger statusCode))block;
+(void)signInWithRaydiusUsingEmail:(NSString *)emailStr password:(NSString *)passStr withCompletionBlock:(void (^)(NSInteger statusCode))block;

+(void)signOutOfRaydiusWithCompletionBlock:(void (^)(BOOL success))block;

+(void)setRaydiusLogInStatus:(BOOL)status;
+(BOOL)loggedInToRaydius;
+(void)flushRaydiusUserInfo;

+(NSNumber *)currentUserFBUserID;
+(NSString *)currentUserFBUserName;
+(NSString *)currentUserFBProfilePicURL;
+(void)setFacebookLogInStatus:(BOOL)status;
+(BOOL)loggedInToFacebook;

#pragma mark - Honor Methods
+(void)setPositiveHonorPoints:(int)points;
+(void)setNegativeHonorPoints:(int)points;
+(void)setHonoredCount:(int)count;
+(void)setPoints:(int)points;
+(void)addPositiveHonorPoints:(int)points;
+(void)addNegativeHonorPoints:(int)points;
+(void)addHonoredCount;
+(int)getPositiveHonorPoints;
+(int)getNegativeHonorPoints;
+(int)getHonoredCount;
+(int)getTotalHonorPoints;
+(int)getPoints;

//+(BOOL)useTotalAmountOfQuid:(int)totalQuid outFreeQuid:(int*)outFreeQuid outOwnQuid:(int*)outOwnQuid;

@end

@protocol UserDelegate <NSObject>

-(void)userHasUsernameAndAuthToken;
-(void)userUnableToRetrieveUsernameAndAuthToken;

@end
