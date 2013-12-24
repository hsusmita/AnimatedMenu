//
//  MenuView.m
//  AnimatedMenu
//
//  Created by hsusmita on 17/12/13.
//

#import "MenuView.h"

#define kAnimationDuration 0.5

@interface MenuView()

@property (nonatomic, assign) BOOL animating;
@property (nonatomic, assign) CGRect finalFrame;
@property (nonatomic, assign) CGRect initialFrame;
@property (nonatomic, assign) float animationDuration;


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
  self.layer.cornerRadius = self.frame.size.width / 2.0;
}


- (void) startAnimatingToPoint:(CGPoint) point withDuration:(float) duration{
 
  if(self.animating){
    return;
  }
  self.animationDuration = duration;
    CGRect finalFrame = self.frame;
    finalFrame.origin.x = point.x ;
    finalFrame.origin.y = point.y ;
  
    self.finalFrame = finalFrame;
    self.initialFrame = self.frame;
    [self animate];
}

- (void) animate{

  [UIView animateKeyframesWithDuration:self.animationDuration
                                 delay:0.0
                               options:UIViewKeyframeAnimationOptionAutoreverse |  UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionRepeat

                            animations:^{
                              [self setFrame:self.finalFrame];
                              self.animating = YES;
                              self.transform = CGAffineTransformMakeScale(0.4, 0.4);
                            } completion:^(BOOL finished) {
                              if(finished){
//                                NSLog(@"finished");
                                self.transform = CGAffineTransformIdentity;

                                [self setFrame:self.initialFrame];

                              }
                              else{
//                                NSLog(@"not finished");
//                                NSLog(@"frame = %f %f",self.frame.origin.x, self.frame.origin.y);
                              }
                            }];
}
- (void) stopAnimating {
  self.frame = [[self.layer presentationLayer] frame];
  [self.layer removeAllAnimations];
  [self animateToInitialPoint];
  self.animating = NO;
}
- (void) animateToInitialPoint{
  [UIView animateWithDuration:self.animationDuration
                        delay:0.0
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     self.transform = CGAffineTransformIdentity;

                     [self setFrame:self.initialFrame];
                   } completion:^(BOOL finished) {
                   }];

}


@end
