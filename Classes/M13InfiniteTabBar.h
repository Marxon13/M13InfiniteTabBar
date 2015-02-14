//
//  M13InfiniteTabBar.h
//  M13InfiniteTabBar
/*
 Copyright (c) 2015 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 One does not claim this software as ones own.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <UIKit/UIKit.h>

@class M13InfiniteTabBarItem;
@class M13InfiniteTabBar;

typedef NS_ENUM(NSUInteger, M13InfiniteTabBarSelectionIndicatorLocation) {
    M13InfiniteTabBarSelectionIndicatorLocationTop,
    M13InfiniteTabBarSelectionIndicatorLocationBottom,
};

/**The delegate that reponds to tab bar customization.*/
@protocol M13InfiniteTabBarCustomizationDelegate <NSObject>

/**Sent to the delegate before the customizing modal view is displayed.
 @param tabBar The tab bar that is being customized.
 @param items The items on the customizing modal view.*/
- (void)infiniteTabBar:(M13InfiniteTabBar *)tabBar willBeginCustomizingItems:(NSArray *)items;

/**Sent to the delegate after the customizing modal view is displayed.
 @param tabBar The tab bar that is being customized.
 @param items The items on the customizing modal view.*/
- (void)infiniteTabBar:(M13InfiniteTabBar *)tabBar didBeginCustomizingItems:(NSArray *)items;

/**Sent to the delegate before the customizing modal view is dismissed.
 @param tabBar The tab bar that is being customized.
 @param items The items on the customizing modal view.
 @param changed true if the visible set of items on the tab bar changed; otherwise, false.*/
- (void)infiniteTabBar:(M13InfiniteTabBar *)tabBar willEndCustomizingItems:(NSArray *)items changed:(BOOL)changed;

/**Sent to the delegate after the customizing modal view is dismissed.
 @param tabBar The tab bar that is being customized.
 @param items The items on the customizing modal view.
 @param changed true if the visible set of items on the tab bar changed; otherwise, false.*/
- (void)infiniteTabBar:(M13InfiniteTabBar *)tabBar didEndCustomizingItems:(NSArray *)items changed:(BOOL)changed;

@end

/**The delegate that responds to changes in the tab bar's selection.*/
@protocol M13InfiniteTabBarSelectionDelegate <NSObject>

/**Asks the selection delegate if an item should be selected.
 @param tabBar The tab bar that wants to select the given item.
 @param item The item that the tab bar is asking to select.
 @return Wether or not the item should be selected.*/
- (BOOL)infiniteTabBar:(M13InfiniteTabBar *)tabBar shouldSelectItem:(M13InfiniteTabBarItem *)item;

/**Notifies the selection delegate that an item will be selected.
 @param tabBar The tab bar that will select the given item.
 @param item The item that the tab bar is selecting.*/
- (void)infiniteTabBar:(M13InfiniteTabBar *)tabBar willSelectItem:(M13InfiniteTabBarItem *)item;

/**The delegate method run inside the animation block that performs animations for the tab selection. Any animations run in this block will be run concurrently with the selection animation for the tab bar.
 @param tabBar The tab bar that performing an animation.
 @param item The item that the tab bar is animating the selection for.*/
- (void)infiniteTabBar:(M13InfiniteTabBar *)tabBar concurrentAnimationsForSelectingItem:(M13InfiniteTabBarItem *)item;

/**Notifies the selection delegate that an item was selected.
 @param tabBar The tab bar that did select the given item.
 @param item The item that the tab bar selected.*/
- (void)infiniteTabBar:(M13InfiniteTabBar *)tabBar didSelectItem:(M13InfiniteTabBarItem *)item;

@end

/**A elegant redesign of UITabBar.*/
@interface M13InfiniteTabBar : UIView

//--------------------------------------
/**@name Initalization*/
//--------------------------------------

/**Initalize the tab bar with the given frame.
 @return A new tab bar.*/
- (instancetype)init;

/**Initalize the tab bar with the given frame.
 @param frame The frame to initalize the tab bar with.
 @return A new tab bar.*/
- (instancetype)initWithFrame:(CGRect)frame;

/**Initalize the tab bar with the given frame and items.
 @param frame The frame to initalize the tab bar with.
 @param items The items to initalize the tab bar with.
 @return A new tab bar.*/
-(instancetype)initWithFrame:(CGRect)frame andItems:(NSArray *)items;

/**Initalize the tab bar with the given items.
 @param items The items to initalize the tab bar with.
 @return A new tab bar.*/
- (instancetype)initWithItems:(NSArray *)items;

//--------------------------------------
/**@name Delegates*/
//--------------------------------------

/**The tab bar's customization delegate object.*/
@property (nonatomic, weak) id<M13InfiniteTabBarCustomizationDelegate> customizationDelegate;

/**The tab bar's selection delegate object.*/
@property (nonatomic, weak) id<M13InfiniteTabBarSelectionDelegate> selectionDelegate;

//--------------------------------------
/**@name Configuring Tab Bar Items*/
//--------------------------------------

/**The items displayed on the tab bar.
 @note The items, instances of UITabBarItem, that are visible on the tab bar in the order they appear in this array. Any changes to this property are not animated. Use the setItems:animated: method to animate changes.
 @warning If any tabs are supposed to be the same after the change, use that object, do not initalize a new one. This has to do with the on-screen cells observing the items using KVO.*/
@property (nonatomic, strong) NSArray *items;

