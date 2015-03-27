//
//  SamplesTableViewController.m
//  M13InfiniteTabBar
//
//  Created by Brandon McQuilkin on 3/24/15.
//  Copyright (c) 2015 BrandonMcQuilkin. All rights reserved.
//

#import "SamplesTableViewController.h"
#import "M13InfiniteTabBarController.h"
#import "M13InfiniteTabBarItemIOS.h"
#import "BasicViewController.h"
#import "ChildTableViewController.h"

@interface SamplesTableViewController () <M13InfiniteTabBarControllerConfigurationDelegate>

@end

@implementation SamplesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"basicViewControllerSegue"]) {
        //Setup the basic view controller
        //[self.navigationController setNavigationBarHidden:true animated:true];
        M13InfiniteTabBarController *vc = segue.destinationViewController;
        vc.configurationDelegate = self;
    }
}

- (NSArray *)viewControllersToDisplayInInfiniteTabBarController:(M13InfiniteTabBarController *)controller
{
    UIStoryboard *storyboard = self.storyboard;
    NSMutableArray *viewControllers = [NSMutableArray array];
    
    BasicViewController *vc1 = [storyboard instantiateViewControllerWithIdentifier:@"BasicViewController"];
    vc1.image = [[UIImage imageNamed:@"BookmarksIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    vc1.imageTintColor = [UIColor colorWithHue:0 saturation:0.92 brightness:0.75 alpha:1];
    vc1.view.backgroundColor = [UIColor colorWithHue:1 saturation:0.78 brightness:1 alpha:1];
    vc1.title = @"Bookmarks";
    vc1.infiniteTabBarItem = [[M13InfiniteTabBarItemIOS alloc] initWithTitle:@"Bookmarks" image:[[UIImage imageNamed:@"Bookmarks"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] selectedImage:[[UIImage imageNamed:@"BookmarksSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [viewControllers addObject:vc1];
    
    BasicViewController *vc2 = [storyboard instantiateViewControllerWithIdentifier:@"BasicViewController"];
    vc2.image = [[UIImage imageNamed:@"CloudIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    vc2.imageTintColor = [UIColor colorWithHue:0.07 saturation:0.82 brightness:0.86 alpha:1];
    vc2.view.backgroundColor = [UIColor colorWithHue:0.08 saturation:0.8 brightness:1 alpha:1];
    vc2.title = @"Cloud";
    vc2.infiniteTabBarItem = [[M13InfiniteTabBarItemIOS alloc] initWithTitle:@"Cloud" image:[[UIImage imageNamed:@"Cloud"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] selectedImage:[[UIImage imageNamed:@"CloudSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [viewControllers addObject:vc2];
    
    BasicViewController *vc3 = [storyboard instantiateViewControllerWithIdentifier:@"BasicViewController"];
    vc3.image = [[UIImage imageNamed:@"DownloadIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    vc3.imageTintColor = [UIColor colorWithHue:0.37 saturation:0.95 brightness:0.5 alpha:1];
    vc3.view.backgroundColor = [UIColor colorWithHue:0.39 saturation:1 brightness:0.68 alpha:1];
    vc3.title = @"Downloads";
    vc3.infiniteTabBarItem = [[M13InfiniteTabBarItemIOS alloc] initWithTitle:@"Downloads" image:[[UIImage imageNamed:@"Download"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] selectedImage:[[UIImage imageNamed:@"DownloadSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [viewControllers addObject:vc3];
    
    BasicViewController *vc4 = [storyboard instantiateViewControllerWithIdentifier:@"BasicViewController"];
    vc4.image = [[UIImage imageNamed:@"FavoritesIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];\
    vc4.imageTintColor = [UIColor colorWithHue:0.46 saturation:1 brightness:0.7 alpha:1];
    vc4.view.backgroundColor = [UIColor colorWithHue:0.46 saturation:1 brightness:0.86 alpha:1];
    vc4.title = @"Favorites";
    vc4.infiniteTabBarItem = [[M13InfiniteTabBarItemIOS alloc] initWithTitle:@"Favorites" image:[[UIImage imageNamed:@"Favorites"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] selectedImage:[[UIImage imageNamed:@"FavoritesSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [viewControllers addObject:vc4];
    
    BasicViewController *vc5 = [storyboard instantiateViewControllerWithIdentifier:@"BasicViewController"];
    vc5.image = [[UIImage imageNamed:@"HistoryIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    vc5.imageTintColor = [UIColor colorWithHue:0.63 saturation:0.82 brightness:0.78 alpha:1];
    vc5.view.backgroundColor = [UIColor colorWithHue:0.61 saturation:0.79 brightness:0.97 alpha:1];
    vc5.title = @"History";
    vc5.infiniteTabBarItem = [[M13InfiniteTabBarItemIOS alloc] initWithTitle:@"History" image:[[UIImage imageNamed:@"History"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] selectedImage:[[UIImage imageNamed:@"HistorySelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [viewControllers addObject:vc5];
    
    BasicViewController *vc65 = [storyboard instantiateViewControllerWithIdentifier:@"BasicViewController"];
    vc65.image = [[UIImage imageNamed:@"GlobalIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    vc65.imageTintColor = [UIColor colorWithHue:0.16 saturation:0.64 brightness:0.89 alpha:1];
    vc65.view.backgroundColor = [UIColor colorWithHue:0.16 saturation:0.64 brightness:0.98 alpha:1];
    vc65.title = @"Global";
    
    UINavigationController *nc6 = [[UINavigationController alloc] initWithRootViewController:vc65];
    nc6.infiniteTabBarItem = [[M13InfiniteTabBarItemIOS alloc] initWithTitle:@"Search" image:[[UIImage imageNamed:@"Search"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] selectedImage:[[UIImage imageNamed:@"SearchSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [viewControllers addObject:nc6];
    
    BasicViewController *vc6 = [storyboard instantiateViewControllerWithIdentifier:@"BasicViewController"];
    vc6.image = [[UIImage imageNamed:@"SearchIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    vc6.imageTintColor = [UIColor colorWithHue:0.92 saturation:0.83 brightness:0.82 alpha:1];
    vc6.view.backgroundColor = [UIColor colorWithHue:0.92 saturation:0.82 brightness:0.98 alpha:1];
    vc6.title = @"Search";
    [nc6 pushViewController:vc6 animated:false];
    
    ChildTableViewController *vc7 = [storyboard instantiateViewControllerWithIdentifier:@"ChildTableViewController"];
    vc7.cellLabel = @"Viewed";
    vc7.infiniteTabBarItem = [[M13InfiniteTabBarItemIOS alloc] initWithTitle:@"Most Viewed" image:[[UIImage imageNamed:@"MostViewed"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] selectedImage:[[UIImage imageNamed:@"MostViewedSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [viewControllers addObject:vc7];
    
    return viewControllers;
}

@end
