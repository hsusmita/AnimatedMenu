//
//  ViewContoller.m
//  AnimatedMenu
//
//  Created by hsusmita on 17/12/13.
//

#import "ViewController.h"
#import "MenuView.h"
#import "BouncyFallBehavior.h"

#define kHeight 20
#define kWidth  20
#define kControllerHeight 50
#define kControllerWidth  50

#define kFinalVerticalDistance 75
#define kFinalHorizontalDistance 75

#define kMenuRectOne      CGRectMake(135, 20,   kWidth,   kHeight)
#define kMenuRectTwo      CGRectMake(10, 200,   kWidth,   kHeight)
#define kMenuTectThree    CGRectMake(260, 200,  kWidth,   kHeight)

#define kControllerRect   CGRectMake((self.view.frame.size.width - kControllerWidth)/2.0,(self.view.frame.size.height - 100), kControllerWidth, kControllerHeight)
#define kMaxDistance      75


@interface ViewController ()

@property (nonatomic, strong) MenuView *firstView;
@property (nonatomic, strong) MenuView *secondView;
@property (nonatomic, strong) MenuView *thirdView;
@property (nonatomic, strong) UIView *controllerView;

@property (nonatomic, assign) BOOL isControllerBeingDragged;
@property (nonatomic, assign) BOOL isControllerBeingReset;

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) BouncyFallBehavior *behavior;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSDictionary *durationDictionary;
@property (nonatomic, assign) int count;



@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setupViews];
  [self startMenuAnimations];
  self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
  self.behavior = [[BouncyFallBehavior alloc]initWithItems:@[self.controllerView]];
  self.count = 0;

}

- (void) setupViews{
  self.firstView = [[MenuView alloc] initWithFrame:kMenuRectOne];
  [self.view addSubview:self.firstView];
  self.secondView = [[MenuView alloc] initWithFrame:kMenuRectTwo];
  [self.view addSubview:self.secondView];
  self.thirdView = [[MenuView alloc] initWithFrame:kMenuTectThree];
  [self.view addSubview:self.thirdView];
  [self setupControllerView];
  [self setupMenuViews];
  
  [self.firstView setAnimationDelay:0.0];
  [self.secondView setAnimationDelay:0.5];
  [self.thirdView setAnimationDelay:1.0];
  
}
- (void) setupControllerView{
  CGRect frame = CGRectMake((self.view.frame.size.width - kControllerWidth)/2.0,
                            (self.view.frame.size.height - 100), kControllerWidth, kControllerHeight);
  self.controllerView = [[UIView alloc]initWithFrame:frame];
  [self.view addSubview:self.controllerView];
  self.controllerView.layer.cornerRadius = frame.size.height / 2.0;
  [self.controllerView setBackgroundColor:[UIColor blueColor]];
  self.isControllerBeingDragged = NO;
  self.isControllerBeingReset = NO;
}
- (void) setupMenuViews{
  CGRect controllerFrame = self.controllerView.frame;
  CGRect firstFrame = CGRectMake(controllerFrame.origin.x  + (controllerFrame.size.width - kWidth)/2, controllerFrame.origin.y - kFinalVerticalDistance +15, kWidth, kHeight);
  [self.firstView setFrame:firstFrame];
  CGRect secondFrame = CGRectMake(controllerFrame.origin.x - kFinalHorizontalDistance, controllerFrame.origin.y + (controllerFrame.size.height - kHeight)/2.0, kWidth, kHeight);
  [self.secondView setFrame:secondFrame];
  CGRect thirdFrame = CGRectMake(controllerFrame.origin.x + controllerFrame.size.width + kFinalHorizontalDistance - kWidth, controllerFrame.origin.y + (controllerFrame.size.height - kHeight)/2.0, kWidth, kHeight);
  [self.thirdView setFrame:thirdFrame];

}
- (void) animate{
  float duration1;
  float duration2;
  float duration3;
  
 if(self.count % 3 == 1){
    duration1 = 0.6;
    duration2 = 0.7;
    duration3 = 0.5;
  }else if(self.count % 3 == 2){
    duration1 = 0.7;
    duration2 = 0.5;
    duration3 = 0.6;
  }else{
    duration1 = 0.5;
    duration2 = 0.6;
    duration3 = 0.7;

  }
  [self.firstView startAnimatingToPoint:CGPointMake(self.firstView.frame.origin.x,
                                                    self.firstView.frame.origin.y +
                                                    kFinalVerticalDistance - 30)
                           withDuration:duration1];
  [self.secondView startAnimatingToPoint:CGPointMake(self.secondView.frame.origin.x +
                                                     kFinalHorizontalDistance - 15,
                                                     self.secondView.frame.origin.y)
                            withDuration:duration2];
  [self.thirdView startAnimatingToPoint:CGPointMake(self.thirdView.frame.origin.x -
                                                    kFinalHorizontalDistance + 15,
                                                    self.thirdView.frame.origin.y)
                           withDuration:duration3];
  self.count ++;
  NSLog(@"hello = %d",self.count);
}
- (void) shuffleDurationArray{
//  NSUInteger count = [self count];
//  for (NSUInteger i = 0; i < count; ++i) {
//    // Select a random element between i and end of array to swap with.
//    NSInteger nElements = count - i;
//    NSInteger n = arc4random_uniform(nElements) + i;
//    [self exchangeObjectAtIndex:i withObjectAtIndex:n];
//  }
}
- (void) startMenuAnimations{
  self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(animate) userInfo:nil repeats:YES];
  [self.timer fire];
  
