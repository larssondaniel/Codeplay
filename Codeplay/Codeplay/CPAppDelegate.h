//
//  CPAppDelegate.h
//  CodePlay
//
//  Created by Chris Nordqvist on 2014-05-02.
//  Copyright (c) 2014 CodePlay Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPMCManager.h"
#import "CPSpotifyManager.h"


// Please fill in your application's details here and remove this error to run the sample.
static NSString * const kClientId = @"spotify-ios-sdk-beta";
static NSString * const kCallbackURL = @"spotify-ios-sdk-beta://callback";
static NSString * const kSessionUserDefaultsKey = @"SpotifySession";


@interface CPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CPMCManager *mcManager;
@property (strong, nonatomic) CPSpotifyManager *spotifyManager;


@end
