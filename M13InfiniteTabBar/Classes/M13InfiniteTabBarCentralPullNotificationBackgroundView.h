//
//  M13InfiniteTabBarCentralPullNotificationBackgroundView.h
//  M13InfiniteTabBar
//
//  Created by Brandon McQuilkin on 2/13/13.
//  Copyright (c) 2013 Brandon McQuilkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface M13InfiniteTabBarCentralPullNotificationBackgroundView : UIView

//Used to change the notification styling if the notification is important.
@property (nonatomic, assign) BOOL isEmergency;

//Used by the tab bar to produce a continous animation.
@property (nonatomic, readonly) CGFloat notificationPatternRepeatDistance;

//Pattern Colors
@property (nonatomic, retain) UIColor *notificationNonEmergencyColor;
@property (nonatomic, retain) UIColor *notificationEmergencyColor;

@end
