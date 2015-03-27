//
//  M!3InfiniteTabBarController.m
//  M13InfiniteTabBar
/*
 Copyright (c) 2015 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 One does not claim this software as ones own.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "M13InfiniteTabBarController.h"
#import "M13InfiniteTabBarItem.h"
#import "M13InfiniteTabBar.h"
#import <objc/runtime.h>

#define kM13InfiniteTabBarHeight 50.0

@interface M13InfiniteTabBarController () <M13InfiniteTabBarSelectionDelegate, M13InfiniteTabBarCustomizationDelegate>

/**
 Make sure that the view loaded before we add any content controllers.
 */
@property (nonatomic, assign) BOOL viewDidLoadOccured;

/**
 The tab bar.
 */
@property (nonatomic, strong) M13InfiniteTabBar *infiniteTabBar;

/**
 The view container for the child view controllers.
 */
@property (nonatomic, strong) UIView *controllerContainerView;

@end

@implementation M13InfiniteTabBarController

//---------------------------------------
#pragma mark Initalization
//---------------------------------------

- (id)initWithViewControllers:(NSArray *)viewControllers
{
    self = [super init];
    if (self) {
        _viewControllers = viewControllers;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _viewDidLoadOccured = true;
    // Do any additional setup after loading the view.
    [self setup];
}

- (void)setup
{
    //Style self
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    //Load the container view.
    _controllerContainerView = [[UIView alloc] init];
    [self.view addSubview:_controllerContainerView];
    
    //Load the tab bar
    _infiniteTabBar = [[M13InfiniteTabBar alloc] init];
    _infiniteTabBar.tabBarItemInsets = UIEdgeInsetsMake(2.0, 0.0, 0.0, 0.0);
    [self.view addSubview:_infiniteTabBar];
    _infiniteTabBar.selectionDelegate = self;
    _infiniteTabBar.customizationDelegate = self;
    
    //Setup view controllers
    [self setViewControllers:_viewControllers];
    
    //self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//---------------------------------------
#pragma mark Content Control
//---------------------------------------

- (void)setViewControllers:(NSArray *)viewControllers
{
    _viewControllers = viewControllers;
    
    if (_viewDidLoadOccured) {
        
        //Do we need to grab the view controllers?
        if (_viewControllers == nil || _viewControllers.count == 0) {
            if ([_configurationDelegate respondsToSelector:@selector(viewControllersToDisplayInInfiniteTabBarController:)]) {
                _viewControllers = [_configurationDelegate viewControllersToDisplayInInfiniteTabBarController:self];
            } else {
                NSLog(@"Whoops, the M13InfiniteTabBarController was loaded without content.");
                return;
            }
        }
        
        //Transfer items to the tab bar, It will handle the new selection in the same way as this method for view controllers
        NSMutableArray *itemArray = [NSMutableArray array];
        for (UIViewController *controller in _viewControllers) {
            [itemArray addObject:controller.infiniteTabBarItem];
        }
        [_infiniteTabBar setItems:itemArray];
        
        //Make sure the selections are correct
        BOOL previousSelectionExists = false;
        for (UIViewController *controller in _viewControllers) {
            if (controller == _selectedViewController) {
                previousSelectionExists = true;
                if (controller.infiniteTabBarItem.selected == false) {
                    [controller.infiniteTabBarItem setSelected:true];
                }
            } else {
                [controller.infiniteTabBarItem setSelected:false];
            }
        }
        //Perform the proper transitions, and set the selected properties.
        if (!previousSelectionExists && _viewControllers.count > 0) {
            UIViewController *newController = _viewControllers[0];
            newController.infiniteTabBarItem.selected = true;
            if (_selectedViewController) {
                //Swap view controllers
                [self transitionFromViewController:_selectedViewController toViewController:newController];
            } else {
                [self displayContentController:newController];
            }
            
            _selectedViewController = _viewControllers[0];
            _selectedIndex = 0;
        } else {
            _selectedIndex = [_viewControllers indexOfObject:_selectedViewController];
        }
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [self setSelectedViewController:_viewControllers[selectedIndex]];
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController
{
    if (![_viewControllers containsObject:selectedViewController]) {
        NSLog(@"M13InfiniteTabBarController: Attempting to select a view controller that is not managed by the tab bar.");
        return;
    }
    
    //Let the tab bar handle the control flow.
    [_infiniteTabBar setSelectedItem:selectedViewController.infiniteTabBarItem];
}

- (void)displayContentController:(UIViewController *)content
{
    //Set the content
    [self addChildViewController:content];
    //Update the layout guides
    [self updateLayoutConstraintsForChildViewController:content];
    [self updateScrollViewInsetsForChildViewController:content];
    
    content.view.frame = [self frameForChildViewControllers];
    [_controllerContainerView addSubview:content.view];
    self.title = content.title;
    [content didMoveToParentViewController:self];
}

- (void)hideContentController:(UIViewController *)content
{
    [content willMoveToParentViewController:nil];
    [content.view removeFromSuperview];
    [content removeFromParentViewController];
}

- (void)transitionFromViewController:(UIViewController*)oldContent toViewController:(UIViewController*)newContent
{
    //Transition the content
    [oldContent willMoveToParentViewController:nil];
    [newContent willMoveToParentViewController:self];
    [self addChildViewController:newContent];
    
    CGRect newViewStartFrame = [self frameForChildViewControllers];
    newContent.view.frame = newViewStartFrame;
    CGRect oldViewEndFrame = [self frameForChildViewControllers];
    CGRect endFrame = oldViewEndFrame;
    
    //Update the layout guides (Doing it before the transition has no effect on the child.
    [self updateLayoutConstraintsForChildViewController:newContent];
    [self updateScrollViewInsetsForChildViewController:newContent];

    [self transitionFromViewController:oldContent toViewController:newContent duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        newContent.view.frame = oldContent.view.frame;
        oldContent.view.frame = endFrame;
        
    } completion:^(BOOL finished) {
        [oldContent removeFromParentViewController];
        [oldContent didMoveToParentViewController:nil];
        [newContent didMoveToParentViewController:self];
    }];
}

//---------------------------------------
#pragma mark Rotation
//---------------------------------------

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return false;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

//---------------------------------------
#pragma mark Layout
//---------------------------------------

- (CGRect)frameForChildViewControllers
{
    return _controllerContainerView.bounds;
}

- (void)updateLayoutConstraintsForChildViewController:(UIViewController *)childViewController
{
    //Iterate through all the layout constraints and find the constraints for the top and bottom
    for (NSLayoutConstraint *constraint in childViewController.view.constraints) {
        //Is it the top layout guide?
        if (constraint.firstItem == childViewController.topLayoutGuide && constraint.firstAttribute == NSLayoutAttributeHeight
            && constraint.secondItem == nil) {
            constraint.constant = self.topLayoutGuide.length;
        }
        //Is it the bottom layout guide
        if (constraint.firstItem == childViewController.bottomLayoutGuide && constraint.firstAttribute == NSLayoutAttributeHeight && constraint.secondItem == nil) {
            constraint.constant = kM13InfiniteTabBarHeight;
        }
    }
}

- (void)updateScrollViewInsetsForChildViewController:(UIViewController *)viewController
{
    if ([viewController.class isSubclassOfClass:[UITableViewController class]] && viewController.automaticallyAdjustsScrollViewInsets) {
        UITableViewController *tbvc = (UITableViewController *)viewController;
        tbvc.tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0.0, kM13InfiniteTabBarHeight, 0.0);
        tbvc.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.topLayoutGuide.length, 0.0, kM13InfiniteTabBarHeight, 0.0);
        //Adjust only if the user has not scrolled.
        if (tbvc.tableView.contentOffset.y == 0.0) {
            [UIView animateWithDuration:0.01 delay:0.0 options:0 animations:^{
                [tbvc.tableView setContentOffset:CGPointMake(0.0, - self.topLayoutGuide.length) animated:false];
            } completion:^(BOOL finished) {
                
            }];
            
        }
    } else if ([viewController.class isSubclassOfClass:[UICollectionViewController class]] && viewController.automaticallyAdjustsScrollViewInsets) {
        UICollectionViewController *tbvc = (UICollectionViewController *)viewController;
        tbvc.collectionView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0.0, kM13InfiniteTabBarHeight, 0.0);
        tbvc.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(self.topLayoutGuide.length, 0.0, kM13InfiniteTabBarHeight, 0.0);
        //Adjust only if the user has not scrolled.
        if (tbvc.collectionView.contentOffset.y == 0.0) {
            [tbvc.collectionView setContentOffset:CGPointMake(0.0, - self.topLayoutGuide.length) animated:false];
        }
    } else if (viewController.view.subviews.count > 0) {
        if ([[viewController.view.subviews[0] class] isSubclassOfClass:[UIScrollView class]] && viewController.automaticallyAdjustsScrollViewInsets) {
            UIScrollView *sv = (UIScrollView *)viewController.view.subviews[0];
            sv.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0.0, kM13InfiniteTabBarHeight, 0.0);
            sv.scrollIndicatorInsets = UIEdgeInsetsMake(self.topLayoutGuide.length, 0.0, kM13InfiniteTabBarHeight, 0.0);
            //Adjust only if the user has not scrolled.
            if (sv.contentOffset.y == 0.0) {
                [sv setContentOffset:CGPointMake(0.0, - self.topLayoutGuide.length) animated:false];
            }
        }
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _controllerContainerView.frame = self.view.bounds;
    
    _infiniteTabBar.frame = CGRectMake(0, self.view.bounds.size.height - kM13InfiniteTabBarHeight, self.view.bounds.size.width, kM13InfiniteTabBarHeight);
    _selectedViewController.view.frame = self.view.bounds;
    
    [self updateLayoutConstraintsForChildViewController:_selectedViewController];
    [self updateScrollViewInsetsForChildViewController:_selectedViewController];
}

