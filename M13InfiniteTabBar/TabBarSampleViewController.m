//
//  TabBarSampleViewController.m
//  M13InfiniteTabBar
//
//  Created by Brandon McQuilkin on 2/3/15.
//  Copyright (c) 2015 BrandonMcQuilkin. All rights reserved.
//

#import "TabBarSampleViewController.h"
#import "M13InfiniteTabBarItemIOS.h"
#import "M13InfiniteTabBar.h"

@interface TabBarSampleViewController ()

@property (nonatomic, assign) BOOL animated;
@property (nonatomic, strong) M13InfiniteTabBar *infiniteTabBar;
@property (nonatomic, strong) NSMutableArray *itemsArray;

@end

@implementation TabBarSampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _animated = true;
    
    _itemsArray = [NSMutableArray array];
    [_itemsArray addObject:[[M13InfiniteTabBarItemIOS alloc] initWithTitle:@"Bookmarks" image:[UIImage imageNamed:@"Bookmarks"] selectedImage:[UIImage imageNamed:@"BookmarksSelected"]]];
    [_itemsArray addObject:[[M13InfiniteTabBarItemIOS alloc] initWithTitle:@"Cloud" image:[UIImage imageNamed:@"Cloud"] selectedImage:[UIImage imageNamed:@"CloudSelected"]]];
    [_itemsArray addObject:[[M13InfiniteTabBarItemIOS alloc] initWithTitle:@"Downloads" image:[UIImage imageNamed:@"Download"] selectedImage:[UIImage imageNamed:@"DownloadSelected"]]];
    [_itemsArray addObject:[[M13InfiniteTabBarItemIOS alloc] initWithTitle:@"Favorites" image:[UIImage imageNamed:@"Favorites"] selectedImage:[UIImage imageNamed:@"FavoritesSelected"]]];
    [_itemsArray addObject:[[M13InfiniteTabBarItemIOS alloc] initWithTitle:@"History" image:[UIImage imageNamed:@"History"] selectedImage:[UIImage imageNamed:@"HistorySelected"]]];
    [_itemsArray addObject:[[M13InfiniteTabBarItemIOS alloc] initWithTitle:@"Search" image:[UIImage imageNamed:@"Search"] selectedImage:[UIImage imageNamed:@"SearchSelected"]]];
    [_itemsArray addObject:[[M13InfiniteTabBarItemIOS alloc] initWithTitle:@"Most Viewed" image:[UIImage imageNamed:@"MostViewed"] selectedImage:[UIImage imageNamed:@"MostViewedSelected"]]];
    
    _infiniteTabBar = [[M13InfiniteTabBar alloc] initWithFrame:CGRectMake((self.view.frame.size.width - self.view.frame.size.width) / 2.0, 80.0, 320.0, 48.0) andItems:[_itemsArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]]];
    _infiniteTabBar.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:_infiniteTabBar];
    
    NSMutableArray *constraints = [[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tabBar]-0-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:@{@"superview": self.view, @"tabBar": _infiniteTabBar}] mutableCopy];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-80.0-[tabBar(48.0)]" options:NSLayoutFormatAlignAllBaseline metrics:nil views:@{@"superview": self.view, @"tabBar": _infiniteTabBar}]];
    [self.view addConstraints:constraints];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundPattern"]];
}

- (void)updateAnimated:(id)sender
{
    UISwitch *animatedSwitch = sender;
    _animated = animatedSwitch.on;
}

- (void)updateBackground:(id)sender
{
    UISegmentedControl *segmentedControl = sender;
    if (segmentedControl.selectedSegmentIndex == 0) {
        _infiniteTabBar.backgroundImage = nil;
        _infiniteTabBar.translucent = true;
        _infiniteTabBar.backgroundColor = [UIColor clearColor];
    } else if (segmentedControl.selectedSegmentIndex == 1) {
        _infiniteTabBar.backgroundImage = nil;
        _infiniteTabBar.backgroundColor = [UIColor grayColor];
        _infiniteTabBar.translucent = false;
    } else {
        _infiniteTabBar.backgroundColor = [UIColor clearColor];
        _infiniteTabBar.translucent = false;
        _infiniteTabBar.backgroundImage = nil;
    }
}

- (void)updateTabs:(id)sender
{
    UISegmentedControl *segmentedControl = sender;
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        [_infiniteTabBar setItems:[_itemsArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]] animated:_animated];
        return;
    }
    
    if (segmentedControl.selectedSegmentIndex == 1) {
        [_infiniteTabBar setItems:[_itemsArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 5)]] animated:_animated];
        return;
    }
    
    if (segmentedControl.selectedSegmentIndex == 2) {
        _infiniteTabBar.infiniteScrollingEnabled = false;
        [_infiniteTabBar setItems:_itemsArray animated:_animated];
        return;
    }
    
    if (segmentedControl.selectedSegmentIndex == 3) {
        _infiniteTabBar.infiniteScrollingEnabled = true;
        [_infiniteTabBar setItems:_itemsArray animated:_animated];
        return;
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
}

@end
