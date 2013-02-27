//
//  M13InfiniteTabBarController.h
//  M13InfiniteTabBar
//
//  Created by Brandon McQuilkin on 2/13/13.
//  Copyright (c) 2013 Brandon McQuilkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M13InfiniteTabBar.h"
#import "M13InfiniteTabBarCentralPullNotificationBackgroundView.h"
#import "M13InfiniteTabBarCentralPullViewController.h"
@class M13InfiniteTabBarController;

@protocol M13InfiniteTabBarControllerDelegate <NSObject>

//delegate protocols
- (BOOL)infiniteTabBarController:(M13InfiniteTabBarController *)tabBarController shouldSelectViewContoller:(UIViewController *)viewController;
- (void)infiniteTabBarController:(M13InfiniteTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;

@end

@interface M13InfiniteTabBarController : UIViewController <M13InfiniteTabBarDelegate, M13InfiniteTabBarCentralPullViewControllerDelegate>

- (id)initWithViewControllers:(NSArray *)viewControllers pairedWithInfiniteTabBarItems:(NSArray *)items;

@property (nonatomic, retain) id<M13InfiniteTabBarControllerDelegate> delegate; //Delegate
@property (nonatomic, readonly) M13InfiniteTabBar *infiniteTabBar; //Infinite tab bar

@property (nonatomic, assign) UIViewController *selectedViewController;
@property (nonatomic) NSUInteger selectedIndex;

- (void)setSelectedIndex:(NSUInteger)selectedIndex;
- (void)setSelectedViewController:(UIViewController *)selectedViewController;

//Central View controller is shown by dragging up on the tab bar
@property (nonatomic, retain) UIViewController *centralViewController;
@property (nonatomic, readonly) BOOL isCentralViewControllerOpen;
- (void)showAlertForCentralViewControllerIsEmergency:(BOOL)emergency;
- (void)setCentralViewControllerOpened:(BOOL)opened animated:(BOOL)animated;
- (void)endAlertAnimation;

//Delegate
- (void)infiniteTabBar:(M13InfiniteTabBar *)tabBar didSelectItem:(M13InfiniteTabBarItem *)item;
- (void)infiniteTabBar:(M13InfiniteTabBar *)tabBar animateInViewControllerForItem:(M13InfiniteTabBarItem *)item;
- (BOOL)infiniteTabBar:(M13InfiniteTabBar *)tabBar shouldSelectItem:(M13InfiniteTabBarItem *)item;

//Appearance
@property (nonatomic, retain) UIColor *tabBarBackgroundColor UI_APPEARANCE_SELECTOR; //Solid unmoving background color of tab bar

@property (nonatomic, retain) M13InfiniteTabBarCentralPullNotificationBackgroundView *pullNotificatonBackgroundView; //BackgroundView to alert users to a change in the central view controller

@end