//  [self.firstView startOscillatingFromPoint:CGPointMake(self.controllerView.frame.origin.x  + (self.controllerView.frame.size.width - kWidth)/2,
//                                                        self.controllerView.frame.origin.y - kFinalVerticalDistance )
//                                    toPoint:CGPointMake(self.controllerView.frame.origin.x  + (self.controllerView.frame.size.width - kWidth)/2,
//                                                        self.controllerView.frame.origin.y-12)
//                                  withDelay:0.0];
//  [self.secondView startOscillatingFromPoint:CGPointMake(self.controllerView.frame.origin.x - kFinalHorizontalDistance -12,
//                                                         self.controllerView.frame.origin.y + (self.controllerView.frame.size.height - kHeight)/2.0)
//                                     toPoint:CGPointMake(self.controllerView.frame.origin.x,
//                                                         self.controllerView.frame.origin.y + (self.controllerView.frame.size.height - kHeight)/2.0)
//                                   withDelay:0.5];
//  [self.thirdView startOscillatingFromPoint:CGPointMake(self.controllerView.frame.origin.x + self.controllerView.frame.size.width + kFinalHorizontalDistance - kWidth + 12,
//                                                         self.controllerView.frame.origin.y + (self.controllerView.frame.size.height - kHeight)/2.0)
//                                     toPoint:CGPointMake( self.controllerView.frame.origin.x + self.controllerView.frame.size.width -12,
//                                                         self.controllerView.frame.origin.y + (self.controllerView.frame.size.height - kHeight)/2.0)
//                                  withDelay:0.5];
  
}
- (void) stopMenuAnimations{
  [self.timer invalidate];
  [self.firstView stopAnimating];
  [self.secondView stopAnimating];
  [self.thirdView stopAnimating];
  
//  [self.firstView stopOscillating];
//  [self.secondView stopOscillating];
//  [self.thirdView stopOscillating];
  
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
    CGPoint point = [touch locationInView:self.view];
        if(CGRectContainsPoint(self.controllerView.frame, point)){
        self.isControllerBeingDragged = YES;
        self.controllerView.center = point;
        [self stopMenuAnimations];
      }
  }
}
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
 
  UITouch *touch = [[touches allObjects] objectAtIndex:0];
  CGPoint point = [touch locationInView:self.view];
  if(point.y < self.view.frame.size.height - 150){
    return;
  }
  if(self.isControllerBeingDragged){

    self.controllerView.center = point;
  }
  
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

  UITouch *touch = [[touches allObjects] objectAtIndex:0];
  CGPoint point = [touch locationInView:self.view];

  self.isControllerBeingDragged = NO;

  if(CGRectContainsPoint(self.firstView.frame, point)){
    NSLog(@"Dropped on first menu");
  }else if(CGRectContainsPoint(self.secondView.frame, point)){
    NSLog(@"Dropped on second menu");
  }else if(CGRectContainsPoint(self.thirdView.frame, point)){
    NSLog(@"Dropped on third menu");
  }
//  [self.animator addBehavior:self.behavior];

  [self putBackControllerWithCompletion:^{
    [self startMenuAnimations];
//    [self.animator removeBehavior:self.behavior];
  }];

}
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
