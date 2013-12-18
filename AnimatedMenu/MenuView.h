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

@end
