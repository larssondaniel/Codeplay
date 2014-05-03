//
//  CPSpotifyManager.m
//  Codeplay
//
//  Created by Chris Nordqvist on 2014-05-03.
//  Copyright (c) 2014 Codeplay. All rights reserved.
//

#import "CPSpotifyManager.h"
#import <Spotify/Spotify.h>
#import "CPAppDelegate.h"

@interface CPSpotifyManager () <SPTTrackPlayerDelegate>

    @property (nonatomic, strong) SPTTrackPlayer *trackPlayer;
    @property (nonatomic, strong) SPTSession *userSession;

@end



@implementation CPSpotifyManager 

-(id)init{
    
    [self SetUpSpotifyManager];
    
    return self;
}


-(void)SetUpSpotifyManager{

    id plistRep = [[NSUserDefaults standardUserDefaults] valueForKey:kSessionUserDefaultsKey];
	SPTSession *session = [[SPTSession alloc] initWithPropertyListRepresentation:plistRep];
    
	if (session.credential.length > 0) {
		[self enableAudioPlaybackWithSession:session];
	} else {
		SPTAuth *auth = [SPTAuth defaultInstance];
		NSURL *loginURL = [auth loginURLForClientId:kClientId
								declaredRedirectURL:[NSURL URLWithString:kCallbackURL]
											 scopes:@[@"login"]];
        
		double delayInSeconds = 0.1;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			// If you open a URL during application:didFinishLaunchingWithOptions:, you
			// seem to get into a weird state.
			[[UIApplication sharedApplication] openURL:loginURL];
		});
	}

}

-(void)enableAudioPlaybackWithSession:(SPTSession *)session {
	[self handleNewSession:session];
}


-(void)handleNewSession:(SPTSession *)session {
    
	if (self.trackPlayer == nil) {
        
		self.trackPlayer = [[SPTTrackPlayer alloc] initWithCompanyName:@"Spotify"
															   appName:@"SimplePlayer"];
		self.trackPlayer.delegate = self;
	}
    
	[self.trackPlayer enablePlaybackWithSession:session callback:^(NSError *error) {
        
		if (error != nil) {
			NSLog(@"*** Enabling playback got error: %@", error);
			return;
		}
        
        _userSession = session;
        
	}];
    
}


-(void)playTrackFromSpotify:(NSString *)spotifyUri{
    
    // @"spotify:album:2mCuMNdJkoyiXFhsQCLLqw" - Rick
    
    [SPTRequest requestItemAtURI:[NSURL URLWithString:spotifyUri]
                     withSession:nil
                        callback:^(NSError *error, id object) {
                            
                            if (error != nil) {
                                NSLog(@"*** Album lookup got error %@", error);
                                return;
                            }
                            
                            [self.trackPlayer playTrackProvider:(id <SPTTrackProvider>)object];
                            
                        }];
    
}


#pragma mark - Track Player Delegates

-(void)trackPlayer:(SPTTrackPlayer *)player didStartPlaybackOfTrackAtIndex:(NSInteger)index ofProvider:(id <SPTTrackProvider>)provider {
	NSLog(@"Started playback of track %@ of %@", @(index), provider.uri);
}

-(void)trackPlayer:(SPTTrackPlayer *)player didEndPlaybackOfTrackAtIndex:(NSInteger)index ofProvider:(id<SPTTrackProvider>)provider {
	NSLog(@"Ended playback of track %@ of %@", @(index), provider.uri);
}

-(void)trackPlayer:(SPTTrackPlayer *)player didEndPlaybackOfProvider:(id <SPTTrackProvider>)provider withReason:(SPTPlaybackEndReason)reason {
	NSLog(@"Ended playback of provider %@ with reason %@", provider.uri, @(reason));
}

-(void)trackPlayer:(SPTTrackPlayer *)player didEndPlaybackOfProvider:(id <SPTTrackProvider>)provider withError:(NSError *)error {
	NSLog(@"Ended playback of provider %@ with error %@", provider.uri, error);
}

-(void)trackPlayer:(SPTTrackPlayer *)player didDidReceiveMessageForEndUser:(NSString *)message {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message from Spotify"
														message:message
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
	[alertView show];
}

@end
