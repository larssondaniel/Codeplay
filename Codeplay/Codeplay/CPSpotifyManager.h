//
//  CPSpotifyManager.h
//  Codeplay
//
//  Created by Chris Nordqvist on 2014-05-03.
//  Copyright (c) 2014 Codeplay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Spotify/Spotify.h>

@interface CPSpotifyManager : NSObject


-(void)enableAudioPlaybackWithSession:(SPTSession *)session;


-(void)playTrackFromSpotify:(NSString *)spotifyUri;

-(void)stopPlayingTrack;


@end