//---------------------------------------
#pragma mark Infinite Tab Bar
//---------------------------------------

- (BOOL)infiniteTabBar:(M13InfiniteTabBar *)tabBar shouldSelectItem:(M13InfiniteTabBarItem *)item
{
    BOOL should = true;
    if ([_delegate respondsToSelector:@selector(infiniteTabBarController:shouldSelectViewContoller:)]) {
        should = [_delegate infiniteTabBarController:self shouldSelectViewContoller:_viewControllers[item.index]];
    }
    return should;
}

- (void)infiniteTabBar:(M13InfiniteTabBar *)tabBar willSelectItem:(M13InfiniteTabBarItem *)item
{
    if ([_delegate respondsToSelector:@selector(infiniteTabBarController:willSelectViewController:)]) {
        [_delegate infiniteTabBarController:self willSelectViewController:_viewControllers[item.index]];
    }
}

- (void)infiniteTabBar:(M13InfiniteTabBar *)tabBar concurrentAnimationsForSelectingItem:(M13InfiniteTabBarItem *)item
{
    UIViewController *newController = _viewControllers[item.index];
    if (item.index == _selectedIndex) {
        
    } else {
        //Switch tabs
        [self transitionFromViewController:_selectedViewController toViewController:newController];
    }
    self.title = newController.title;
}

