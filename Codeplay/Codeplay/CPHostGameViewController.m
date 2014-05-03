//
//  CPHostGameViewController.m
//  Codeplay
//
//  Created by Daniel Larsson on 2014-05-03.
//  Copyright (c) 2014 Codeplay. All rights reserved.
//

#import "CPHostGameViewController.h"
#import "CPAppDelegate.h"
#import "DACircularProgressView.h"

@interface CPHostGameViewController ()

@property (nonatomic, strong) CPAppDelegate *appDelegate;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) DACircularProgressView *progressView;
@property (strong, nonatomic) IBOutlet UIView *buttonsView;

@end

@implementation CPHostGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0.0f, 20.0f, 320.0f, 220.0f)];
    self.progressView.trackTintColor = [UIColor clearColor];
    self.progressView.progressTintColor = [UIColor darkGrayColor];
    self.progressView.alpha = 0.15f;
    self.progressView.thicknessRatio = 1.0f;
    self.progressView.clockwiseProgress = YES;
    [self.view addSubview:self.progressView];
    [self.view bringSubviewToFront:self.buttonsView];
    [self startAnimation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:@"MCDidReceiveDataNotification"
                                               object:nil];
    
}

-(void) viewWillAppear:(BOOL)animated{
    [[[_appDelegate mcManager]session] disconnect];
    [[_appDelegate mcManager] advertiseSelf:false];
}

- (void)progressChange
{
    CGFloat progress = ![self.timer isValid] ? self.progressView.progress : self.progressView.progress + 0.005f;
    [self.progressView setProgress:progress animated:YES];
    
    if (self.progressView.progress >= 1.0f && [self.timer isValid]) {
        [self.progressView setProgress:0.f animated:YES];
    }
}

- (void)startAnimation
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                  target:self
                                                selector:@selector(progressChange)
                                                userInfo:nil
                                                 repeats:YES];
}
- (IBAction)choseFirstAnswer {
    [self sendAnswer:@"1"];
    [self disableAnswerButtons];
}
- (IBAction)choseSecondAnswer {
    [self sendAnswer:@"2"];
    [self disableAnswerButtons];
}
- (IBAction)choseThirdAnswer {
    [self sendAnswer:@"3"];
    [self disableAnswerButtons];
}
- (IBAction)choseFourthAnswer {
    [self sendAnswer:@"4"];
    [self disableAnswerButtons];
}

- (IBAction)sendAnswer:(NSString *)answerIndex {
    NSLog(@"Sending answer");
    NSData *dataToSend = [answerIndex dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *allPeers = _appDelegate.mcManager.session.connectedPeers;
    NSError *error;
    
    [_appDelegate.mcManager.session sendData:dataToSend
                                     toPeers:allPeers
                                    withMode:MCSessionSendDataReliable
                                       error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

- (void)disableAnswerButtons {
    for (UIButton *button in self.buttonsView.subviews) {
        button.enabled = NO;
    }
}

# pragma host

-(void)didReceiveDataWithNotification:(NSNotification *)notification{
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    
    NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
    NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"THIS HAPPENED");
    NSLog(@"%@", receivedText);
    if ([receivedData isEqual: @"dunno"]) {
        NSLog(@"Entering game with %@", peerDisplayName);
        [self performSegueWithIdentifier:@"Enter_game" sender:self];
    } else {
        // Data is an answer
        NSLog(@"%@ answered %@", peerDisplayName, receivedText);
        
    }
    //NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    //[_tvChat performSelectorOnMainThread:@selector(setText:) withObject:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"%@ wrote:\n%@\n\n", peerDisplayName, receivedText]] waitUntilDone:NO];
}

@end
