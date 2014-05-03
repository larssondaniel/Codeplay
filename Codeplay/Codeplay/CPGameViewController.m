//
//  CPGameViewController.m
//  CodePlay
//
//  Created by Daniel Larsson on 2014-05-03.
//  Copyright (c) 2014 CodePlay Interactive. All rights reserved.
//

#import "CPGameViewController.h"
#import "CPAppDelegate.h"

@interface CPGameViewController ()

@property (nonatomic, strong) CPAppDelegate *appDelegate;

@end

@implementation CPGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
