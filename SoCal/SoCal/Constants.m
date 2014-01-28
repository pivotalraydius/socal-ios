//
//  Constants.m
//  Luncheon
//
//  Created by Rayser on 15/4/13.
//  Copyright (c) 2013 Rayser. All rights reserved.
//

#import "Constants.h"

#define KEY_BASE "com.herenow.luncheon."

@implementation Constants

//TOPIC_STATE {
//    DEFAULT         =0,
//    OPENED          =1,
//    IN_PROGRESS     =2,
//    COMPLETED       =3,
//    REJECTED        =4,
//    CLOSED          =5,
//    EXPIRED         =6
//};

//TOPIC_STATE {
//    DEFAULT,
//    OPENED,
//    IN_PROGRESS,
//    COMPLETED,
//    REJECTED,
//    CLOSED,
//    EXPIRED
//};

//Location
NSString * const UserLatitudeKey = @KEY_BASE "UserLatitudeKey";
NSString * const UserLongitudeKey = @KEY_BASE "UserLongitudeKey";

//Device
NSString * const RDDeviceUDIDKey = @KEY_BASE "UniqueIdentifier";
NSString * const RDDeviceAPNKey = @KEY_BASE "DeviceAPNKey";
NSString * const RDAppFirstRunKey = @KEY_BASE "AppFirstRunKey";
NSString * const RDCompletedInitialDownloadKey = @KEY_BASE "CompletedInitialDownloadKey";
NSString * const RDCompletedBackgroundDownloadKey = @KEY_BASE "CompletedBackgroundDownloadKey";
NSString * const RDTopicsChangeHistoryIDKey = @KEY_BASE "TopicsChangeHistoryIDKey";

NSString * const FirstRunGuidesKey = @KEY_BASE "FirstRunGuidesKey";
NSString * const FirstRunGuidesSharingKey = @KEY_BASE "FirstRunGuidesSharingKey";
NSString * const FirstRunGuides2ndViewKey = @KEY_BASE "FirstRunGuides2ndViewKey";
NSString * const FirstRunGuidesMyLunchKey = @KEY_BASE "FirstRunGuidesMyLunchKey";
NSString * const FirstRunGuidesPullUpKey = @KEY_BASE "FirstRunGuidesPullUpKey";
NSString * const UserHasShakenForSuggestionsKey = @KEY_BASE "UserHasShakenForSuggestionsKey";

//User
NSString * const RDUserIDKey = @KEY_BASE "UserIDKey";
NSString * const RDUsernameKey = @KEY_BASE "UsernameKey";
NSString * const RDAuthTokenKey = @KEY_BASE "AuthTokenKey";
NSString * const RDEmailKey = @KEY_BASE "EmailKey";
NSString * const RDUserProfanityCounterKey = @KEY_BASE "UserProfanityCounterKey";
NSString * const RDUserOffenceDate = @KEY_BASE "UserOffenceDate";

NSString * const RDLogInStatusKey = @KEY_BASE "LogInStatusKey";

NSString * const UserLunchBeaconStateKey = @KEY_BASE "UserLunchBeaconStateKey";
NSString * const UserPeersitionStateKey = @KEY_BASE "UserPeersitionStateKey";

NSString * const UserLunchAlarmStateKey = @KEY_BASE "UserLunchAlarmStateKey";
NSString * const UserLunchAlarmStartTimeKey = @KEY_BASE "UserLunchAlarmStartTimeKey";
NSString * const UserLunchAlarmEndTimeKey = @KEY_BASE "UserLunchAlarmEndTimeKey";


//Places Check In
NSString * const RDPlacesCheckedInExpiryKey = @KEY_BASE "PlacesCheckedInExpiryKey";
NSString * const RDCheckedInPlaceIDKey = @KEY_BASE "CheckedInPlaceIDKey";
NSString * const RDCheckedInPlaceNameKey = @KEY_BASE "CheckedInPlaceNameKey";
NSString * const RDCheckedInPlaceAddressKey = @KEY_BASE "CheckedInPlaceAddressKey";
NSString * const RDCheckedInPlaceLatitudeKey = @KEY_BASE "CheckedInPlaceLatitudeKey";
NSString * const RDCheckedInPlaceLongitudeKey = @KEY_BASE "CheckedInPlaceLongitudeKey";

