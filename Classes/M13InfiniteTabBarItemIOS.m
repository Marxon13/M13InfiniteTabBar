//
//  M13InfiniteTabBarItemIOS.m
//  M13InfiniteTabBar
/*
 Copyright (c) 2015 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 One does not claim this software as ones own.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "M13InfiniteTabBarItemIOS.h"
#import <M13BadgeView/M13BadgeView.h>
#import "M13InfiniteTabBarItemViewIOS.h"

@interface M13InfiniteTabBarItemIOS ()

/**Make the badge property readwrite.*/
@property (nonatomic, strong, readwrite) M13BadgeView *badgeView;

@property (nonatomic, strong) UIImage *currentImage;
@property (nonatomic, strong) UIColor *currentLabelColor;

@property (nonatomic, assign) BOOL selectionStorage;
@property (nonatomic, assign) BOOL enabledStorage;
@property (nonatomic, assign) BOOL attentionStorage;

@end

@implementation M13InfiniteTabBarItemIOS

//--------------------------------------
#pragma mark Initalization
//--------------------------------------

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage
{
    self = [super init];
    if (self) {
        _title = title;
        _image = image;
        _selectedImage = selectedImage;
        [self setup];
    }
    return self;
}

- (void)setup
{
    //Set the default colors
    _selectedImageTintColor = [[[UIApplication sharedApplication] delegate] window].tintColor;;
    _selectedTitleColor = [[[UIApplication sharedApplication] delegate] window].tintColor;
    _unselectedImageTintColor = [[[UIApplication sharedApplication] delegate] window].tintColor;
    _unselectedTitleColor = [[[UIApplication sharedApplication] delegate] window].tintColor;
    _attentionImageTintColor = [UIColor colorWithRed:0.98 green:0.24 blue:0.15 alpha:1.0];
    _attentionTitleColor = [UIColor colorWithRed:0.98 green:0.24 blue:0.15 alpha:1.0];
    
    //If the tint color was not retreived:
    if (_selectedImageTintColor == nil) {
        _selectedImageTintColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
        _selectedTitleColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
        _unselectedImageTintColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
        _unselectedTitleColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    }
    
    //Set the default insets
    _imageInsets = UIEdgeInsetsMake(4.0, 4.0, 18.0, 4.0);
    _titleInsets = UIEdgeInsetsMake(32.0, 2.0, 5.0, 2.0);
    
    //Set the default font
    _titleFont = [UIFont systemFontOfSize:9.0];
    
    //Set index
    self.index = NSNotFound;
    
    //Force update
    self.currentImage = [self iconForCurrentState:true];
    self.currentLabelColor = [self labelColorForCurrentState];
}

- (void)createSubviews
{
    _badgeView = [[M13BadgeView alloc] init];
    _badgeView = [[M13BadgeView alloc] init];
    _badgeView.horizontalAlignment = M13BadgeViewHorizontalAlignmentRight;
    _badgeView.verticalAlignment = M13BadgeViewVerticalAlignmentTop;
    _badgeView.frame = CGRectMake(0, 0, _badgeView.frame.size.width, 18.0);
    _badgeView.font = [UIFont systemFontOfSize:12.0];
    _badgeView.alpha = 0.0;
}

- (Class)representedTabBarItemViewClass
{
    return [M13InfiniteTabBarItemViewIOS class];
}

//--------------------------------------
#pragma mark Badge
//--------------------------------------

- (void)setBadgeText:(NSString *)badgeText
{
    _badgeText = badgeText;
}

//--------------------------------------
#pragma mark Appearance Customization
//--------------------------------------

- (void)setImage:(UIImage *)image
{
    _image = image;
    //Update the icon
    _currentImage = [self iconForCurrentState:true];
}

- (void)setSelectedImage:(UIImage *)selectedImage
{
    _selectedImage = selectedImage;
    //Update the icon if necessary
    if (self.selected) {
        _currentImage = [self iconForCurrentState:true];
    }
}

- (void)setUnselectedImageOverlay:(UIImage *)unselectedImageOverlay
{
    _unselectedImageOverlay = unselectedImageOverlay;
    //Update the icon if necessary
    if (!self.selected && !self.requiresUserAttention) {
        _currentImage = [self iconForCurrentState:true];
    }
}

- (void)setUnselectedImageTintColor:(UIColor *)unselectedImageTintColor
{
    _unselectedImageTintColor = unselectedImageTintColor;
    //Update the icon if necessary
    if (!self.selected && !self.requiresUserAttention) {
        _currentImage = [self iconForCurrentState:true];
    }
}

- (void)setSelectedImageOverlay:(UIImage *)selectedImageOverlay
{
    _selectedImageOverlay = selectedImageOverlay;
    //Update the icon if necessary
    if (self.selected) {
        _currentImage = [self iconForCurrentState:true];
    }
}

- (void)setSelectedImageTintColor:(UIColor *)selectedImageTintColor
{
    _selectedImageTintColor = selectedImageTintColor;
    //Update the icon if necessary
    if (self.selected) {
        _currentImage = [self iconForCurrentState:true];
    }
}

- (void)setAttentionImageOverlay:(UIImage *)attentionImageOverlay
{
    _selectedImageOverlay = attentionImageOverlay;
    //Update the icon if necessary
    if (self.requiresUserAttention) {
        _currentImage = [self iconForCurrentState:true];
    }
}

