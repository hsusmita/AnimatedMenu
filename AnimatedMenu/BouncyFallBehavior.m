//
//  BouncyFallBehavior.m
//  AnimatedMenu
//
//  Created by sah-fueled on 18/12/13.
//  Copyright (c) 2013 abc. All rights reserved.
//

#import "BouncyFallBehavior.h"

@implementation BouncyFallBehavior

- (BouncyFallBehavior *) initWithItems:(NSArray *)items {
  if(self = [super init]){
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:items];
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:items];
    [collisionBehavior setTranslatesReferenceBoundsIntoBoundary:YES];
    [self addChildBehavior:gravityBehavior];
    [self addChildBehavior:collisionBehavior];
  }
  return self;
}

@end
