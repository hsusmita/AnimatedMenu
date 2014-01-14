//
//  AnimatedMenuView.m
//  AnimatedMenu
//
//  Created by hsusmita on 18/12/13.
//  Copyright (c) 2013 abc. All rights reserved.
//

#import "AnimatedMenuView.h"
#import "MenuView.h"

#define kDefaultMenuCount 3

#define kHeight 20
#define kWidth  20
#define kControllerHeight 50
#define kControllerWidth  50

#define kFinalVerticalDistance 75
#define kFinalHorizontalDistance 75

#define kMaximumRadius 100

#define kControllerRect   CGRectMake((self.frame.size.width - kControllerWidth)/2.0,(self.frame.size.height - kControllerHeight), kControllerWidth, kControllerHeight)

#define kAnimateDurationBasic     0.5
#define kDifferenceFactor         0.12

@interface AnimatedMenuView ()

@property (nonatomic, strong) UIView *controllerView;

@property (nonatomic, assign) BOOL isControllerBeingDragged;
@property (nonatomic, assign) BOOL isControllerBeingReset;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int count;
@property (nonatomic, assign) int menuCount;

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
  self.menuCount = kDefaultMenuCount;
}

- (void) addViewForAngle:(float) angle{
 
}
- (void) setupMenuViews{
  CGPoint startingPoint = CGPointMake(160, self.frame.size.height - kControllerHeight/2);
  float angle = 0;
  float angleSpacing = M_PI / (self.menuCount - 1);
  for(int i = 0; i < self.menuCount ; i++){
    float posX = startingPoint.x
                 + kMaximumRadius * cosf(angle + i * angleSpacing)
                 - (kWidth / 2);
    float posY = startingPoint.y
                 - kMaximumRadius * sinf(angle + i * angleSpacing)
                 - (kHeight / 2);
    CGRect rect = CGRectMake(posX,
                             posY,
                             kWidth,
                             kHeight);
    
    MenuView *view = [[MenuView alloc] initWithFrame:rect];
    view.tag = i;
    [self addSubview:view];
  }
}

- (float) getMaximumBouncingDistance{
  float maxDistance = MIN(self.frame.size.width/2,self.frame.size.height - kControllerWidth);
  NSLog(@"distance = %f",maxDistance);
  return kFinalHorizontalDistance;
}

- (void) animate{
  for(MenuView *menuView in self.subviews){
    float angleSpacing = M_PI / (self.menuCount - 1);
    float angle = menuView.tag * angleSpacing ;
    float posX = menuView.frame.origin.x
                 - (kMaximumRadius - kControllerWidth/2 - 5) * cosf(angle);
    float posY = menuView.frame.origin.y
                 + (kMaximumRadius - kControllerHeight/2 - 5)* sinf(angle);
    if([menuView isKindOfClass:[MenuView class]]){
      [menuView startAnimatingToPoint:CGPointMake(posX,posY)
                         withDuration:[self animationDurationForMenuIndex:menuView.tag]];
    }
  }
  self.count ++;

}

- (float) animationDurationForMenuIndex:(int) index{
  return (kAnimateDurationBasic +
         ((self.count + index) % kDefaultMenuCount) * kDifferenceFactor);
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
  for(MenuView *menuView in self.subviews){
    if([menuView isKindOfClass:[MenuView class]]){
      [menuView stopAnimating];
    }
  }
  
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
  CGPoint startingPoint = CGPointMake(160, self.frame.size.height - kControllerHeight/2);
  float angle = atanf((point.y - startingPoint.y) / (point.x - startingPoint.x));
  
  float angleSpacing = M_PI / (self.menuCount - 1);
  NSLog(@"angle = %f %f",angle,angleSpacing);
  self.isControllerBeingDragged = NO;
  int index = -1 ;
  for(MenuView *menuView in self.subviews){
    if([menuView isKindOfClass:[MenuView class]]){
      if(CGRectContainsPoint(menuView.frame, point) ){
        index = menuView.tag;
        break;
      }
    }
  }
  [self putBackControllerWithCompletion:^{
    [self startMenuAnimations];
  }];
  if(index != -1){
  if([self.delegate respondsToSelector:@selector(animatedMenuView:didSelectMenuAtIndex:)]){
    [self.delegate animatedMenuView:self didSelectMenuAtIndex:index];
  }
  }
}



@end
