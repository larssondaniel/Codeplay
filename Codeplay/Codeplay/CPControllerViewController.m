//
//  CPControllerViewController.m
//  CodePlay
//
//  Created by Daniel Larsson on 2014-05-03.
//  Copyright (c) 2014 CodePlay Interactive. All rights reserved.
//

#import <sys/utsname.h>
#import "CPControllerViewController.h"
#import "CPAppDelegate.h"

@interface CPControllerViewController ()

-(void)peerDidChangeStateWithNotification:(NSNotification *)notification;

@property (nonatomic, strong) CPAppDelegate *appDelegate;

@end

@implementation CPControllerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _appDelegate = (CPAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [[_appDelegate mcManager] setupMCBrowser];
    [[_appDelegate mcManager] setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    //[[_appDelegate mcManager] advertiseSelf:YES];
    
    [[[_appDelegate mcManager] browser] setDelegate:self];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:@"MCDidChangeStateNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:@"MCDidReceiveDataNotification"
                                               object:nil];

    [self presentViewController:[[_appDelegate mcManager] browser] animated:YES completion:nil];
}

- (IBAction)Saysomething:(id)sender {
    
    NSLog(@"Button Pressed");
    
    NSData *dataToSend = [@"Bluetooth Slave" dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *allPeers = _appDelegate.mcManager.session.connectedPeers;
    NSError *error;
    
    [_appDelegate.mcManager.session sendData:dataToSend
                                     toPeers:allPeers
                                    withMode:MCSessionSendDataUnreliable
                                       error:&error];
    
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
-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [_appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
}


-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [_appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
}

-(void)didReceiveDataWithNotification:(NSNotification *)notification{
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    
    NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
    
    if ([receivedData isEqual: @"enter_game"]) {
        NSLog(@"Entering game with %@", peerDisplayName);
        [self performSegueWithIdentifier:@"Enter_game" sender:self];
    }
    //NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    //[_tvChat performSelectorOnMainThread:@selector(setText:) withObject:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"%@ wrote:\n%@\n\n", peerDisplayName, receivedText]] waitUntilDone:NO];
}

-(void)peerDidChangeStateWithNotification:(NSNotification *)notification{
    /*
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
    
    if (state != MCSessionStateConnecting) {
        if (state == MCSessionStateConnected) {
            [_arrConnectedDevices addObject:peerDisplayName];
        }
        else if (state == MCSessionStateNotConnected){
            if ([_arrConnectedDevices count] > 0) {
                int indexOfPeer = [_arrConnectedDevices indexOfObject:peerDisplayName];
                [_arrConnectedDevices removeObjectAtIndex:indexOfPeer];
            }
        }
    }
    */
    // BOOL peersExist = ([[_appDelegate.mcManager.session connectedPeers] count] == 0);
}

@end
