//
//  M13InfiniteTabBarItem.h
//  M13InfiniteTabBar
//
//  Created by Brandon McQuilkin on 2/13/13.
//  Copyright (c) 2013 Brandon McQuilkin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class M13InfiniteTabBarBadgeView;

@interface M13InfiniteTabBarItem : UIView

//Initilization, icon should be 30x30px or 60x60px for @2x, specifing a larger image will incur performance costs.
- (id)initWithTitle:(NSString *)title andIcon:(UIImage *)icon;

//The Background Image moves with the tabs. default is no background this would show instead of the tab bar's background. This image should be 64x50px on the retina iPhone, and 70x50px on the retina iPad, I trust that you can divide by two to get the non retina values.
@property (nonatomic, retain) UIImage *backgroundImage UI_APPEARANCE_SELECTOR;

//Appearances
@property (nonatomic, retain) UIFont *titleFont UI_APPEARANCE_SELECTOR; //I suggest leaving the font size alone, keep it at 7.0
@property (nonatomic, retain) UIImage *selectedIconOverlayImage UI_APPEARANCE_SELECTOR; //Should be the same size as the icon
@property (nonatomic, retain) UIColor *selectedIconTintColor UI_APPEARANCE_SELECTOR; //Color of selected items will show if selected image is nil
@property (nonatomic, retain) UIImage *unselectedIconOverlayImage UI_APPEARANCE_SELECTOR; //Should be the same size as the icon
@property (nonatomic, retain) UIColor *unselectedIconTintColor UI_APPEARANCE_SELECTOR; //Color of unselected item will show if unselected image is nil
@property (nonatomic, retain) UIColor *selectedTitleColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, retain) UIColor *unselectedTitleColor UI_APPEARANCE_SELECTOR;

//Badges TO BE IMPLEMENTED
//@property (nonatomic, retain) M13InfiniteTabBarBadgeView *badge;

//Do not use below methods, they are for use by the Controllers
- (void)setSelected:(BOOL)selected; //Used to set the highlight of a view
- (id)copy; //Quickly duplicate view
- (void)rotateToAngle:(CGFloat)angle; //handling view rotation

@end
