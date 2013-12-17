//
//  MenuView.m
//  AnimatedMenu
//
//  Created by hsusmita on 17/12/13.
//

#import "MenuView.h"

@interface MenuView()

@property (nonatomic, assign) BOOL animating;
@property (nonatomic, assign) CGRect finalFrame;
@property (nonatomic, assign) CGRect initialFrame;


@end

@implementation MenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      [self initialize];
    }
    return self;
}

- (void) initialize{
  self.backgroundColor = [UIColor cyanColor];
  self.initialFrame = self.frame;
}


- (void) startAnimatingToPoint:(CGPoint) point{
 
  if(self.animating){
    return;
  }
  if(CGRectEqualToRect(self.frame, self.initialFrame)){
    CGRect finalFrame = self.frame;
    finalFrame.origin.x = point.x;
    finalFrame.origin.y = point.y;
    self.finalFrame = finalFrame;
    [self animate];

  }
  else {
//    NSLog(@"another animation");
    [UIView animateWithDuration:1.0
     
                              animations:^{
                                [self setFrame:self.finalFrame];
                              } completion:^(BOOL finished) {
                                [UIView animateWithDuration:1.0
                                                            animations:^{
                                                            [self setFrame:self.initialFrame];
                                                          } completion:^(BOOL finished) {
                                                            [self animate];
                                                          }];
                              }];
  }

}
- (void) animate{
  [UIView animateKeyframesWithDuration:1.0
                                 delay:0.0
                               options:UIViewKeyframeAnimationOptionAutoreverse | UIViewKeyframeAnimationOptionRepeat
                            animations:^{
                              [self setFrame:self.finalFrame];
                              self.animating = YES;
                            } completion:^(BOOL finished) {
//                              NSLog(@"moving");
                              if(finished){
                                NSLog(@"finished");
                              }
                              else{
//                                NSLog(@"not finished");
//                                NSLog(@"frame = %f %f",self.frame.origin.x, self.frame.origin.y);
                              }
                            }];
}

- (void) stop {
  self.frame = [[self.layer presentationLayer] frame];

  [self.layer removeAllAnimations];
  self.animating = NO;
}

@end
