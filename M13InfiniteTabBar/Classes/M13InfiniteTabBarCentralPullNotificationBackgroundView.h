//
//  M13InfiniteTabBarCentralPullNotificationBackgroundView.h
//  M13InfiniteTabBar
/*
 Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 One does not claim this software as ones own.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <UIKit/UIKit.h>

/** The pattern that will be animated during an alert. */
@interface M13InfiniteTabBarCentralPullNotificationBackgroundView : UIView

/** Used to change the notification styling if the notification is important. */
@property (nonatomic, assign) BOOL isEmergency;

/** Used by the tab bar to produce a continous animation. */
@property (nonatomic, readonly) CGFloat notificationPatternRepeatDistance;

/** Fill color for a non emergency */
@property (nonatomic, retain) UIColor *notificationNonEmergencyColor;
/** Fill color for an emergency */
@property (nonatomic, retain) UIColor *notificationEmergencyColor;

@end
