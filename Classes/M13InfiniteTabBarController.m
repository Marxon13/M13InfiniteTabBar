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
    
    //Load the tab bar
    _infiniteTabBar = [[M13InfiniteTabBar alloc] init];
    [self.view addSubview:_infiniteTabBar];
    _infiniteTabBar.selectionDelegate = self;
    _infiniteTabBar.customizationDelegate = self;
    
    //Setup view controllers
    [self setViewControllers:_viewControllers];
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
            }
        }
        
        //Transfer items to the tab bar, It will handle the new selection in the same way as this method for view controllers
        NSMutableArray *itemArray = [NSMutableArray array];
        for (UIViewController *controller in _viewControllers) {
            [itemArray addObject:controller.infiniteTabBarItem];
        }
        [_infiniteTabBar setItems:itemArray];
        
        //Make sure the selections are correct.
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
    [self addChildViewController:content];
    content.view.frame = [self frameForContentController];
    [self.view insertSubview:content.view belowSubview:_infiniteTabBar];
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
    
    [oldContent willMoveToParentViewController:nil];
    [newContent willMoveToParentViewController:self];
    [self addChildViewController:newContent];
    
    CGRect newViewStartFrame = [self frameForContentController];
    newContent.view.frame = newViewStartFrame;
    CGRect oldViewEndFrame = [self frameForContentController];
    CGRect endFrame = oldViewEndFrame;
    
    [self transitionFromViewController:oldContent toViewController:newContent duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        newContent.view.frame = oldContent.view.frame;
        oldContent.view.frame = endFrame;
    } completion:^(BOOL finished) {
        [oldContent removeFromParentViewController];
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

- (CGRect)frameForContentController
{
    return self.view.bounds;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat tabBarHeight = 48.0;
    _infiniteTabBar.frame = CGRectMake(0, self.view.bounds.size.height - tabBarHeight, self.view.bounds.size.width, tabBarHeight);
    _selectedViewController.view.frame = self.view.bounds;
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
    [self transitionFromViewController:_selectedViewController toViewController:newController];
}

- (void)infiniteTabBar:(M13InfiniteTabBar *)tabBar didSelectItem:(M13InfiniteTabBarItem *)item
{
    if ([_delegate respondsToSelector:@selector(infiniteTabBarController:didSelectViewController:)]) {
        [_delegate infiniteTabBarController:self didSelectViewController:_selectedViewController];
    }
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

@end

static char ITEM_KEY;
static char CONTROLLER_KEY;

@implementation UIViewController (M13InfiniteTabBar)

- (void)setInfiniteTabBarItem:(M13InfiniteTabBarItem *)item
{
    objc_setAssociatedObject(self, &ITEM_KEY, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (M13InfiniteTabBarItem *)infiniteTabBarItem
{
    return objc_getAssociatedObject(self, &ITEM_KEY);
}

- (void)setInfiniteTabBarController:(M13InfiniteTabBarController *)controller
{
    objc_setAssociatedObject(self, &CONTROLLER_KEY, controller, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (M13InfiniteTabBarController *)infiniteTabBarController
{
    return objc_getAssociatedObject(self, &CONTROLLER_KEY);
}

@end
