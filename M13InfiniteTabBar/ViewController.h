//
//  ViewController.h
//  M13InfiniteTabBar
//
//  Created by Brandon McQuilkin on 2/13/13.
//  Copyright (c) 2013 Brandon McQuilkin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class M13InfiniteTabBarController;

@interface ViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) M13InfiniteTabBarController *infiniteTabBarController;

- (IBAction)gotoWorld:(id)sender;

@end
