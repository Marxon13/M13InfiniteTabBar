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
    c1.view.backgroundColor = [UIColor redColor];
    c1.title = @"Bone";
    UIView *sub1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    sub1.backgroundColor = [UIColor whiteColor];
    [c1.view addSubview:sub1];
    c2 = [[ViewController alloc] init];
    c2.view.backgroundColor = [UIColor orangeColor];
    c2.title = @"Fish";
    UIView *sub2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    sub2.backgroundColor = [UIColor whiteColor];
    [c2.view addSubview:sub2];
    c3 = [[ViewController alloc] init];
    c3.view.backgroundColor = [UIColor yellowColor];
    c3.title = @"Cat";
    UIView *sub3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    sub3.backgroundColor = [UIColor whiteColor];
    UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    lab3.textAlignment = NSTextAlignmentCenter;
    lab3.text = @"Cat Label";
    lab3.center = c3.view.center;
    lab3.backgroundColor = [UIColor clearColor];
    lab3.textColor = [UIColor grayColor];
    [c3.view addSubview:lab3];
    [c3.view addSubview:sub3];
    c4 = [[ViewController alloc] init];
    c4.view.backgroundColor = [UIColor greenColor];
    c4.title = @"Dog"; 
    UIView *sub4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    sub4.backgroundColor = [UIColor whiteColor];
    [c4.view addSubview:sub4];
    c5 = [[ViewController alloc] init];
    c5.view.backgroundColor = [UIColor blueColor];
    c5.title = @"Snail";
    UIView *sub5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    sub5.backgroundColor = [UIColor whiteColor];
    [c5.view addSubview:sub1];
    c6 = [[ViewController alloc] init];
    c6.view.backgroundColor = [UIColor lightGrayColor];
    c6.title = @"Rabbit";
    UIView *sub6 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    sub6.backgroundColor = [UIColor whiteColor];
    [c6.view addSubview:sub6];
    c7 = [[ViewController alloc] init];
    c7.view.backgroundColor = [UIColor darkGrayColor];
    c7.title = @"Root";
    UIView *sub7 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    sub7.backgroundColor = [UIColor whiteColor];
    [c7.view addSubview:sub7];
    c8 = [[ViewController alloc] init];
    c8.view.backgroundColor = [UIColor purpleColor];
    c8.title = @"Bird";
    UIView *sub8 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    sub8.backgroundColor = [UIColor whiteColor];
    [c8.view addSubview:sub8];
    UINavigationController *n7 = [[UINavigationController alloc] initWithRootViewController:c7];
    [n7 pushViewController:c8 animated:NO];
    
    //Create Tab bar items
    M13InfiniteTabBarItem *i1 = [[M13InfiniteTabBarItem alloc] initWithTitle:@"Bone" andIcon:[UIImage imageNamed:@"tab1.png"]];
    M13InfiniteTabBarItem *i2 = [[M13InfiniteTabBarItem alloc] initWithTitle:@"Fish" andIcon:[UIImage imageNamed:@"tab2.png"]];
    M13InfiniteTabBarItem *i3 = [[M13InfiniteTabBarItem alloc] initWithTitle:@"Cat" andIcon:[UIImage imageNamed:@"tab3.png"]];
    M13InfiniteTabBarItem *i4 = [[M13InfiniteTabBarItem alloc] initWithTitle:@"Dog" andIcon:[UIImage imageNamed:@"tab4.png"]];
    M13InfiniteTabBarItem *i5 = [[M13InfiniteTabBarItem alloc] initWithTitle:@"Snail" andIcon:[UIImage imageNamed:@"tab5.png"]];
    M13InfiniteTabBarItem *i6 = [[M13InfiniteTabBarItem alloc] initWithTitle:@"Rabbit" andIcon:[UIImage imageNamed:@"tab6.png"]];
    M13InfiniteTabBarItem *i7 = [[M13InfiniteTabBarItem alloc] initWithTitle:@"Bird" andIcon:[UIImage imageNamed:@"tab7.png"]];
    
    //Create View Controller
    M13InfiniteTabBarController *viewController = [[M13InfiniteTabBarController alloc] initWithViewControllers:@[c1,c2,c3,c4,c5,c6,n7] pairedWithInfiniteTabBarItems:@[i1,i2,i3,i4,i5,i6,i7]];
    viewController.delegate = self;
    
    //Add alert view
    UIViewController *alert = [[UIViewController alloc] init];
    alert.view.backgroundColor = [UIColor underPageBackgroundColor];
    
    [viewController setCentralViewController:alert];
    [viewController showAlertForCentralViewControllerIsEmergency:YES];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
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
