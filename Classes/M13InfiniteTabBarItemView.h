//
//  M13InfiniteTabBarItemViewCollectionViewCell.h
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

@interface M13InfiniteTabBarItemView : UICollectionViewCell

/**@name Tab Bar Item*/

/**
*  The tab bar item that the view represents.
*/
@property (nonatomic, strong) M13InfiniteTabBarItem *item;

/**@name Layout*/

/**
 *  The view that contains all the subviews for the tab. (Use this instead of the UICollectionViewCells' contentView to support rotation.
 */
@property (nonatomic, strong) UIView *tabContentView;

@end
