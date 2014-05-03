//
//  CPHostViewController.m
//  CodePlay
//
//  Created by Daniel Larsson on 2014-05-03.
//  Copyright (c) 2014 CodePlay Interactive. All rights reserved.
//

#import "CPHostViewController.h"
#import "CPAppDelegate.h"

@interface CPHostViewController ()

@property (nonatomic, strong) CPAppDelegate *appDelegate;
@property (strong, nonatomic) UIWindow *secondWindow;

@end

@implementation CPHostViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _appDelegate = (CPAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [[_appDelegate mcManager] advertiseSelf:true];
    
    
    if ([[UIScreen screens] count] > 1)
    {
        // Get the screen object that represents the external display.
        UIScreen *secondScreen = [[UIScreen screens] objectAtIndex:1];
        // Get the screen's bounds so that you can create a window of the correctsize.
        CGRect screenBounds = secondScreen.bounds;
        self.secondWindow = [[UIWindow alloc] initWithFrame:screenBounds];
        self.secondWindow.screen = secondScreen;
        // Set up initial content to display...
        // Show the window.
        
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height)];
        view.backgroundColor = [UIColor blueColor];
        [self.secondWindow addSubview:view];
        
        
        
        self.secondWindow.hidden = NO;
    }
    
    
    
    NSLog(@"HELLLLOOOO");
    
}
- (IBAction)test:(id)sender {
    NSLog(@"Master press");
}

@end
