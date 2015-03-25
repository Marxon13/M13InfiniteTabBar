//
//  M!3InfiniteTabBarController.h
//  M13InfiniteTabBar
/*
 Copyright (c) 2015 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 One does not claim this software as ones own.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <UIKit/UIKit.h>
#import "M13InfiniteTabBar.h"
@class M13InfiniteTabBarItem;
@class M13InfiniteTabBarController;

typedef NS_ENUM(NSUInteger, M13InfiniteTabBarPosition) {
    M13InfiniteTabBarPositionTop,
    M13InfiniteTabBarPositionBottom
};

/** Delegate to respond to changes occuring in `M13InfiniteTabBarController` */
@protocol M13InfiniteTabBarControllerDelegate <NSObject>

/**@name Selection*/
/** Asks the delegate if the tab specified by the user should be selected
 @param tabBarController    The instance of `M13TabBarController.
 @param viewController      The UIViewController requesting to become the main view.
 @return Wether or not the UIViewController should be come the main window.
 */
- (BOOL)infiniteTabBarController:(M13InfiniteTabBarController *)tabBarController shouldSelectViewContoller:(UIViewController *)viewController;
/** Lets the delegate know that a tab change will occurr.
 @note This method is called before the animation for the tab change has started.
 @param tabBarController    The instance of `M13TabBarController`.
 @param viewController      The new main `UIViewController`. */
- (void)infiniteTabBarController:(M13InfiniteTabBarController *)tabBarController willSelectViewController:(UIViewController *)viewController;
/** Lets the delegate know that a tab change occurred.
 @note This method is called after the animation for the tab change has been completed.
 @param tabBarController    The instance of `M13TabBarController`.
 @param viewController      The new main `UIViewController`. */
- (void)infiniteTabBarController:(M13InfiniteTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;

/**@name Customizations*/

/**
 Tells the delegate that the tab bar customization sheet is about to be displayed.
 
 @param tabBarController The tab bar controller that is being customized.
 @param viewControllers  The view controllers to be displayed in the customization sheet.

 */
- (void)infiniteTabBarController:(M13InfiniteTabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray *)viewControllers;
/**
 Tells the delegate that the tab bar customization sheet was dismissed.
 
 @param tabBarController The tab bar controller that is being customized.
 @param viewControllers  The view controllers of the tab bar controller. The arrangement of the controllers in the array represents the new display order within the tab bar.
 @param changed          A Boolean value indicating whether items changed on the tab bar. YES if items changed or NO if they did not.
 */
- (void)infiniteTabBarController:(M13InfiniteTabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed;

/**@name Transitions*/
/**
 Called to allow the delegate to return a UIViewControllerAnimatedTransitioning delegate object for use during a noninteractive tab bar view controller transition.
 
 @param tabBarController The tab bar controller whose view controller is transitioning.
 @param fromVC           The currently visible view controller.
 @param toVC             The view controller intended to be visible after the transition ends.
 
 @return The UIViewControllerAnimatedTransitioning delegate object responsible for managing the tab bar view controller transition animation.
 */
- (id<UIViewControllerAnimatedTransitioning>)infiniteTabBarController:(M13InfiniteTabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC;

@end

/**The delegate that populates the infinite tab bar controller. This method is so that one can setup the infinite tab bar's children through the storyboard. Sadly the storyboard does not support custom types, and more specifically arrays. Hopefully one day, This can be setup in the storyboard just like UITabBarController.*/
@protocol M13InfiniteTabBarControllerConfigurationDelegate <NSObject>

/**
 Returns an array of UIViewControllers to display in the given controller as children.
 
 @param controller The M13InfiniteTabBarController requesting the children to display.
 
 @return An array of UIViewControllers that will be the children of the M13InfiniteTabBarController.
 */
- (NSArray *)viewControllersToDisplayInInfiniteTabBarController:(M13InfiniteTabBarController *)controller;

@end

@interface M13InfiniteTabBarController : UIViewController <M13InfiniteTabBarCustomizationDelegate, M13InfiniteTabBarSelectionDelegate>

/**@name Initalization*/
/**
 Initalize an instance of `M13InfiniteTabBarController` with a set of `UIViewController`s. This is for a programatic implementation of the tab bar without a storyboard.
@param viewControllers  All the view controllers for the tabs in order, the first tab will be the selected tab. Also all of these view controllers should respond
@return An instance of `M13InfiniteTabBarConroller` 
 */
- (id)initWithViewControllers:(NSArray *)viewControllers;

/**@name Basic Properties */
/**
 Responds to `M13InfiniteTabBarController`'s delegate methods. 
 */
@property (nonatomic, retain) id<M13InfiniteTabBarControllerDelegate> delegate;
/**
 The delegate responsible for populating the child view controllers if necessary.
 */
@property (nonatomic, retain) id<M13InfiniteTabBarControllerConfigurationDelegate> configurationDelegate;
/**
 The `M13InfiniteTabBar` instance the controller is controlling. This property is accessable to allow apperance customization.
 */
@property (nonatomic, readonly) M13InfiniteTabBar *infiniteTabBar;
/**
 The view controller list that the infinite tab bar displays.
 */
@property (nonatomic, copy) NSArray *viewControllers;
/**
 The view controller that is currently displayed.
 */
@property (nonatomic, assign) UIViewController *selectedViewController;
/**
 The currently selected index of the tab bar.
 */
@property (nonatomic, assign) NSUInteger selectedIndex;

@end

/**Extension for UIViewControllers to allow setting of their infinite tab bar item, like one would for a UITabBarItem.*/
@interface UIViewController (M13InfiniteTabBar)

/**Set the infinite tab bar item for the view controller.
 @param item The new tab bar item for the view controller.*/
- (void)setInfiniteTabBarItem:(M13InfiniteTabBarItem *)item;
/**Get the infinite tab bar item for the view controller.
 @return The infinite tab bar item for the view controller.*/
- (M13InfiniteTabBarItem *)infiniteTabBarItem;

/**Set the infinite tab bar controller for the view controller.
 @param item The new tab bar controller for the view controller.*/
- (void)setInfiniteTabBarController:(M13InfiniteTabBarController *)controller;
/**Get the infinite tab bar controller for the view controller.
 @return The infinite tab bar controller for the view controller.*/
- (M13InfiniteTabBarController *)infiniteTabBarController;

@end
