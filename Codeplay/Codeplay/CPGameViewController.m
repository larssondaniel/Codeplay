//
//  CPGameViewController.m
//  CodePlay
//
//  Created by Daniel Larsson on 2014-05-03.
//  Copyright (c) 2014 CodePlay Interactive. All rights reserved.
//

#import "CPGameViewController.h"
#import "CPAppDelegate.h"
#import "DACircularProgressView.h"

@interface CPGameViewController ()

@property (nonatomic, strong) CPAppDelegate *appDelegate;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) DACircularProgressView *progressView;
@property (strong, nonatomic) IBOutlet UIView *buttonsView;

@end

@implementation CPGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0.0f, 248.0f, 320.0f, 320.0f)];
    self.progressView.trackTintColor = [UIColor clearColor];
    self.progressView.progressTintColor = [UIColor darkGrayColor];
    self.progressView.thicknessRatio = 1.0f;
    self.progressView.clockwiseProgress = YES;
    [self.view addSubview:self.progressView];
    [self.view bringSubviewToFront:self.buttonsView];
    [self startAnimation];

}

-(void) viewWillAppear:(BOOL)animated{
    
    NSLog(@"GOT CALLED");
    NSLog(@"CONNECTED USERS: %i", [[[[_appDelegate mcManager] session ] connectedPeers] count] );
    
    [[[_appDelegate mcManager]session] disconnect];
    [[_appDelegate mcManager] advertiseSelf:false];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)progressChange
{
    CGFloat progress = ![self.timer isValid] ? self.progressView.progress : self.progressView.progress + 0.01f;
    [self.progressView setProgress:progress animated:YES];
        
    if (self.progressView.progress >= 1.0f && [self.timer isValid]) {
        [self.progressView setProgress:0.f animated:YES];
    }
}

- (void)startAnimation
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.03
                                                  target:self
                                                selector:@selector(progressChange)
                                                userInfo:nil
                                                 repeats:YES];
}

@end
