//
//  M13InfiniteTabBarCentralPullViewController.h
//  M13InfiniteTabBar
//
//  Created by Brandon McQuilkin on 2/13/13.
//  Copyright (c) 2013 Brandon McQuilkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "M13PanGestureRecognizer.h"
@class M13InfiniteTabBarCentralPullViewController;

@protocol M13InfiniteTabBarCentralPullViewControllerDelegate <NSObject>

- (void)pullableView:(M13InfiniteTabBarCentralPullViewController *)pullableView didChangeState:(BOOL)isOpen;

@end

@interface M13InfiniteTabBarCentralPullViewController : UIView

//The handle of the pull view
@property (nonatomic, retain) UIView *handleView;

//Location of the center of the pull view in its super view when closed
@property (readwrite, assign) CGPoint closedCenter;

//Location of the center of the pull view in its super view when open
@property (readwrite, assign) CGPoint openCenter;

//Used to retreive the state of the view
@property (readonly, assign) BOOL isOpen;

//Gesture Recongizier
@property (nonatomic, retain) M13PanGestureRecognizer *panRecognizer;

//Duration of the animation when pulled open or closed, and the gesture is ended
@property (readwrite, assign) CGFloat animationDuration;

//Delegate to be notified about state changes
@property (nonatomic, retain) id<M13InfiniteTabBarCentralPullViewControllerDelegate> delegate;

//Toggle the state
- (void)setOpened:(BOOL)opened animated:(BOOL)animated;

//Drag
-(void)handleDrag:(UIPanGestureRecognizer *)sender;

@end
