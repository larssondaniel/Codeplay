//
//  CPPlayer.h
//  Codeplay
//
//  Created by Daniel Larsson on 2014-05-03.
//  Copyright (c) 2014 Codeplay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPPlayer : NSObject

-(id) initWithName:(NSString *)name;

@property (nonatomic, strong) NSString *name;
// @property (nonatomic) NSInteger *ID;

@end
