//
//  MenuView.m
//  AnimatedMenu
//
//  Created by hsusmita on 17/12/13.
//

#import "ViewController.h"
#import "MenuView.h"

#define kHeight 50
#define kWidth  50

#define kControllerRect CGRectMake(130,250,80,80)
#define kMenuRectOne CGRectMake(140, 20, kWidth, kHeight)
#define kMenuRectTwo CGRectMake(10, 200, kWidth, kHeight)
#define kMenuTectThree CGRectMake(260, 200, kWidth, kHeight)

@interface ViewController ()

@property (nonatomic, strong) MenuView *firstView;
@property (nonatomic, strong) MenuView *secondView;
@property (nonatomic, strong) MenuView *thirdView;
@property (nonatomic, strong) UIView *controllerView;



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
  self.secondView = [[MenuView alloc] initWithFrame:CGRectMake(10, 200, kWidth, kHeight)];
  [self.view addSubview:self.secondView];
  self.thirdView = [[MenuView alloc] initWithFrame:CGRectMake(260, 200, kWidth, kHeight)];
  [self.view addSubview:self.thirdView];
  self.controllerView = [[UIView alloc]initWithFrame:kControllerRect];
  [self.view addSubview:self.controllerView];
  [self.controllerView setBackgroundColor:[UIColor blueColor]];
  
}
- (void) startMenuAnimations{
  [self.firstView startAnimatingToPoint:CGPointMake(self.firstView.frame.origin.x, 150)];
  [self.secondView startAnimatingToPoint:CGPointMake(120, self.secondView.frame.origin.y)];
  [self.thirdView startAnimatingToPoint:CGPointMake(160, self.thirdView.frame.origin.y)];
  
}
- (void) stopMenuAnimation{
  [self.firstView stop];
  [self.secondView stop];
  [self.thirdView stop];
  
}
- (void) putBackController{
  [UIView animateWithDuration:1.0
                   animations:^{
                     [self.controllerView setFrame:kControllerRect];
                   }];
}
- (IBAction)handleStop:(id)sender {
  [self stopMenuAnimation];
}
- (IBAction)handleStart:(id)sender {
  [self startMenuAnimations];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
  [self stopMenuAnimation];
  UITouch *touch = [[touches allObjects] objectAtIndex:0];
  CGPoint point = [touch locationInView:self.view];
  if(CGRectContainsPoint(kControllerRect, point)){
    //    NSLog(@"detected");
    self.controllerView.center = point;
  }
}
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [[touches allObjects] objectAtIndex:0];
  CGPoint point = [touch locationInView:self.view];
  self.controllerView.center = point;
  
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
  UITouch *touch = [[touches allObjects] objectAtIndex:0];
  CGPoint point = [touch locationInView:self.view];
  if(CGRectContainsPoint(self.firstView.frame, point)){
    NSLog(@"Dropped on first menu");
  }else if(CGRectContainsPoint(self.secondView.frame, point)){
    NSLog(@"Dropped on second menu");
  }else if(CGRectContainsPoint(self.thirdView.frame, point)){
    NSLog(@"Dropped on third menu");
  }else{
    [self putBackController];
  }
}
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
