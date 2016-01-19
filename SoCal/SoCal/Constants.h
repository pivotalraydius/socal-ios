//
//  Constants.h
//  Luncheon
//
//  Created by Rayser on 15/4/13.
//  Copyright (c) 2013 Rayser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

//Location
extern NSString * const UserLatitudeKey;
extern NSString * const UserLongitudeKey;

//Device
extern NSString * const RDDeviceUDIDKey;
extern NSString * const RDDeviceAPNKey;
extern NSString * const RDAppFirstRunKey;
extern NSString * const RDCompletedInitialDownloadKey;
extern NSString * const RDCompletedBackgroundDownloadKey;
extern NSString * const RDTopicsChangeHistoryIDKey;

extern NSString * const FirstRunGuidesKey;
extern NSString * const FirstRunGuidesSharingKey;
extern NSString * const FirstRunGuides2ndViewKey;
extern NSString * const FirstRunGuidesMyLunchKey;
extern NSString * const FirstRunGuidesPullUpKey;
extern NSString * const UserHasShakenForSuggestionsKey;

//User
extern NSString * const RDUserIDKey;
extern NSString * const RDDailyPointKey;
extern NSString * const RDUsernameKey;
extern NSString * const RDAuthTokenKey;
extern NSString * const RDEmailKey;
extern NSString * const RDUserProfanityCounterKey;
extern NSString * const RDUserOffenceDate;

extern NSString * const RDLogInStatusKey;

extern NSString * const UserLunchBeaconStateKey;
extern NSString * const UserPeersitionStateKey;

extern NSString * const UserLunchAlarmStateKey;
extern NSString * const UserLunchAlarmStartTimeKey;
extern NSString * const UserLunchAlarmEndTimeKey;

//Places Check In
extern NSString * const RDPlacesCheckedInExpiryKey;
extern NSString * const RDCheckedInPlaceIDKey;
extern NSString * const RDCheckedInPlaceNameKey;
extern NSString * const RDCheckedInPlaceAddressKey;
extern NSString * const RDCheckedInPlaceLatitudeKey;
extern NSString * const RDCheckedInPlaceLongitudeKey;

//Facebook-Linked Account
extern NSString * const FBUsernameKey;
extern NSString * const FBUserIDKey;
extern NSString * const FBUserProfilePicURLKey;
extern NSString * const FBLogInStatusKey;

//Beacons
extern NSString * const UserVisitedBeaconsKey;

//Meal Tag IDs
extern NSString * const BreakfastTagIDKey;
extern NSString * const LunchTagIDKey;
extern NSString * const DinnerTagIDKey;
extern NSString * const SupperTagIDKey;

//Place Types
extern const int RD_PLACE_RAYDIUS;
extern const int RD_PLACE_USER;
extern const int RD_PLACE_VENDOR;
extern const int RD_PLACE_FACTUAL;
extern const int RD_PLACE_MRT;
extern const int RD_PLACE_UNKNOWN;
extern const int RD_PLACE_PRIVATE;
extern const int RD_PLACE_PEERSITION;

//Topic Types
extern const int RD_TOPIC_ALL;
extern const int RD_TOPIC_NORMAL;
extern const int RD_TOPIC_IMAGE;
extern const int RD_TOPIC_AUDIO;
extern const int RD_TOPIC_VIDEO;
extern const int RD_TOPIC_RPSGAME;
extern const int RD_TOPIC_WEBSITE;
extern const int RD_TOPIC_POLL;
extern const int RD_TOPIC_LUNCHEON;
extern const int RD_TOPIC_FAVR;

//Topic Special Types
extern const int RD_SPECIAL_FLARE;
extern const int RD_SPECIAL_BEACON;
extern const int RD_SPECIAL_STICKY;
extern const int RD_SPECIAL_PROMO;
extern const int RD_SPECIAL_COSHOOT;
extern const int RD_SPECIAL_QUESTION;
extern const int RD_SPECIAL_ERRAND;

//Post Types
extern const int RD_POST_TEXT;
extern const int RD_POST_IMAGE;
extern const int RD_POST_AUDIO;
extern const int RD_POST_VIDEO;

//Meal Types
extern const int DIET_TIME;
extern const int BREAKFAST_TIME;
extern const int LUNCH_TIME;
extern const int DINNER_TIME;
extern const int SUPPER_TIME;


////Favr States ( for Favr )
//typedef enum {
//    TOPIC_STATE_DEFAULT = 0,
//    TOPIC_STATE_OPENED,
//    TOPIC_STATE_IN_PROGRESS,
//    TOPIC_STATE_FINISHED,
//    TOPIC_STATE_ACKNOWLEDGED,
//    TOPIC_STATE_REJECTED,
//    TOPIC_STATE_REVOKED,
//    TOPIC_STATE_TASK_EXPIRED,
//    TOPIC_STATE_EXPIRED
//} TOPIC_STATE;
//
////Favr Actions
//typedef enum {
//    FAVR_ACTION_CREATE = 0,
//    FAVR_ACTION_START,
//    FAVR_ACTION_FINISH,
//    FAVR_ACTION_ACKNOWLEDGE,
//    FAVR_ACTION_REJECT,
//    FAVR_ACTION_REVOKE,
//    FAVR_ACTION_REOPEN,
//    FAVR_ACTION_EXTEND
//} FAVR_ACTION;
//
////Favr Status
//typedef enum {
//    FAVR_STATUS_DEFAULT = 0,
//    FAVR_STATUS_DOER_STARTED,
//    FAVR_STATUS_DOER_FINISHED,
//    FAVR_STATUS_OWNER_ACKNOWLEDGED,
//    FAVR_STATUS_OWNER_REJECTED,
//    FAVR_STATUS_DOER_RESPONDED_ACK,
//    FAVR_STATUS_DOER_RESPONDED_REJ,
//    FAVR_STATUS_OWNER_REVOKED,
//    FAVR_STATUS_COMPLETION_REMINDER_SENT,
//    FAVR_STATUS_EXPIRED_AFTER_STARTED,
//    FAVR_STATUS_EXPIRED_AFTER_FINISHED,
//    FAVR_STATUS_EXPIRED
//} FAVR_STATUS;

//Scroll Direction
typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown
} ScrollDirection;

//Post Content Width
extern const float POST_CONTENT_WIDTH;

//gallery modes
extern const int GALLERY_MODE;
extern const int MYLUNCHBOX_MODE;

//mylunchbox modes
extern const int MYLUNCHBOX_MODE_NORMAL;
extern const int MYLUNCHBOX_MODE_DRAFT;
extern const int MYLUNCHBOX_MODE_SKIPPED;

//DRAFTS
extern const int DRAFT_LIFE_SPAN;

//capitalize ignore words
extern NSString * const arrayOfWordsToIgnoreCaps[];
extern const int ARRAY_OF_WORDS_IGNORE_CAPS_COUNT;

//DAILY QUID COUNTER
extern NSString * const RDRemainingDailyQuidKey;
extern NSString * const RDDailyQuidExpiryKey;
extern const int RD_DAILY_QUID_LIMIT;

//USER HONOR
extern NSString * const RDUserPositivePointsKey;
extern NSString * const RDUserNegativePointsKey;
extern NSString * const RDUserHonoredCountKey;

extern NSString * const RDUserPointsKey;
@end
