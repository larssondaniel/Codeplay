//
//  CPQuestionManager.h
//  Codeplay
//
//  Created by Daniel Larsson on 2014-05-03.
//  Copyright (c) 2014 Codeplay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface CPQuestionManager : NSObject

+ (CPQuestionManager *) sharedManager;

- (void)doStuff;

@end
