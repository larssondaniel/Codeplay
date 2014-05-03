//
//  CPViewController.m
//  CodePlay
//
//  Created by Chris Nordqvist on 2014-05-02.
//  Copyright (c) 2014 CodePlay Interactive. All rights reserved.
//

#import "CPViewController.h"
#import "CPAppDelegate.h"

@interface CPViewController ()

@property (nonatomic, strong) CPAppDelegate *appDelegate;

@end

@implementation CPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated{
    [[[_appDelegate mcManager]session] disconnect];
    [[_appDelegate mcManager] advertiseSelf:false];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
