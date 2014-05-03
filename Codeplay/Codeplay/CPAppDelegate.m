//
//  CPAppDelegate.m
//  CodePlay
//
//  Created by Chris Nordqvist on 2014-05-02.
//  Copyright (c) 2014 CodePlay Interactive. All rights reserved.
//

#import "CPAppDelegate.h"



@implementation CPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //Launch Multipeer manager
    _mcManager = [[CPMCManager alloc] init];
    [_mcManager setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    
    //Launch Spotify
    _spotifyManager = [[CPSpotifyManager alloc] init];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
	SPTAuthCallback authCallback = ^(NSError *error, SPTSession *session) {
		// This is the callback that'll be triggered when auth is completed (or fails).
        
		if (error != nil) {
			NSLog(@"*** Auth error: %@", error);
			return;
		}
        
		[[NSUserDefaults standardUserDefaults] setValue:[session propertyListRepresentation]
												 forKey:kSessionUserDefaultsKey];
		[_spotifyManager enableAudioPlaybackWithSession:session];
	};
    
	/*
	 STEP 2: Handle the callback from the authentication service. -[SPAuth -canHandleURL:withDeclaredRedirectURL:]
	 helps us filter out URLs that aren't authentication URLs (i.e., URLs you use elsewhere in your application).
     
	 Make the token swap endpoint URL matches your auth service URL.
	 */
    
	if ([[SPTAuth defaultInstance] canHandleURL:url withDeclaredRedirectURL:[NSURL URLWithString:kCallbackURL]]) {
		[[SPTAuth defaultInstance] handleAuthCallbackWithTriggeredAuthURL:url
											tokenSwapServiceEndpointAtURL:[NSURL URLWithString:@"http://usa.ikennd.ac:1234/swap"]
																 callback:authCallback];
		return YES;
	}
    
	return NO;
}


@end
