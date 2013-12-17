//
//  ViewContoller.m
//  AnimatedMenu
//
//  Created by hsusmita on 17/12/13.
//

#import "ViewController.h"
#import "MenuView.h"

#define kHeight 50
#define kWidth  50
#define kControllerHeight 80
#define kControllerWidth  80

#define kFinalVerticalDistance 130
#define kFinalHorizontalDistance 75

#define kMenuRectOne      CGRectMake(135, 20,   kWidth,   kHeight)
#define kMenuRectTwo      CGRectMake(10, 200,   kWidth,   kHeight)
#define kMenuTectThree    CGRectMake(260, 200,  kWidth,   kHeight)

#define kControllerRect   CGRectMake(120,250,kControllerWidth,kControllerHeight)


@interface ViewController ()

@property (nonatomic, strong) MenuView *firstView;
@property (nonatomic, strong) MenuView *secondView;
@property (nonatomic, strong) MenuView *thirdView;
@property (nonatomic, strong) UIView *controllerView;
@property (nonatomic, assign) BOOL isControllerBeingDragged;
@property (nonatomic, assign) BOOL isControllerBeingReset;


@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setupViews];
  [self startMenuAnimations];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void) setupViews{
  self.firstView = [[MenuView alloc] initWithFrame:kMenuRectOne];
  [self.view addSubview:self.firstView];
  self.secondView = [[MenuView alloc] initWithFrame:kMenuRectTwo];
  [self.view addSubview:self.secondView];
  self.thirdView = [[MenuView alloc] initWithFrame:kMenuTectThree];
  [self.view addSubview:self.thirdView];
  self.controllerView = [[UIView alloc]initWithFrame:kControllerRect];
  [self.view addSubview:self.controllerView];
  [self.controllerView setBackgroundColor:[UIColor blueColor]];
  self.isControllerBeingDragged = NO;
  self.isControllerBeingReset = NO;
  
}
- (void) startMenuAnimations{
  [self.firstView startAnimatingToPoint:CGPointMake(self.firstView.frame.origin.x,
                                                    self.firstView.frame.origin.y +
                                                    kFinalVerticalDistance)];
  [self.secondView startAnimatingToPoint:CGPointMake(self.secondView.frame.origin.x +
                                                    kFinalHorizontalDistance,
                                                    self.secondView.frame.origin.y)];
  [self.thirdView startAnimatingToPoint:CGPointMake(self.thirdView.frame.origin.x -
                                                    kFinalHorizontalDistance,
                                                    self.thirdView.frame.origin.y)];
  
}
- (void) stopMenuAnimations{
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
    CGPoint point = [touch locationInView:self.view];
        if(CGRectContainsPoint(self.controllerView.frame, point)){
        self.isControllerBeingDragged = YES;
        self.controllerView.center = point;
        [self stopMenuAnimations];
      }
  }
}
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
 
  if(self.isControllerBeingDragged){
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    CGPoint point = [touch locationInView:self.view];
    self.controllerView.center = point;
  }
  
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

  self.isControllerBeingDragged = NO;
  UITouch *touch = [[touches allObjects] objectAtIndex:0];
  CGPoint point = [touch locationInView:self.view];
  
  if(CGRectContainsPoint(self.firstView.frame, point)){
    NSLog(@"Dropped on first menu");
  }else if(CGRectContainsPoint(self.secondView.frame, point)){
    NSLog(@"Dropped on second menu");
  }else if(CGRectContainsPoint(self.thirdView.frame, point)){
    NSLog(@"Dropped on third menu");
  }
  [self putBackControllerWithCompletion:^{
    [self startMenuAnimations];
  }];

}
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
