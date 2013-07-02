//
//  M13InfiniteTabBarCentralPullViewController.h
//  M13InfiniteTabBar
/*
 Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 One does not claim this software as ones own.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "M13PanGestureRecognizer.h"
@class M13InfiniteTabBarCentralPullViewController;

/** Delegate protocols for `M13InfiniteTabBarCentralPullViewController` */
@protocol M13InfiniteTabBarCentralPullViewControllerDelegate <NSObject>

/** Lets the delegate know that the central view controller did change positions.
 @param pullableView    The view that changed.
 @param isOpen          Wether or not the view is on screen. */
- (void)pullableView:(M13InfiniteTabBarCentralPullViewController *)pullableView didChangeState:(BOOL)isOpen;

@end

/** The centrally located `UIViewController` that is available anywhere by dragging up from the M13InfiniteTabBar. */
@interface M13InfiniteTabBarCentralPullViewController : UIView
/** @name Properties */
/** The handle of the pullable view. */
@property (nonatomic, retain) UIView *handleView;

/** The center of the `UIView` in respect to its parent when the pullable view is closed. */ 
@property (readwrite, assign) CGPoint closedCenter;

/** The center of the `UIView` in respect to its parent when the pullable view is open */
@property (readwrite, assign) CGPoint openCenter;

/** The current state of the pullable view. */
@property (readonly, assign) BOOL isOpen;

/** The gesture recognizer that detects upward drags. Accessable to allow fo concurrent gesture recognizers*/
@property (nonatomic, retain) M13PanGestureRecognizer *panRecognizer;

/** The duration of the animation when the view is opened or closed programatically. */
@property (readwrite, assign) CGFloat animationDuration;

/** The pullable view's delegate */
@property (nonatomic, retain) id<M13InfiniteTabBarCentralPullViewControllerDelegate> delegate;

/** Set the state of the view.
 @param opened      Wether or not the view will be opened.
 @param animated    Wether or not to animate the transition. */
- (void)setOpened:(BOOL)opened animated:(BOOL)animated;

/** Allows updating of the view's position while the user drags. 
 @param sender The UIPanGestureRecognizer handling the drag. */
-(void)handleDrag:(UIPanGestureRecognizer *)sender;

@end
