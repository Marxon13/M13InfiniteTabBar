//
//  M13InfiniteTabBarItemViewIOS.m
//  M13InfiniteTabBar
/*
 Copyright (c) 2015 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 One does not claim this software as ones own.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "M13InfiniteTabBarItemViewIOS.h"
#import "M13InfiniteTabBarItemIOS.h"
#import <M13BadgeView/M13BadgeView.h>

@interface M13InfiniteTabBarItemViewIOS ()

/**The image view that shows the icon.*/
@property (nonatomic, strong) UIImageView *imageView;

/**The label that shows the title.*/
@property (nonatomic, strong) UILabel *titleLabel;

/**The background image view.*/
@property (nonatomic, strong) UIImageView *backgroundImageView;\

/**The badge view. The badge view should be created by the individual tab bar item, this property is to allow customization of the badge.*/
@property (nonatomic, readonly) M13BadgeView *badgeView;

@end

@implementation M13InfiniteTabBarItemViewIOS

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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    
    //Setup the image view
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeCenter;
    [self.tabContentView addSubview:_imageView];
    
    //Setup the title label
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.clipsToBounds = false;
    [self.tabContentView addSubview:_titleLabel];
}

//--------------------------------------
#pragma mark Item
//--------------------------------------

- (void)setItem:(M13InfiniteTabBarItem *)item
{
    //Remove the previous observer if necessary
    if (self.item) {
        
        [self.item removeObserver:self forKeyPath:@"currentImage"];
        [self.item removeObserver:self forKeyPath:@"currentLabelColor"];
        [self.item removeObserver:self forKeyPath:@"title"];
        [self.item removeObserver:self forKeyPath:@"titleFont"];
        [self.item removeObserver:self forKeyPath:@"titleInsets"];
        [self.item removeObserver:self forKeyPath:@"imageInsets"];
        [self.item removeObserver:self forKeyPath:@"badgeText"];
    }
    
    [super setItem:item];
    
    //Update appearance
    if (self.item) {
        
        [self updateImage:((M13InfiniteTabBarItemIOS *)self.item).currentImage];
        [self updateLabelColor:((M13InfiniteTabBarItemIOS *)self.item).currentLabelColor];
        self.titleLabel.font = ((M13InfiniteTabBarItemIOS *)self.item).titleFont;
        self.titleLabel.text = ((M13InfiniteTabBarItemIOS *)self.item).title;
        [self setBadgeText:((M13InfiniteTabBarItemIOS *)self.item).badgeText];
        
        //The item takes care of rendering the image for us, so all we have to observe is this property.
        [self.item addObserver:self forKeyPath:@"currentImage" options:NSKeyValueObservingOptionNew context:nil];
        [self.item addObserver:self forKeyPath:@"currentLabelColor" options:NSKeyValueObservingOptionNew context:nil];
        [self.item addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
        [self.item addObserver:self forKeyPath:@"titleFont" options:NSKeyValueObservingOptionNew context:nil];
        [self.item addObserver:self forKeyPath:@"titleInsets" options:NSKeyValueObservingOptionNew context:nil];
        [self.item addObserver:self forKeyPath:@"imageInsets" options:NSKeyValueObservingOptionNew context:nil];
        [self.item addObserver:self forKeyPath:@"badgeText" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    if ([keyPath isEqualToString:@"currentImage"]) {
        [self updateImage:change[NSKeyValueChangeNewKey]];
    } else if ([keyPath isEqualToString:@"currentLabelColor"]) {
        [self updateLabelColor:change[NSKeyValueChangeNewKey]];
    } else if ([keyPath isEqualToString:@"titleFont"]) {
        self.titleLabel.font = change[NSKeyValueChangeNewKey];
    } else if ([keyPath isEqualToString:@"title"]) {
        self.titleLabel.text = change[NSKeyValueChangeNewKey];
    } else if ([keyPath isEqualToString:@"titleInsets"]) {
        [self setNeedsLayout];
    } else if ([keyPath isEqualToString:@"imageInsets"]) {
        [self setNeedsLayout];
    } else if ([keyPath isEqualToString:@"badgeText"]) {
        [self setBadgeText:change[NSKeyValueChangeNewKey]];
    }
}

//--------------------------------------
#pragma mark Appearance
//--------------------------------------

- (void)updateImage:(UIImage *)image
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _imageView.image = image;
    });
}

- (void)updateLabelColor:(UIColor *)color
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _titleLabel.textColor = color;
    });
}

- (void)setBadgeText:(NSString *)badgeText
{
    M13BadgeView *badgeView = self.badgeView;
    //Check to see if the badge needs to be removed or shown
    if ((badgeText == nil || [badgeText isEqualToString:@""] || [badgeText isEqualToString:@"0"]) && badgeView.superview == _imageView) {
        
        [UIView animateWithDuration:0.2 animations:^{
            //Hide it nicely first.
            badgeView.alpha = 0.0;
        } completion:^(BOOL finished) {
            //Remove it
            [badgeView removeFromSuperview];
            badgeView.text = badgeText;
        }];
    } else if ((badgeText != nil && ![badgeText isEqualToString:@""] && ![badgeText isEqualToString:@"0"]) && badgeView.superview == nil) {
        //Create the badge view if necessary
        if (!badgeView) {
            badgeView = [[M13BadgeView alloc] init];
            badgeView.horizontalAlignment = M13BadgeViewHorizontalAlignmentRight;
            badgeView.verticalAlignment = M13BadgeViewVerticalAlignmentTop;
            badgeView.frame = CGRectMake(0, 0, badgeView.frame.size.width, 18.0);
            badgeView.font = [UIFont systemFontOfSize:12.0];
        }
        
        //Prepare for the animation
        badgeView.alpha = 0.0;
        [_imageView addSubview:badgeView];
        [badgeView layoutSubviews];
        [self layoutSubviews];
        badgeView.text = badgeText;
        
        //Show
        [UIView animateWithDuration:0.2 animations:^{
            badgeView.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
        
    } else {
        //Just update the text
        badgeView.text = badgeText;
    }

}

//--------------------------------------
#pragma mark Layout
//--------------------------------------

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //Update the image view
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    if (self.item) {
        imageEdgeInsets = ((M13InfiniteTabBarItemIOS *)self.item).imageInsets;
    }
    self.imageView.frame = CGRectMake(imageEdgeInsets.left, imageEdgeInsets.top, self.tabContentView.frame.size.width - imageEdgeInsets.left - imageEdgeInsets.right, self.tabContentView.frame.size.height - imageEdgeInsets.top - imageEdgeInsets.bottom);
    
    //Update the label
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    if (self.item) {
        labelEdgeInsets = ((M13InfiniteTabBarItemIOS *)self.item).titleInsets;
    }
    self.titleLabel.frame = CGRectMake(labelEdgeInsets.left, labelEdgeInsets.top, self.tabContentView.frame.size.width - labelEdgeInsets.left - labelEdgeInsets.right, self.tabContentView.frame.size.height - labelEdgeInsets.top - labelEdgeInsets.bottom);
    
    //Badge View
    M13BadgeView *badgeView = self.badgeView;
    if (badgeView) {
        //Relative to the image view frame
        badgeView.frame = CGRectMake(((_imageView.frame.size.width / 2.0) + (_imageView.image.size.width / 2.0)) - (badgeView.frame.size.width / 2.0) , badgeView.frame.size.height / 2.0, badgeView.frame.size.width, badgeView.frame.size.height);
    }
}

@end
