//
//  CPAppDelegate.h
//  CodePlay
//
//  Created by Chris Nordqvist on 2014-05-02.
//  Copyright (c) 2014 CodePlay Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPMCManager.h"

@interface CPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CPMCManager *mcManager;

@end
