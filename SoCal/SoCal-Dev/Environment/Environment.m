//
//  Environment.m
//  Luncheon
//
//  Created by Kale on 19/4/13.
//  Copyright (c) 2013 Rayser. All rights reserved.
//

#import "Environment.h"

@implementation Environment

+(int)CurrentEnvironment {
    
    return DEVELOPMENT;
}

+(NSString *)BaseHost {
    
    return @"http://mfalcon.local:5000/";
//    return @"http://localhost:5000/";
}

+(NSString *)StagingHost {
    
    return @"https://raydius-staging.herokuapp.com/";
}

+(NSString *)Rackspace_Images_CDN_BaseURL {
    
    return @"http://3065cbd42358ac65f2d4-e265b11a02ec41d6e2e50f4fb75e3eb1.r97.cf1.rackcdn.com/";
}

+(NSString *)Rackspace_Images_Container {
    
    return @"raydius_dev_images";
}

+(NSString *)Rackspace_Place_Images_Container {
    
    return @"raydius_dev_place_images";
}

+(NSString *)RackSpace_PlaceImages_CDN_BaseURL {
    
    return @"http://4276a6e89bd1f7f33c73-756942a364a72d309fa745e70fac1ce4.r0.cf1.rackcdn.com/";
}

+(NSString *)RackSpace_Avatars_Container {
    
    return @"raydius_dev_avatars";
}

+(NSString *)RackSpace_Avatars_CDN_BaseURL {
    
    return @"https://ca7f4351facb1c8b333d-84b48088cb4e0b523f14d8b78cb0d538.ssl.cf1.rackcdn.com/";
}

+(void)registerAPN {
}

+(NSString *)Pusher_App_ID {
    return @"65761";
}

+(NSString *)Pusher_Key {
    return @"8197ab8e102c7e2ca2eb";
}

+(NSString *)Pusher_Secret {
    return @"e58e48596fbe758eb605";
}

+(NSString *)LuncheonAppURLBaseHost {
    return @"luncheonDevelopment://";
}

@end
