//
//  AnimatedMenuView.h
//  AnimatedMenu
//
//  Created by hsusmita on 18/12/13.
//  Copyright (c) 2013 abc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuView.h"

@protocol AnimatedMenuViewProtocol;

@interface AnimatedMenuView : UIView

@property (nonatomic, weak) id<AnimatedMenuViewProtocol> delegate;

@end

@protocol AnimatedMenuViewProtocol <NSObject>

- (void)animatedMenuView:(AnimatedMenuView *)animatedMenuView didSelectMenuAtIndex:(int)index;

@end