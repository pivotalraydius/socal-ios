//
//  Environment.h
//  Luncheon
//
//  Created by Kale on 19/4/13.
//  Copyright (c) 2013 Rayser. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PRODUCTION  1
#define STAGING     2
#define DEVELOPMENT 3

@interface Environment : NSObject

+(int)CurrentEnvironment;

+(NSString *)App_Key;
+(NSString *)BaseHost;

+(NSString *)Rackspace_Images_CDN_BaseURL;
+(NSString *)Rackspace_Images_Container;
+(NSString *)RackSpace_Avatars_Container;
+(NSString *)RackSpace_Avatars_CDN_BaseURL;

+(void)registerAPN;

+(NSString *)Pusher_App_ID;
+(NSString *)Pusher_Key;
+(NSString *)Pusher_Secret;

+(NSString *)Rackspace_Place_Images_Container;
+(NSString *)RackSpace_PlaceImages_CDN_BaseURL;

@end
