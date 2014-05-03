//
//  CPQuestionManager.m
//  Codeplay
//
//  Created by Daniel Larsson on 2014-05-03.
//  Copyright (c) 2014 Codeplay. All rights reserved.
//

#import "CPQuestionManager.h"
#import <RestKit/RestKit.h>

@implementation CPQuestionManager

+ (id)sharedManager
{
    static CPQuestionManager *sharedInstance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance = [CPQuestionManager alloc];
        sharedInstance = [sharedInstance init];
        RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@""]];
        objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
    });
    
    return sharedInstance;
}

- (void)doStuff
{
    NSArray *firstSongs = [NSArray arrayWithObjects: @"spotify:track:3G6hD9B2ZHOsgf4WfNu7X1",@"spotify:track:3G6hD9B2ZHOsgf4WfNu7X1", nil];
    NSDictionary *testData = @{@"player-1": firstSongs};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:testData options:0 error:&error];

    [[[RKObjectManager sharedManager] HTTPClient] postPath:@"http://codeplay-backend.herokuapp.com/game" parameters:testData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"Response is %@", responseObject);

        for (NSString *key in responseObject) {
            NSArray *array = (NSArray *)responseObject[key];
            NSLog(@"Question: %@", [array valueForKey:@"question"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    /*
    [[[RKObjectManager sharedManager] HTTPClient] getPath:@"http://codeplay-backend.herokuapp.com/game" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *first = [responseObject valueForKey:@"images"];
        [self setImageURLBasePath:[first valueForKey:@"base_url"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Något gick fel" message:@"Kunde inte hämta filmer" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }];
    */
}

@end
