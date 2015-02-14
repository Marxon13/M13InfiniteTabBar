//
//  M13InfiniteTabBarItemIOS.h
//  M13InfiniteTabBar
/*
 Copyright (c) 2015 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 One does not claim this software as ones own.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "M13InfiniteTabBarItem.h"

@interface M13InfiniteTabBarItemIOS : M13InfiniteTabBarItem

/**@name Initalization*/

/**
*  Initalize the tab bar with the given title, image, and selected image.
*
*  @param title         The title to display in the tab bar item.
*  @param image         The image to display when not selected.
*  @param selectedImage The image to display when selected.
*
*  @return A new M13InfiniteTabBarItem.
*/
- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage;

/**@name Images*/

/**The image used to represent the item.
 
 By default, the actual selected image is automatically created from the alpha values in the source image. To prevent system coloring, provide images with UIImageRenderingModeAlwaysOriginal.*/
@property (nonatomic, strong) UIImage *image;

/**The image displayed when the tab bar item is selected.
 
 If nil, the value from the image property is used as both the unselected and selected image.
 
 By default, the actual selected image is automatically created from the alpha values in the source image. To prevent system coloring, provide images with UIImageRenderingModeAlwaysOriginal.*/
@property (nonatomic, strong) UIImage *selectedImage;

/**The image that is overlayed onto the icon when it is unselected. This should be the same size as the icon.*/
@property (nonatomic, strong) UIImage *unselectedImageOverlay;

/**The tint color that is overlayed onto the icon when it is unselected. This will show if the `unselectedImageOverlay` is not set. */
@property (nonatomic, strong) UIColor *unselectedImageTintColor;

/**The image that is overlayed onto the icon when it is selected. This should be the same size as the icon.*/
@property (nonatomic, strong) UIImage *selectedImageOverlay;

/**The tint color that is overlayed onto the icon when it is selected. This will show if the `selectedImageOverlay` is not set.*/
@property (nonatomic, strong) UIColor *selectedImageTintColor;

/**The image that is overlayed onto the icon when the tab requires user attention.*/
@property (nonatomic, strong) UIImage *attentionImageOverlay;

/**The tint color that is overlayed onto the icon the tab requires user attention.*/
@property (nonatomic, strong) UIColor *attentionImageTintColor;

/**The offset to use to adjust the image position in the tab bar item.*/
@property (nonatomic, assign) UIEdgeInsets imageInsets;

/**
 *  Retreive the icon for the current state of the tab bar.
 *
 *  @param forceRender Wether or not to force re-render the image.
 *
 *  @return The icon for the current state of the tab bar.
 */
- (UIImage *)iconForCurrentState:(BOOL)forceRender;

/**
 *  The current icon for the current state.
 */
@property (nonatomic, strong, readonly) UIImage *currentImage;

/**The image that will show as the tab bar item's background.
 
 The background Image moves with the tabs. The default is no background, the tab background image would show instead of the tab bar's background.*/
@property (nonatomic, strong) UIImage* backgroundImage;

/**@name Title*/

/**The title displayed on the item.
 You should set this property before adding the item to a bar. The default value is nil.*/
@property (nonatomic, strong) NSString *title;

/**The color of the title text when the item is unselected.*/
@property (nonatomic, strong) UIColor *unselectedTitleColor;

/**The color of the title text when the item is selected.*/
@property (nonatomic, strong) UIColor *selectedTitleColor;

/**The color of the icon text when the tab requires user attention.*/
@property (nonatomic, strong) UIColor *attentionTitleColor;

/**The font of the title. When changing the font, it is suggested to keep the default font point size.*/
@property (nonatomic, strong) UIFont *titleFont;

/**The offset to use to adjust the title position.*/
@property (nonatomic, assign) UIEdgeInsets titleInsets;

/**
 *  The current icon for the current state.
 */
@property (nonatomic, strong, readonly) UIColor *currentLabelColor;

/**@name Badge*/

/**Use this property to set the text of the badge view. Using this property will automatically show and hide the badge view depending on wether the string is empty or not.*/
@property (nonatomic, strong) NSString *badgeText;

@end
