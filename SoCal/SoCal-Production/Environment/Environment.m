//
//  Environment.m
//  Luncheon
//
//  Created by Kale on 19/4/13.
//  Copyright (c) 2013 Rayser. All rights reserved.
//

#import "Environment.h"

@implementation Environment

+(NSString *)App_Key {
    
    return @"89433f46a2f596f3f1c8259e8f262c3e";
}

+(int)CurrentEnvironment {
    
    return PRODUCTION;
}

+(NSString *)BaseHost {
    
    return @"https://h1ve-production.herokuapp.com/";
}

+(NSString *)Rackspace_Images_CDN_BaseURL {
    
    return @"http://cbec2f0c4e77ea508a75-051ad4274f767d2430ba3eee78a801e1.r93.cf1.rackcdn.com/";
}

+(NSString *)Rackspace_Images_Container {
    
    return @"raydius_staging_images";
}

+(NSString *)Rackspace_Place_Images_Container {
    
    return @"raydius_staging_place_images";
}

+(NSString *)RackSpace_PlaceImages_CDN_BaseURL {
    
    return @"http://9c5992b7705b19ce1658-2d8133df31036da19af4680fb7319419.r17.cf1.rackcdn.com/";
}

+(NSString *)RackSpace_Avatars_Container {
    
    return @"raydius_staging_avatars";
}

+(NSString *)RackSpace_Avatars_CDN_BaseURL {
    
    return @"http://1452b64aeb44c6f8cfca-944c27f9a2e7b99ec9615bcde91d7c43.r95.cf1.rackcdn.com/";
}

+(void)registerAPN {
}

+(NSString *)Pusher_App_ID {
    return @"65760";
}

+(NSString *)Pusher_Key {
    return @"149e787d80733d128022";
}

+(NSString *)Pusher_Secret {
    return @"08febbd6c964685f36da";
}

@end
