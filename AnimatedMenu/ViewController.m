//
//  ViewContoller.m
//  AnimatedMenu
//
//  Created by hsusmita on 17/12/13.
//

#import "ViewController.h"
#import "AnimatedMenuView.h"

@interface ViewController ()<AnimatedMenuViewProtocol>

@property (nonatomic, strong) AnimatedMenuView *animatedView;

@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.animatedView = [[AnimatedMenuView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 200, 320, 200)];
  [self.view addSubview:self.animatedView];
  self.animatedView.delegate = self;
  CATransition *animation = [CATransition animation];
  [animation setDelegate:self];
  [animation setDuration:2.0f];
  [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
  [animation setType:@"rippleEffect" ];
  [self.animatedView.layer addAnimation:animation forKey:NULL];

}

- (void) animatedMenuView:(AnimatedMenuView *)animatedMenuView
     didSelectMenuAtIndex:(int)index{
  switch(index){
      case 0:{
        NSLog(@"Dropped on first menu");
        break;
      }
    case 1:{
      NSLog(@"Dropped on second menu");
      break;
    }
    case 2:{
      NSLog(@"Dropped on third menu");
      break;
    }
      default:
      break;
  }
}
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
