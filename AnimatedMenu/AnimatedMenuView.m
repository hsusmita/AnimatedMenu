//
//  AnimatedMenuView.m
//  AnimatedMenu
//
//   Created by hsusmita on 18/12/13.
//  Copyright (c) 2013 abc. All rights reserved.
//

#import "AnimatedMenuView.h"
#import "MenuView.h"

#define kHeight 20
#define kWidth  20
#define kControllerHeight 50
#define kControllerWidth  50

#define kFinalVerticalDistance 75
#define kFinalHorizontalDistance 75

#define kMenuRectOne      CGRectMake(135, 20,   kWidth,   kHeight)
#define kMenuRectTwo      CGRectMake(10, 200,   kWidth,   kHeight)
#define kMenuTectThree    CGRectMake(260, 200,  kWidth,   kHeight)

#define kControllerRect   CGRectMake((self.frame.size.width - kControllerWidth)/2.0,(self.frame.size.height - kControllerHeight), kControllerWidth, kControllerHeight)

#define kAnimateDurationBasic     0.5
#define kDifferenceFactor         0.12

@interface AnimatedMenuView ()

@property (nonatomic, strong) MenuView *firstView;
@property (nonatomic, strong) MenuView *secondView;
@property (nonatomic, strong) MenuView *thirdView;
@property (nonatomic, strong) UIView *controllerView;

@property (nonatomic, assign) BOOL isControllerBeingDragged;
@property (nonatomic, assign) BOOL isControllerBeingReset;

@property (nonatomic, strong) UIDynamicAnimator *animator;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSDictionary *durationDictionary;
@property (nonatomic, assign) int count;

@end

@implementation AnimatedMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      [self initialSetup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
  self = [super initWithCoder:aDecoder];
  if(self){
    [self initialSetup];
  }
  return self;
}

- (void) initialSetup{
  [self setupControllerView];
  self.backgroundColor = [UIColor grayColor];
  [self setupMenuViews];
  [self startMenuAnimations];
  [self bringSubviewToFront:self.controllerView];
}

- (void) setupControllerView{
  self.controllerView = [[UIView alloc] initWithFrame:kControllerRect];
  [self addSubview:self.controllerView];
  self.controllerView.layer.cornerRadius = self.controllerView.frame.size.height / 2.0;
  [self.controllerView setBackgroundColor:[UIColor blueColor]];
  self.isControllerBeingDragged = NO;
  self.isControllerBeingReset = NO;
}

- (void) setupMenuViews{
  CGRect controllerFrame = kControllerRect;
  CGRect firstFrame = CGRectMake(controllerFrame.origin.x  + (controllerFrame.size.width - kWidth)/2, controllerFrame.origin.y - [self getMaximumBouncingDistance], kWidth, kHeight);
  self.firstView = [[MenuView alloc] initWithFrame:firstFrame];
  [self addSubview:self.firstView];
  CGRect secondFrame = CGRectMake(controllerFrame.origin.x - [self getMaximumBouncingDistance], controllerFrame.origin.y + (controllerFrame.size.height - kHeight)/2.0, kWidth, kHeight);
  self.secondView = [[MenuView alloc] initWithFrame:secondFrame];
  [self addSubview:self.secondView];
  CGRect thirdFrame = CGRectMake(controllerFrame.origin.x + controllerFrame.size.width + [self getMaximumBouncingDistance] - kWidth, controllerFrame.origin.y + (controllerFrame.size.height - kHeight)/2.0, kWidth, kHeight);
  self.thirdView = [[MenuView alloc] initWithFrame:thirdFrame];
  [self addSubview:self.thirdView];

}
- (float) getMaximumBouncingDistance{
  float maxDistance = MIN(self.frame.size.width/2,self.frame.size.height - kControllerWidth);
  NSLog(@"distance = %f",maxDistance);
  return kFinalHorizontalDistance;
}

- (void) animate{
  
  [self.firstView startAnimatingToPoint:CGPointMake(self.firstView.frame.origin.x,
                                                    self.controllerView.frame.origin.y -15)
                           withDuration:[self animationDurationForMenuIndex:0]];
  [self.secondView startAnimatingToPoint:CGPointMake(self.controllerView.frame.origin.x - 15,
                                                     self.secondView.frame.origin.y )
                            withDuration:[self animationDurationForMenuIndex:1]];
  [self.thirdView startAnimatingToPoint:CGPointMake(self.controllerView.frame.origin.x +
                                                    self.controllerView.frame.size.width - 5,
                                                    self.thirdView.frame.origin.y)
                           withDuration:[self animationDurationForMenuIndex:2]];
  self.count ++;

}

- (float) animationDurationForMenuIndex:(int) index{
  return (kAnimateDurationBasic + ((self.count + index) % 3) * kDifferenceFactor);
}

- (void) startMenuAnimations{
  self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                target:self
                                              selector:@selector(animate)
                                              userInfo:nil
                                               repeats:YES];
  [self.timer fire];
}
- (void) stopMenuAnimations{
  [self.timer invalidate];
  self.count = 0;
  [self.firstView stopAnimating];
  [self.secondView stopAnimating];
  [self.thirdView stopAnimating];
  
}
- (void) putBackControllerWithCompletion:(void (^)(void)) block{
  [UIView animateWithDuration:0.8
                        delay:0.0
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     [self.controllerView setFrame:kControllerRect];
                     self.isControllerBeingReset = YES;
                   }completion:^(BOOL finished) {
                     self.isControllerBeingReset = NO;
                     
                     if(block){
                       block();
                     }
                   }];
}



#pragma mark - Methods to handle touch

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
  
  if(self.isControllerBeingDragged || self.isControllerBeingReset){
    return;
  }else{
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    CGPoint point = [touch locationInView:self];
    if(CGRectContainsPoint(self.controllerView.frame, point)){
      self.isControllerBeingDragged = YES;
      self.controllerView.center = point;
      [self stopMenuAnimations];
    }
  }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  
  UITouch *touch = [[touches allObjects] objectAtIndex:0];
  CGPoint point = [touch locationInView:self];
  if(self.isControllerBeingDragged){
    self.controllerView.center = point;
  }
  
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
  
  UITouch *touch = [[touches allObjects] objectAtIndex:0];
  CGPoint point = [touch locationInView:self];
  
  self.isControllerBeingDragged = NO;
  int index ;
  if(CGRectContainsPoint(self.firstView.frame, point)){
    index = 0;
  }else if(CGRectContainsPoint(self.secondView.frame, point)){
    index = 1;
  }else if(CGRectContainsPoint(self.thirdView.frame, point)){
    index = 2;
  }
//  [self putBackControllerWithCompletion:^{
//    [self startMenuAnimations];
//  }];
  if([self.delegate respondsToSelector:@selector(animatedMenuView:didSelectMenuAtIndex:)]){
    [self.delegate animatedMenuView:self didSelectMenuAtIndex:index];
  }
}


@end
