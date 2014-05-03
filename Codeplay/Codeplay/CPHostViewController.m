//
//  CPHostViewController.m
//  CodePlay
//
//  Created by Daniel Larsson on 2014-05-03.
//  Copyright (c) 2014 CodePlay Interactive. All rights reserved.
//

#import "CPHostViewController.h"
#import "CPAppDelegate.h"
#import "CPPlayer.h"

@interface CPHostViewController ()

-(void)peerDidChangeStateWithNotification:(NSNotification *)notification;

@property (nonatomic, strong) CPAppDelegate *appDelegate;
@property (strong, nonatomic) UIWindow *secondWindow;
@property (nonatomic, strong) NSMutableArray *arrConnectedDevices;
@property (strong, nonatomic) IBOutlet UITableView *tblConnectedDevices;
@property (strong, nonatomic) NSMutableArray *players;

@end

@implementation CPHostViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _appDelegate = (CPAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [[_appDelegate mcManager] advertiseSelf:true];
    
    _arrConnectedDevices = [[NSMutableArray alloc] init];

    _tblConnectedDevices.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 10.0f)];
    _tblConnectedDevices.tintColor = [UIColor clearColor];
    [_tblConnectedDevices setDelegate:self];
    [_tblConnectedDevices setDataSource:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:@"MCDidChangeStateNotification"
                                               object:nil];
    
    
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
}

-(void)peerDidChangeStateWithNotification:(NSNotification *)notification{
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
    [_tblConnectedDevices reloadData];
    
    // BOOL peersExist = ([[_appDelegate.mcManager.session connectedPeers] count] == 0);
    // [_txtName setEnabled:peersExist];
}

- (IBAction)enterGame {
    NSData *dataToSend = [@"enter_game" dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *allPeers = _appDelegate.mcManager.session.connectedPeers;
    NSError *error;
    
    [_appDelegate.mcManager.session sendData:dataToSend
                                     toPeers:allPeers
                                    withMode:MCSessionSendDataReliable
                                       error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    /*
    for (MCPeerID *peer in allPeers) {
        [self.players addObject:[[CPPlayer alloc] initWithName:peer.displayName]];
    }
     */
}

-(void)didReceiveDataWithNotification:(NSNotification *)notification{
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    
    NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
    NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    if ([receivedData isEqual: @"enter_game"]) {
        NSLog(@"Entering game with %@", peerDisplayName);
        [self performSegueWithIdentifier:@"Enter_game" sender:self];
    } else {
        // Data is an answer
        
        NSLog(@"%@ answered %@", peerDisplayName, receivedText);
    }
    //NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    //[_tvChat performSelectorOnMainThread:@selector(setText:) withObject:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"%@ wrote:\n%@\n\n", peerDisplayName, receivedText]] waitUntilDone:NO];
}

#pragma tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_arrConnectedDevices count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    
    cell.textLabel.text = [_arrConnectedDevices objectAtIndex:indexPath.row];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

@end
