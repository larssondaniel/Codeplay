//
//  CPControllerViewController.h
//  CodePlay
//
//  Created by Daniel Larsson on 2014-05-03.
//  Copyright (c) 2014 CodePlay Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface CPControllerViewController : UIViewController <MCBrowserViewControllerDelegate>

-(void)didReceiveDataWithNotification:(NSNotification *)notification;

@end
