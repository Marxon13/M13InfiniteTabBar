//
//  M13InfiniteTabBarItemCollectionViewCell.h
//  M13InfiniteTabBar
/*
 Copyright (c) 2015 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 One does not claim this software as ones own.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <UIKit/UIKit.h>

/**
 The object that represents a tab bar item. Just like UITabBar, this object should be interacted with programatically, not the UIView that this item represents. This object when subclassed, should implement all rendering code and storage for the UIViews that this object represents. The view objects should just respond to changes through KVO.
 */
@interface M13InfiniteTabBarItem : NSObject

/**@name Interaction*/

/**
 Wether or not the view controller the tab represents requires the user's attention. If this is set to true, the badge usually changes color, or animates.
 */
@property (nonatomic, assign) BOOL requiresUserAttention;

/**
 Wether or not the view is enabled.
 */
@property (nonatomic, assign) BOOL enabled;

/**
 *  Wether or not the item is selected.
 */
@property (nonatomic, assign) BOOL selected;

/**@name Other Properties*/

/**
 The index of the tab bar item in the list of items. This should only be changed by M13InfiniteTabBar.
 */
@property (nonatomic, assign) NSUInteger index;

/**
 *  The transform of the item.
 */
@property (nonatomic, assign) CGAffineTransform transform;

/**
 *  Returns the class of the view that the tab bar item represents. This should be overriden by every sub class.
 *
 *  @return The class of the view this object represents.
 */
- (Class)representedTabBarItemViewClass;

/**@name Layout*/

/**
 Rotate the item to the given angle. This should rotate all the contents of the tab bar item.
 @note Take a look at the iOS tab bar item sub-class to see how this can be easily implemented.
 @param angle The angle to rotate the tab bar to in radians.
 */
- (void)rotateToAngle:(CGFloat)angle;

/**@name Equality*/

/**
 Determines if two tab bar items are equal.
 @param object The item that is being compared to the receiver.
 @return Wether or not the two items are equal.
 */
- (BOOL)isEqual:(id)object;

@end
