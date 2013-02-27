//
//  M13InfiniteTabBar.h
//  M13InfiniteTabBar
//
//  Created by Brandon McQuilkin on 2/13/13.
//  Copyright (c) 2013 Brandon McQuilkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class M13InfiniteTabBarController;
@class M13InfiniteTabBar;
@class M13InfiniteTabBarItem;

@protocol M13InfiniteTabBarDelegate <NSObject>

//Requiered Method
- (void)infiniteTabBar:(M13InfiniteTabBar *)tabBar didSelectItem:(M13InfiniteTabBarItem *)item;

//Suggested Method
- (BOOL)infiniteTabBar:(M13InfiniteTabBar *)tabBar shouldSelectItem:(M13InfiniteTabBarItem *)item;

//Method to run animations in sequence with M13InfiniteTabBarController
- (void)infiniteTabBar:(M13InfiniteTabBar *)tabBar animateInViewControllerForItem:(M13InfiniteTabBarItem *)item;

@end

@interface M13InfiniteTabBar : UIScrollView <UIScrollViewDelegate, UIGestureRecognizerDelegate>

- (id)initWithInfiniteTabBarItems:(NSArray *)items;

//delegate
@property (nonatomic, retain) id<M13InfiniteTabBarDelegate> tabBarDelegate;

//Selected Item
@property (nonatomic, retain) M13InfiniteTabBarItem *selectedItem;
- (void)rotateItemsToOrientation:(UIDeviceOrientation)orientation;

@end
