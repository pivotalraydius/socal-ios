//
//  NetworkAPIClient.h
//  RaydiusMobile
//
//  Created by Rayser on 19/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFNetworking.h"

#define GENERATE_INVITE_CODE                    @"api/socal/retrieve_invitation_code"
#define CREATE_EVENT                            @"api/socal/create_event"
#define RETRIEVE_EVENT                          @"api/socal/retrieve_event"
#define VOTE_FOR_DATE                           @"api/socal/vote_date"
#define SOCAL_CREATE_POST                       @"api/socal/create_post"
#define SOCAL_DOWNLOAD_POSTS                    @"api/socal/download_posts"
#define SOCAL_CREATE_USER                       @"api/socal/create_user"
#define SOCAL_CONFIRM_EVENT                     @"api/socal/topic_state"
#define RETRIEVE_POPULAR_DATE                   @"api/socal/retrieve_popular_date"

#define DOWNLOAD_INITIAL_RETRIEVE               @"api/downloaddata/initial_retrieve"
#define DOWNLOAD_BACKGROUND_RETRIEVE            @"api/downloaddata/background_retrieve"
#define DOWNLOAD_RETRIEVE_HISTORY_CHANGES       @"api/downloaddata/retrieve_history"
#define DOWNLOAD_LATEST_HISTORY_ID              @"api/downloaddata/latest_history"
#define DOWNLOAD_POSTS_INITIAL_RETRIEVE         @"api/downloaddata/posts_retrieve"
#define DOWNLOAD_POSTS__IN_RANGE                @"api/downloaddata/retrieve_posts_in_range"
#define DOWNLOAD_POSTS_SEGMENTED_RETRIEVE       @"api/downloaddata/segmented_posts_retrieve"
#define DOWNLOAD_POSTS_RETRIEVE_HISTORY_CHANGES @"api/downloaddata/retrieve_posts_history"
#define DOWNLOAD_POSTS_SEGMENTED_BY_USER        @"api/downloaddata/posts_retrieve_for_user"

#define TOPIC_CREATE_NEW                        @"api/topics/create"
#define TOPIC_FAVOURITE                         @"api/topics/topic_favourited"
#define TOPIC_OFFENSIVE                         @"api/topics/topic_offensive" // params : topic_id
#define TOPIC_LIKE                              @"api/topics/topic_liked" // params: choice (like/unlike), topic_id
#define FAVR_TOPICS_BY_USER                     @"api/topics/favr_topics_by_user" // params: auth_token
#define FAVR_ACTION                             @"api/topics/favr_action"
#define HONOR_TO_OWNER                          @"api/topics/honor_to_owner"
#define POST_CREATE_NEW                         @"api/posts/create"
#define POST_LIKE                               @"api/posts/post_liked" // params: choice (like/dislike), post_id
#define POST_REPORT_OFFENSIVE                   @"api/posts/post_offensive"
#define USER_BLOCK_USER                         @"api/users/block_user"
#define USER_FAVOURITE_USER                     @"api/users/favourite_user"
#define USER_LOCATION_CHECK_IN                  @"api/users/check_in"
#define USER_REGISTER_APN_TOKEN                 @"api/users/register_apn"
#define USER_RAYDIUS_SIGN_IN                    @"api/users/sign_in"
#define USER_RAYDIUS_SIGN_UP                    @"api/users/sign_up"
#define USER_UPDATE_STATUS                      @"api/users/status"
#define USER_FACEBOOK_RAYDIUS_SIGN_IN           @"api/users/facebook_login"
#define USER_FACEBOOK_RAYDIUS_FRIENDS_RETRIEVE  @"api/users/facebook_friends"
#define USER_REGENERATE_USERNAME                @"api/users/regenerate_username"
#define USER_EDIT_PROFILE                       @"api/users/edit_profile"
#define PLACES_USER_RECENT                      @"api/places/user_recent_places"
#define PLACES_PLACE_INFO                       @"api/places/information"
#define PLACES_PLACE_TOP_USERS                  @"api/places/top_venue_users"
#define PLACES_PLACE_ACTIVE_USERS               @"api/places/currently_active"
#define PLACES_CHECKIN_CREATE_NEW               @"api/places/create_record"

#define PLACES_CHECKIN_SEARCH_NEARBY_PLACES     @"api/places/select_venue"

#define PLACES_WITHIN_LOCATION                  @"api/places/within_location"
#define PLACES_WITHIN_LOCALITY                  @"api/places/within_locality"

#define RPS_GAME_CREATE_NEW                     @"api/spsgames/create_game"
#define RPS_GAME_ANOTHER_GAME                   @"api/spsgames/another_game"
#define RPS_GAME_UPDATE_STATUS                  @"api/spsgames/check_status"
#define RPS_GAME_PLAYER_2_JOIN                  @"api/spsgames/player2_join"
#define RPS_GAME_PLAYER_1_MOVE                  @"api/spsgames/player1_move"
#define RPS_GAME_PLAYER_2_MOVE                  @"api/spsgames/player2_move"
#define SEARCH_DATABASE                         @"api/downloaddata/search_database"
#define SEARCH_TOPICS                           @"api/topics/search"
#define TAGS_WITHIN_LOCATION                    @"api/tags/within_location"
#define RETRIEVE_MEAL_TAGS                      @"api/tags/retrieve_meal_tags"
#define RETRIEVE_USER_TOPIC_RATING              @"api/topics/user_rating"

@interface NetworkAPIClient : AFHTTPRequestOperationManager

+(id)sharedClient;
//+(id)sharedStagingClient;

-(void)cancelHTTPOperationsWithPath:(NSString *)path;

@end