//Rackspace
NSString * const RackSpace_CloudFiles_Username = @"rayser";
NSString * const RackSpace_CloudFiles_API_KEY = @"9008c2d6d784889027ac9568bfd68536";

//Facebook-Linked Account
NSString * const FBUsernameKey = @KEY_BASE "FBUsernameKey";
NSString * const FBUserIDKey = @KEY_BASE "FBUserIDKey";
NSString * const FBUserProfilePicURLKey = @KEY_BASE "UserProfilePicURLKey";
NSString * const FBLogInStatusKey = @KEY_BASE "FBLogInStatusKey";

//Beacons
NSString * const UserVisitedBeaconsKey = @KEY_BASE "UserVisitedBeaconsKey";

//Meal Tag IDs
NSString * const BreakfastTagIDKey = @KEY_BASE "BreakfastTagIDKey";
NSString * const LunchTagIDKey = @KEY_BASE "LunchTagIDKey";
NSString * const DinnerTagIDKey = @KEY_BASE "DinnerTagIDKey";
NSString * const SupperTagIDKey = @KEY_BASE "SupperTagIDKey";

NSString * const RDRemainingDailyQuidKey = @KEY_BASE "RemainingDailyQuid";
NSString * const RDDailyQuidExpiryKey = @KEY_BASE "DailyQuidExpiry";

// honor points
NSString * const RDUserPositivePointsKey = @KEY_BASE "UserPositivePoints";
NSString * const RDUserNegativePointsKey = @KEY_BASE "UserNegativePoints";
NSString * const RDUserHonoredCountKey = @KEY_BASE "UserHonoredCount";

// points
NSString * const RDUserPointsKey =@KEY_BASE "UserPoints";

//Place Types
const int RD_PLACE_RAYDIUS = 0;
const int RD_PLACE_USER = 1;
const int RD_PLACE_VENDOR = 2;
const int RD_PLACE_FACTUAL = 3;
const int RD_PLACE_MRT = 4;
const int RD_PLACE_UNKNOWN = 5;
const int RD_PLACE_PRIVATE = 6;
const int RD_PLACE_PEERSITION = 9;

//Topic Types
const int RD_TOPIC_ALL = -1;
const int RD_TOPIC_NORMAL = 0;
const int RD_TOPIC_IMAGE = 1;
const int RD_TOPIC_AUDIO = 2;
const int RD_TOPIC_VIDEO = 3;
const int RD_TOPIC_RPSGAME = 4;
const int RD_TOPIC_WEBSITE = 5;
const int RD_TOPIC_POLL = 6;
const int RD_TOPIC_LUNCHEON = 7;
const int RD_TOPIC_FAVR = 8;

//Topic Special Types
const int RD_SPECIAL_FLARE = 1;
const int RD_SPECIAL_BEACON = 2;
const int RD_SPECIAL_STICKY = 3;
const int RD_SPECIAL_PROMO = 4;
const int RD_SPECIAL_COSHOOT = 5;
const int RD_SPECIAL_QUESTION = 6;
const int RD_SPECIAL_ERRAND = 7;


//Post Types
const int RD_POST_TEXT = 0;
const int RD_POST_IMAGE = 1;
const int RD_POST_AUDIO = 2;
const int RD_POST_VIDEO = 3;

//Meal Types
const int DIET_TIME         = 0; // not using
const int BREAKFAST_TIME    = 1;
const int LUNCH_TIME        = 2;
const int DINNER_TIME       = 3;
const int SUPPER_TIME       = 4;

//Post Content Width
const float POST_CONTENT_WIDTH = 260;

//gallery modes
const int GALLERY_MODE = 0;
const int MYLUNCHBOX_MODE = 1;

//mylunchbox modes
const int MYLUNCHBOX_MODE_NORMAL = 0;
const int MYLUNCHBOX_MODE_DRAFT = 1;
const int MYLUNCHBOX_MODE_SKIPPED = 2;

const int DRAFT_LIFE_SPAN = 30;

const int RD_DAILY_QUID_LIMIT = 2;


//capitalize ignore words
NSString * const arrayOfWordsToIgnoreCaps[] = {
    @"a",
    @"an",
    @"and",
    @"at",
    @"in",
    @"into",
    @"of",
    @"on",
    @"onto",
    @"the",
    @"to",
    @"with" };
const int ARRAY_OF_WORDS_IGNORE_CAPS_COUNT = 12;

@end