- (void)setAttentionImageTintColor:(UIColor *)attentionImageTintColor
{
    _attentionImageTintColor = attentionImageTintColor;
    //Update the icon if necessary
    if (self.requiresUserAttention) {
        _currentImage = [self iconForCurrentState:true];
    }
}

- (void)setUnselectedTitleColor:(UIColor *)unselectedTitleColor
{
    _unselectedTitleColor = unselectedTitleColor;
    //Update the title label if necessary
    if (!self.selected && !self.requiresUserAttention) {
        self.currentLabelColor = [self labelColorForCurrentState];
    }
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor
{
    _selectedTitleColor = selectedTitleColor;
    //Update the title label if necessary
    if (self.selected) {
        self.currentLabelColor = [self labelColorForCurrentState];
    }
}

- (void)setAttentionTitleColor:(UIColor *)attentionTitleColor
{
    _attentionTitleColor = attentionTitleColor;
    //Update the title label if necessary
    if (!self.selected && self.requiresUserAttention) {
        self.currentLabelColor = [self labelColorForCurrentState];
    }
}

- (UIImage *)iconForCurrentState:(BOOL)force
{
    if (_selectionStorage == self.selected && _attentionStorage == self.requiresUserAttention && _enabledStorage == self.enabled && !force) {
        return _currentImage;
    }
    
    _selectionStorage = self.selected;
    _attentionStorage = self.requiresUserAttention;
    _enabledStorage = self.enabled;
    
    //Get the proper icon
    UIImage *icon;
    if (self.selected) {
        icon = _selectedImage;
    } else {
        icon = _image;
    }
    
    //If the icon does not allow tint, return it.
    if (icon.renderingMode == UIImageRenderingModeAlwaysOriginal) {
        return icon;
    }
    
    //Prepare to draw, select the proper parameters based on the current state.
    UIImage *overlayImage;
    UIColor *tintColor;
    if (!self.enabled) {
        tintColor = [UIColor lightGrayColor];
    } else if (self.requiresUserAttention) {
        overlayImage = _attentionImageOverlay;
        tintColor = _attentionImageTintColor;
    } else if (self.selected) {
        overlayImage = _selectedImageOverlay;
        tintColor = _selectedImageTintColor;
    } else {
        overlayImage = _unselectedImageOverlay;
        tintColor = _unselectedImageTintColor;
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, icon.size.width * icon.scale, icon.size.height * icon.scale, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    if (context == NULL) {
        CGColorSpaceRelease(colorSpace);
        return nil;
    }
    
    if (overlayImage) {
        //Draw the image centered
        CGContextDrawImage(context, CGRectMake((icon.size.width - overlayImage.size.width) / 2.0, (icon.size.height - overlayImage.size.height) / 2.0, overlayImage.size.width, overlayImage.size.height), overlayImage.CGImage);
    } else {
        //Fill with color
        CGContextSetFillColorWithColor(context, tintColor.CGColor);
        CGContextFillRect(context, CGRectMake(0, 0, icon.size.width * icon.scale, icon.size.height * icon.scale));
    }
    
    //Get the background and clean up
    CGImageRef iconBackground = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    //Create the mask
    CGContextRef contextMask = CGBitmapContextCreate(nil, CGImageGetWidth(icon.CGImage), CGImageGetHeight(icon.CGImage), 8, 0, nil, (CGBitmapInfo)kCGImageAlphaOnly);
    CGContextDrawImage(contextMask, CGRectMake(0, 0, icon.size.width * icon.scale, icon.size.height * icon.scale), icon.CGImage);
    CGImageRef mask = CGBitmapContextCreateImage(contextMask);
    
    CGContextRelease(contextMask);
    
    //Create the final icon
    CGImageRef finalIcon = CGImageCreateWithMask(iconBackground, mask);
    
    //Create the image
    UIImage *finalImage = [[UIImage alloc] initWithCGImage:finalIcon scale:icon.scale orientation:icon.imageOrientation];
    
    //Cleanup
    CGImageRelease(mask);
    CGImageRelease(finalIcon);
    CGImageRelease(iconBackground);
    
    return finalImage;
}

- (UIColor *)labelColorForCurrentState
{
    //Return the label color for the current state of the tab.
    if (!self.enabled) {
        return [UIColor lightGrayColor];
    } else if (self.requiresUserAttention) {
        return _attentionTitleColor;
    } else if (self.selected) {
        return _selectedTitleColor;
    } else {
        return _unselectedTitleColor;
    }
}

//--------------------------------------
#pragma mark Interaction
//--------------------------------------

- (void)setRequiresUserAttention:(BOOL)requiresUserAttention
{
    [super setRequiresUserAttention:requiresUserAttention];
    self.currentImage = [self iconForCurrentState:false];
    self.currentLabelColor = [self labelColorForCurrentState];
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    self.currentImage = [self iconForCurrentState:false];
    self.currentLabelColor = [self labelColorForCurrentState];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.currentImage = [self iconForCurrentState:false];
    self.currentLabelColor = [self labelColorForCurrentState];
}

//--------------------------------------
#pragma mark Other
//--------------------------------------

- (BOOL)isEqual:(M13InfiniteTabBarItemIOS *)other
{
    if ([self.title isEqualToString:other.title]) {
        return true;
    }
    return false;
}

- (NSUInteger)hash
{
    return [self.title hash];
}

@end