/**The currently selected item on the tab bar.
 @note Changing this property’s value provides visual feedback in the user interface, including the running of any associated animations. The selected item displays the tab bar item’s selectedImage image, using the tab bar’s selectedImageTintColor value. To prevent system coloring of an item, provide images using the UIImageRenderingModeAlwaysOriginal rendering mode.*/
@property (nonatomic, strong) M13InfiniteTabBarItem *selectedItem;

/**Sets the items on the tab bar, with or without animation.
 @note If animated is true, the changes are dissolved or the reordering is animated—for example, removed items fade out and new items fade in. This method also adjusts the spacing between items.
 @warning If any tabs are supposed to be the same after the change, use that object, do not initalize a new one. This has to do with the on-screen cells observing the items using KVO.
 @param items: The items to display on the tab bar.
 @param animated: If true, animates the transition to the items; otherwise, does not.*/
- (void)setItems:(NSArray *)items animated:(BOOL)animated;

/**Tab bar items that require user attention.
 @note Only tab bar items that are in the items array can be added to this array.*/
@property (nonatomic, strong) NSSet *itemsRequiringAttention;

/**Sets the offset to use to adjust the tab bar item positions (The inset between the edge of the tab bar and its items.*/
@property (nonatomic, assign) UIEdgeInsets tabBarItemInsets;

/**Rotate all the tab bar items in the tab bar to the given angle.
 @param angle The angle to rotate the tab bar items to in radians.*/
- (void)rotateItemsToAngle:(CGFloat)angle;

//--------------------------------------
/**@name Supporting User Customization of Tab Bars*/
//--------------------------------------

/**Presents a modal view allowing the user to customize the tab bar by adding, removing, and rearranging items on the tab bar.
 @note  Use this method to start customizing a tab bar. For example, create an Edit button that invokes this method when tapped. A modal view appears displaying all the items in items with a Done button at the top. Tapping the Done button dismisses the modal view. If the selected item is removed from the tab bar, the selectedItem property is set to nil. Set the delegate property to an object conforming to the M13InfiniteTabBarDelegate protocol to further modify this behavior.
 @param items The items to display on the modal view that can be rearranged. The items parameter should contain all items that can be added to the tab bar. Visible items not in items are fixed in place—they can not be removed or replaced by the user.*/
- (void)beginCustomizingItems:(NSArray *)items;

/**Dismisses the modal view used to modify items on the tab bar.
 @note Typically, you do not need to use this method because the user dismisses the modal view by tapping the Done button.
 @return true if items on the tab bar changed; otherwise, false.*/
- (BOOL)endCustomizingItems;

/**Returns a Boolean value indicating whether the user is customizing the tab bar.
 @return true if the user is currently customizing the items on the tab bar; otherwise, false. For example, by tapping an Edit button, a modal view appears allowing users to change the items on a tab bar. This method returns true if this modal view is visible.*/
- (BOOL)isCustomizingItems;

//---------------------------------------
/**@name Customizing Tab Bar Appearance*/
//---------------------------------------

/**Wether or not infinite scrolling is enabled.
 @note If there are more tabs than what can fit in the bar, then scrolling will still be enabled. This property just determines if it is infinite or not.*/
@property (nonatomic, assign) BOOL infiniteScrollingEnabled;

/**The tint color to apply to the tab bar background.
 @note This color is applied to the visual effect view unless you set the translucent property to false. Then is is set to the background color property.*/
@property (nonatomic, strong) UIColor *barTintColor;

/**The custom item width for tab bar items, in points.
 @note To specify a custom width for tab bar items, set this property to a positive value, which the tab bar then uses directly. To specify system-defined tab bar item width, use a 0 value, which is the default value for this property. (If you specify a negative value, a tab bar interprets it as 0 and employs a system-defined width.)*/
@property (nonatomic, assign) CGFloat itemWidth;

/**A Boolean value that indicates whether the tab bar is translucent (true) or not (false).
 @note If the tab bar does not have a custom background image, the default value is true.
 If the tab bar does have a custom background image for which any pixel has an alpha value of less than 1.0, the default value is also true. The default value is false if the custom background image is entirely opaque.
 If you set this property to true on a tab bar with an opaque custom background image, the tab bar applies translucency to the image.
 If you set this property to false on a tab bar with a translucent custom background image, the tab bar provides an opaque background for your image and applies a blurring backdrop. The provided opaque background is black if the tab bar has UIBarStyleBlack style, white if the tab bar has UIBarStyleDefault, or the tab bar’s tint color (barTintColor) if you have defined one. The situation is identical if you set this property to false for a tab bar without a custom background image, except the tab bar does not apply a blurring backdrop.*/
@property (nonatomic, assign) BOOL translucent;

/**The background image for the tab bar.
 @note A stretchable background image is stretched; a non-stretchable background image is tiled (refer to the UIImageResizingMode enum in UIImage Class Reference). This image does not move when the tab bar is scrolled.
 A tab bar with a custom background image, even when translucent, does not draw a blur behind itself.*/
@property (nonatomic, strong) UIImage *backgroundImage;

/**Wether or not to show the selection indicator triangle.*/
@property (nonatomic, assign) BOOL showSelectionIndicator;

/**The location of the selection indicator.*/
@property (nonatomic, assign) M13InfiniteTabBarSelectionIndicatorLocation selectionIndicatorLocation;

/**The background visual effect view if we are translucent.*/
@property (nonatomic, strong) UIVisualEffectView *backgroundVisualEffectView;

@end
