//
//  AppDelegate.m
//  M13InfiniteTabBar
//
//  Created by Brandon McQuilkin on 2/13/13.
//  Copyright (c) 2013 Brandon McQuilkin. All rights reserved.
//

#import "AppDelegate.h"

#import "M13InfiniteTabBarController.h"
#import "M13InfiniteTabBarItem.h"
#import "PulsingRequiresAttentionView.h"
#import "ViewController.h"

@interface AppDelegate () <M13InfiniteTabBarControllerDelegate>

@end

@implementation AppDelegate
{
    ViewController *c1;
    ViewController *c2;
    ViewController *c3;
    ViewController *c4;
    ViewController *c5;
    ViewController *c6;
    ViewController *c7;
    ViewController *c8;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Create view controllers
    c1 = [[ViewController alloc] init];
    c1.view.backgroundColor = [UIColor colorWithRed:99.0/255.0 green:218.0/255.0 blue:56.0/255.0 alpha:1.0];
    c1.title = @"Bookmarks";
    UIView *sub1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    sub1.backgroundColor = [UIColor whiteColor];
    [c1.view addSubview:sub1];
    c1.imageView.image = [UIImage imageNamed:@"tab1Icon.png"];
    c2 = [[ViewController alloc] init];
    c2.view.backgroundColor = [UIColor colorWithRed:86.0/255.0 green:183.0/255.0 blue:241.0/255.0 alpha:1.0];
    c2.title = @"Search";
    UIView *sub2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    sub2.backgroundColor = [UIColor whiteColor];
    [c2.view addSubview:sub2];
    c2.imageView.image = [UIImage imageNamed:@"tab2Icon.png"];
    c3 = [[ViewController alloc] init];
    c3.view.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:41.0/255.0 blue:105.0/255.0 alpha:1.0];
    c3.title = @"World";
    UIView *sub3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    sub3.backgroundColor = [UIColor whiteColor];
    [c3.view addSubview:sub3];
    c3.imageView.image = [UIImage imageNamed:@"tab3Icon.png"];
    c4 = [[ViewController alloc] init];
    c4.view.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:59.0/255.0 blue:48.0/255.0 alpha:1.0];
    c4.title = @"Stopwatch";
    UIView *sub4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    sub4.backgroundColor = [UIColor whiteColor];
    [c4.view addSubview:sub4];
    c4.imageView.image = [UIImage imageNamed:@"tab4Icon.png"];
    c5 = [[ViewController alloc] init];
    c5.view.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:94.0/255.0 blue:58.0/255.0 alpha:1.0];
    c5.title = @"Trash";
    UIView *sub5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    sub5.backgroundColor = [UIColor whiteColor];
    [c5.view addSubview:sub1];
    c5.imageView.image = [UIImage imageNamed:@"tab5Icon.png"];
    c6 = [[ViewController alloc] init];
    c6.view.backgroundColor = [UIColor colorWithRed:199.0/255.0 green:67.0/255.0 blue:252.0/255.0 alpha:1.0];
    c6.title = @"Cloud";
    UIView *sub6 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    sub6.backgroundColor = [UIColor whiteColor];
    [c6.view addSubview:sub6];
    c6.imageView.image = [UIImage imageNamed:@"tab6Icon.png"];
    c7 = [[ViewController alloc] init];
    c7.view.backgroundColor = [UIColor colorWithRed:234.0/255.0 green:187.0/255.0 blue:0.0/255.0 alpha:1.0];
    c7.title = @"Root";
    UIView *sub7 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    sub7.backgroundColor = [UIColor whiteColor];
    [c7.view addSubview:sub7];
    c8 = [[ViewController alloc] init];
    c8.view.backgroundColor = [UIColor colorWithRed:136.0/255.0 green:139.0/255.0 blue:144.0/255.0 alpha:1.0];;
    c8.title = @"Info";
    UIView *sub8 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    sub8.backgroundColor = [UIColor whiteColor];
    [c8.view addSubview:sub8];
    c8.imageView.image = [UIImage imageNamed:@"tab7Icon.png"];
    UINavigationController *n7 = [[UINavigationController alloc] initWithRootViewController:c7];
    [n7 pushViewController:c8 animated:NO];
    
    //Create Tab bar items
    M13InfiniteTabBarItem *i1 = [[M13InfiniteTabBarItem alloc] initWithTitle:@"Bookmarks" selectedIconMask:[UIImage imageNamed:@"tab1Solid.png"] unselectedIconMask:[UIImage imageNamed:@"tab1Line.png"]];
    M13InfiniteTabBarItem *i2 = [[M13InfiniteTabBarItem alloc] initWithTitle:@"Search" selectedIconMask:[UIImage imageNamed:@"tab2Solid.png"] unselectedIconMask:[UIImage imageNamed:@"tab2Line.png"]];
    M13InfiniteTabBarItem *i3 = [[M13InfiniteTabBarItem alloc] initWithTitle:@"World" selectedIconMask:[UIImage imageNamed:@"tab3Solid.png"] unselectedIconMask:[UIImage imageNamed:@"tab3Line.png"]];
    M13InfiniteTabBarItem *i4 = [[M13InfiniteTabBarItem alloc] initWithTitle:@"Stopwatch" selectedIconMask:[UIImage imageNamed:@"tab4Solid.png"] unselectedIconMask:[UIImage imageNamed:@"tab4Line.png"]];
    M13InfiniteTabBarItem *i5 = [[M13InfiniteTabBarItem alloc] initWithTitle:@"Trash" selectedIconMask:[UIImage imageNamed:@"tab5Solid.png"] unselectedIconMask:[UIImage imageNamed:@"tab5Line.png"]];
    M13InfiniteTabBarItem *i6 = [[M13InfiniteTabBarItem alloc] initWithTitle:@"Cloud" selectedIconMask:[UIImage imageNamed:@"tab6Solid.png"] unselectedIconMask:[UIImage imageNamed:@"tab6Line.png"]];
    M13InfiniteTabBarItem *i7 = [[M13InfiniteTabBarItem alloc] initWithTitle:@"Info" selectedIconMask:[UIImage imageNamed:@"tab7Solid.png"] unselectedIconMask:[UIImage imageNamed:@"tab7Line.png"]];
    
    //Create View Controller
    M13InfiniteTabBarController *viewController = [[M13InfiniteTabBarController alloc] initWithViewControllers:@[c1,c2,c3,c4,c5,c6,n7] pairedWithInfiniteTabBarItems:@[i1,i2,i3,i4,i5,i6,i7]];
    viewController.delegate = self;
    
    //Set the requires user attention background
    viewController.requiresAttentionBackgroundView = [[PulsingRequiresAttentionView alloc] init];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
    //A view controller requires user attention
    [viewController viewControllerAtIndex:6 requiresUserAttentionWithImportanceLevel:1];
    
    return YES;
}

//Delegate Protocol
- (BOOL)infiniteTabBarController:(M13InfiniteTabBarController *)tabBarController shouldSelectViewContoller:(UIViewController *)viewController
{
    if (viewController == c1) { //Prevent selection of first view controller
        return NO;
    } else {
        return YES;
    }
}

- (void)infiniteTabBarController:(M13InfiniteTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    //Do nothing
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
