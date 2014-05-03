//
//  CPHostGameViewController.h
//  Codeplay
//
//  Created by Daniel Larsson on 2014-05-03.
//  Copyright (c) 2014 Codeplay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface CPHostGameViewController : UIViewController <MCBrowserViewControllerDelegate>

-(void)didReceiveDataWithNotification:(NSNotification *)notification;

@end
