//
//  TabBarItemSampleIOSViewController.m
//  M13InfiniteTabBar
//
//  Created by Brandon McQuilkin on 2/2/15.
//  Copyright (c) 2015 BrandonMcQuilkin. All rights reserved.
//

#import "TabBarItemSampleIOSViewController.h"
#import "M13InfiniteTabBarItemIOS.h"
#import "M13InfiniteTabBarItemViewIOS.h"

@interface TabBarItemSampleIOSViewController ()

@property (nonatomic, strong) M13InfiniteTabBarItemIOS *standardItem;
@property (nonatomic, strong) M13InfiniteTabBarItemViewIOS *standardView;
@property (nonatomic, strong) M13InfiniteTabBarItemIOS *originalItem;
@property (nonatomic, strong) M13InfiniteTabBarItemViewIOS *originalView;
@property (nonatomic, strong) M13InfiniteTabBarItemIOS *badgeItem;
@property (nonatomic, strong) M13InfiniteTabBarItemViewIOS *badgeView;

@end

@implementation TabBarItemSampleIOSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _standardItem = [[M13InfiniteTabBarItemIOS alloc] initWithTitle:@"Bookmarks" image:[UIImage imageNamed:@"Bookmarks"] selectedImage:[UIImage imageNamed:@"BookmarksSelected"]];
    _standardView = [[M13InfiniteTabBarItemViewIOS alloc] initWithFrame:CGRectMake(20, 80, 64, 48)];
    _standardView.item = _standardItem;
    [self.view addSubview:_standardView];
    
    //_originalItem = [[M13InfiniteTabBarItemIOS alloc] initWithTitle:@"Contacts" image:[[UIImage imageNamed:@"Contacts"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"ContactsSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    _originalItem = [[M13InfiniteTabBarItemIOS alloc] initWithTitle:@"Contacts" image:[UIImage imageNamed:@"Contacts"] selectedImage:[UIImage imageNamed:@"ContactsSelected"]];
    _originalView = [[M13InfiniteTabBarItemViewIOS alloc] initWithFrame:CGRectMake(104, 80, 64, 48)];
    _originalView.item = _originalItem;
    [self.view addSubview:_originalView];
    
    _badgeItem = [[M13InfiniteTabBarItemIOS alloc] initWithTitle:@"Cloud" image:[UIImage imageNamed:@"Cloud"] selectedImage:[UIImage imageNamed:@"CloudSelected"]];
    _badgeView = [[M13InfiniteTabBarItemViewIOS alloc] initWithFrame:CGRectMake(20, 168, 64, 48)];
    _badgeView.item = _badgeItem;
    _badgeItem.badgeText = @"13";
    [self.view addSubview:_badgeView];
    
    
}

- (void)updateRotation:(id)sender
{
    UISegmentedControl *control = sender;
    CGFloat angle = 0.0;
    if (control.selectedSegmentIndex == 1) {
        angle = M_PI_2;
    } else if (control.selectedSegmentIndex == 2) {
        angle = M_PI;
    } else if (control.selectedSegmentIndex == 3) {
        angle = M_PI + M_PI_2;
    }
    
    [_standardItem rotateToAngle:angle];
    [_originalItem rotateToAngle:angle];
    [_badgeItem rotateToAngle:angle];
}

- (void)updateState:(id)sender
{
    UISegmentedControl *control = sender;
    if (control.selectedSegmentIndex == 0) {
        _standardItem.selected = false;
        _standardItem.requiresUserAttention = false;
        _standardItem.enabled = true;
        _originalItem.selected = false;
        _originalItem.requiresUserAttention = false;
        _originalItem.enabled = true;
        _badgeItem.selected = false;
        _badgeItem.requiresUserAttention = false;
        _badgeItem.enabled = true;
    } else if (control.selectedSegmentIndex == 1) {
        _standardItem.selected = true;
        _standardItem.requiresUserAttention = false;
        _standardItem.enabled = true;
        _originalItem.selected = true;
        _originalItem.requiresUserAttention = false;
        _originalItem.enabled = true;
        _badgeItem.selected = true;
        _badgeItem.requiresUserAttention = false;
        _badgeItem.enabled = true;
    } else if (control.selectedSegmentIndex == 2) {
        _standardItem.selected = false;
        _standardItem.requiresUserAttention = true;
        _standardItem.enabled = true;
        _originalItem.selected = false;
        _originalItem.requiresUserAttention = true;
        _originalItem.enabled = true;
        _badgeItem.selected = false;
        _badgeItem.requiresUserAttention = true;
        _badgeItem.enabled = true;
    } else if (control.selectedSegmentIndex == 3) {
        _standardItem.selected = false;
        _standardItem.requiresUserAttention = false;
        _standardItem.enabled = false;
        _originalItem.selected = false;
        _originalItem.requiresUserAttention = false;
        _originalItem.enabled = false;
        _badgeItem.selected = false;
        _badgeItem.requiresUserAttention = false;
        _badgeItem.enabled = false;
    }
}

@end
