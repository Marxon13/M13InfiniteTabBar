//
//  RootNavigationController.m
//  InitialViewExample
//
//  Created by Brandon McQuilkin on 5/31/14.
//  Copyright (c) 2014 Brandon McQuilkin. All rights reserved.
//

#import "RootNavigationController.h"
#import "ViewController.h"
#import <M13InfiniteTabBar/M13InfiniteTabBarController.h>

@interface RootNavigationController () <M13InfiniteTabBarControllerDelegate>

@end

@implementation RootNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Get the tab bar controller, and set it's delegate.
    M13InfiniteTabBarController *tbc = self.viewControllers[0];
    tbc.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Rotation

//It is important to disable rotation on the container for the tab bar. The tab bar handles rotation for its subviews itself.
- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Delegate Methods

- (NSArray *)infiniteTabBarControllerRequestingViewControllersToDisplay:(M13InfiniteTabBarController *)tabBarController
{
    //Load the view controllers from the storyboard and add them to the array.
    UIStoryboard *storyboard = self.storyboard;
    
    ViewController *vc1 = [storyboard instantiateViewControllerWithIdentifier:@"BookmarksVC"];
    ViewController *vc2 = [storyboard instantiateViewControllerWithIdentifier:@"SearchVC"];
    ViewController *vc3 = [storyboard instantiateViewControllerWithIdentifier:@"WorldVC"];
    ViewController *vc4 = [storyboard instantiateViewControllerWithIdentifier:@"StopwatchVC"];
    ViewController *vc5 = [storyboard instantiateViewControllerWithIdentifier:@"TrashVC"];
    ViewController *vc6 = [storyboard instantiateViewControllerWithIdentifier:@"CloudVC"];
    UINavigationController *nc7 = [storyboard instantiateViewControllerWithIdentifier:@"NavigationVC"];
    ViewController *vc7 = [storyboard instantiateViewControllerWithIdentifier:@"InfoVC"];
    [nc7 pushViewController:vc7 animated:NO];
    
    //------- setSelectedIndex: test --------
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Goto World Tab" forState:UIControlStateNormal];
    button.frame = CGRectMake(20, ([UIScreen mainScreen].bounds.size.height / 2.0) - 15, [UIScreen mainScreen].bounds.size.width - 40, 30);
    button.backgroundColor = [UIColor colorWithWhite:1 alpha:.3];
    [button addTarget:vc1 action:@selector(gotoWorld:) forControlEvents:UIControlEventTouchUpInside];
    [vc1.view addSubview:button];
    vc1.infiniteTabBarController = tabBarController;
    
    //------- end test ----------------------
    
    //You probably want to set this on the UIViewController initalization, from within the UIViewController subclass. I'm just doing it here since each tab inherits from the same subclass.
    [vc1 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"Bookmarks" selectedIconMask:[UIImage imageNamed:@"tab1Solid.png"] unselectedIconMask:[UIImage imageNamed:@"tab1Line.png"]]];
    [vc2 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"Search" selectedIconMask:[UIImage imageNamed:@"tab2Solid.png"] unselectedIconMask:[UIImage imageNamed:@"tab2Line.png"]]];
    [vc3 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"World" selectedIconMask:[UIImage imageNamed:@"tab3Solid.png"] unselectedIconMask:[UIImage imageNamed:@"tab3Line.png"]]];
    [vc4 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"Stopwatch" selectedIconMask:[UIImage imageNamed:@"tab4Solid.png"] unselectedIconMask:[UIImage imageNamed:@"tab4Line.png"]]];
    [vc5 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"Trash" selectedIconMask:[UIImage imageNamed:@"tab5Solid.png"] unselectedIconMask:[UIImage imageNamed:@"tab5Line.png"]]];
    [vc6 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"Cloud" selectedIconMask:[UIImage imageNamed:@"tab6Solid.png"] unselectedIconMask:[UIImage imageNamed:@"tab6Line.png"]]];
    [nc7 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"Info" selectedIconMask:[UIImage imageNamed:@"tab7Solid.png"] unselectedIconMask:[UIImage imageNamed:@"tab7Line.png"]]];
    
    return @[vc1, vc2, vc3, vc4, vc5, vc6, nc7];
}

//Delegate Protocol
- (BOOL)infiniteTabBarController:(M13InfiniteTabBarController *)tabBarController shouldSelectViewContoller:(UIViewController *)viewController
{
    if ([viewController.title isEqualToString:@"Search"]) { //Prevent selection of first view controller
        return NO;
    } else {
        return YES;
    }
}

- (void)infiniteTabBarController:(M13InfiniteTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    //Do nothing
}

@end
