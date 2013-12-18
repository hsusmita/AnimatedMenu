//
//  MenuView.m
//  AnimatedMenu
//
//  Created by hsusmita on 17/12/13.
//

#import <UIKit/UIKit.h>

@interface MenuView : UIView

@property (nonatomic, assign) float animationDelay;

- (void) startAnimatingToPoint:(CGPoint) point withDuration:(float) duration;
- (void) stopAnimating;
- (void) startOscillatingFromPoint:(CGPoint) startingPoint toPoint:(CGPoint) endingPoint withDelay:(float) delay;
- (void) stopOscillating;

@end
