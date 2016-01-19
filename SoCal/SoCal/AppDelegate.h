//
//  AppDelegate.h
//  SoCal
//
//  Created by Rayser on 24/1/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainVC.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UserDelegate> {
    
    NSString *currentUsername;
    NSNumber *currentUserID;
    NSString *currentAuthToken;
    NSString *currentPushToken;
}

@property (nonatomic, strong) AFHTTPRequestOperationManager *sharedManager;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainVC *mainVC;

- (void)getAnonymousUserWithCompletionBlock:(void(^)(BOOL completed))completion;

@end