- (void)infiniteTabBar:(M13InfiniteTabBar *)tabBar didSelectItem:(M13InfiniteTabBarItem *)item
{
    if ([_delegate respondsToSelector:@selector(infiniteTabBarController:didSelectViewController:)]) {
        [_delegate infiniteTabBarController:self didSelectViewController:_selectedViewController];
    }
    _selectedIndex = item.index;
    _selectedViewController = _viewControllers[_selectedIndex];
}

- (void)infiniteTabBar:(M13InfiniteTabBar *)tabBar willBeginCustomizingItems:(NSArray *)items
{
    if ([_delegate respondsToSelector:@selector(infiniteTabBarController:willBeginCustomizingViewControllers:)]) {
        //Grab what controllers will be customized
        NSMutableArray *viewControllers = [NSMutableArray array];
        for (UIViewController *controller in _viewControllers) {
            for (M13InfiniteTabBarItem *item in items) {
                if ([controller.infiniteTabBarItem isEqual:item]) {
                    [viewControllers addObject:controller];
                    continue;
                }
            }
        }
        [_delegate infiniteTabBarController:self willBeginCustomizingViewControllers:viewControllers];
    }
}

- (void)infiniteTabBar:(M13InfiniteTabBar *)tabBar didEndCustomizingItems:(NSArray *)items changed:(BOOL)changed
{
    if ([_delegate respondsToSelector:@selector(infiniteTabBarController:didEndCustomizingViewControllers:changed:)]) {
        //Grab what controllers will be customized
        NSMutableArray *viewControllers = [NSMutableArray array];
        for (UIViewController *controller in _viewControllers) {
            for (M13InfiniteTabBarItem *item in items) {
                if ([controller.infiniteTabBarItem isEqual:item]) {
                    [viewControllers addObject:controller];
                    continue;
                }
            }
        }
        [_delegate infiniteTabBarController:self didEndCustomizingViewControllers:viewControllers changed:changed];
    }
}

- (void)infiniteTabBar:(M13InfiniteTabBar *)tabBar secondaryAction:(M13InfiniteTabBarSecondaryAction)action performedOnItem:(M13InfiniteTabBarItem *)item
{
    if (action == M13InfiniteTabBarSecondaryActionTap) {
        //If the action is a tap, if the selected view controller is a UINavigationController, pop its stack to root.
        if ([_selectedViewController.class isSubclassOfClass:[UINavigationController class]]) {
            [((UINavigationController *)_selectedViewController) popToRootViewControllerAnimated:true];
        }
    }
}

@end

static char ITEM_KEY;

@implementation UIViewController (M13InfiniteTabBar)

- (void)setInfiniteTabBarItem:(M13InfiniteTabBarItem *)item
{
    objc_setAssociatedObject(self, &ITEM_KEY, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (M13InfiniteTabBarItem *)infiniteTabBarItem
{
    return objc_getAssociatedObject(self, &ITEM_KEY);
}

- (M13InfiniteTabBarController *)infiniteTabBarController
{
    UIViewController *currentParent = self;
    while (currentParent != nil && [currentParent class] != [M13InfiniteTabBarController class]) {
        currentParent = currentParent.parentViewController;
    }
    
    return (M13InfiniteTabBarController *)currentParent;
}

@end
