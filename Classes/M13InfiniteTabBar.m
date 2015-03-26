//
//  M13InfiniteTabBar.m
//  M13InfiniteTabBar
/*
 Copyright (c) 2015 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 One does not claim this software as ones own.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "M13InfiniteTabBar.h"
#import "M13InfiniteTabBarFlowLayout.h"
#import "M13InfiniteTabBarItem.h"
#import "M13InfiniteTabBarItemView.h"
#import <M13Toolkit/NSArray+Changes.h>
#import <M13Toolkit/UICollectionView+AutoBatchUpdates.h>
#import <tgmath.h>

typedef NS_ENUM(NSUInteger, M13InfiniteTabBarLayout) {
    M13InfiniteTabBarLayoutStatic,
    M13InfiniteTabBarLayoutScrolling,
    M13InfiniteTabBarLayoutInfinite
};

@interface M13InfiniteTabBar () <UIScrollViewDelegate, UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

//---------------------------------------
/**@name Subviews*/
//---------------------------------------

/**The scroll view that is the core of the tab bar.*/
@property (nonatomic, strong) UICollectionView *tabCollectionView;

/**The background image view, if the background image is set. If we are also translucent, this will appear over the visual effect view.*/
@property (nonatomic, strong) UIImageView *backgroundImageView;

//---------------------------------------
/**@name Interaction*/
//---------------------------------------

/**A flag to set on selection failure. It prevents the tab bar from "reselecting" the old tab, when a new selection is denied.*/
@property (nonatomic, assign) BOOL selectionFailure;

//---------------------------------------
/**@name Scroll Delegate*/
//---------------------------------------

/**A flag to set when the scroll view is being dragged vs. when it is being animated.*/
@property (nonatomic, assign) BOOL scrollViewIsDragging;

//---------------------------------------
/**@name Layout*/
//---------------------------------------

/**Helpers for hanling the animations for going between layouts.*/
@property (nonatomic, assign) NSUInteger previousSectionCount;
@property (nonatomic, strong) NSArray *previousItems;

/**Wether or not the tab bar items changed after the last layout.*/
@property (nonatomic, assign) BOOL itemsChangedSinceLastLayout;
@property (nonatomic, assign) M13InfiniteTabBarLayout layoutType;

/**How many sections do we want to display for the infinite scrolling? (Not integer max)*/
@property (nonatomic, assign) NSUInteger numberOfSectionsForInfiniteScrolling;
@property (nonatomic, assign) NSUInteger centerSectionForInfiniteScrolling;

@end

@implementation M13InfiniteTabBar

//---------------------------------------
#pragma mark Initalization
//---------------------------------------

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self internalSetup];
    }
    return self;
}

- (instancetype)initWithItems:(NSArray *)items
{
    self = [super init];
    if (self) {
        [self internalSetup];
        self.items = items;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self internalSetup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andItems:(NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self) {
        [self internalSetup];
        self.items = items;
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self internalSetup];
    }
    return self;
}

- (void)internalSetup
{
    //Set defaults
    _items = [[NSArray alloc] init];
    _itemsRequiringAttention = [[NSSet alloc] init];
    _tabBarItemInsets = UIEdgeInsetsZero;
    _infiniteScrollingEnabled = YES;
    _barTintColor = [UIColor clearColor];
    _itemWidth = 0.0;
    _translucent = YES;
    _showSelectionIndicator = YES;
    _selectionIndicatorLocation = M13InfiniteTabBarSelectionIndicatorLocationTop;
    _selectionFailure = NO;
    _scrollViewIsDragging = NO;
    _itemsChangedSinceLastLayout = NO;
    _numberOfSectionsForInfiniteScrolling = 5;
    _centerSectionForInfiniteScrolling = 2;
    self.backgroundColor = [UIColor clearColor];
    
    //Set up scroll view that allows us to scroll the tabs
    _tabCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height) collectionViewLayout:[[M13InfiniteTabBarFlowLayout alloc] init]];
    if (_items.count > 0) {
        [self updateCollectionViewCellClass];
    }
    _tabCollectionView.dataSource = self;
    _tabCollectionView.delegate = self;
    _tabCollectionView.backgroundColor = [UIColor clearColor];
    _tabCollectionView.showsHorizontalScrollIndicator = false;
    _tabCollectionView.showsVerticalScrollIndicator = false;
    
    [self addSubview:_tabCollectionView];
    
    //Update the background
    [self updateBackground];
    //Create the selection indicator
    [self updateSelectionIndicator];
}

//---------------------------------------
#pragma mark Configuring Tab Bar Items
//---------------------------------------

- (void)setItems:(NSArray *)items
{
    [self setItems:items animated:false];
}

- (void)setItems:(NSArray *)items animated:(BOOL)animated
{
    //Set the indicies of the new tabs
    _items = items;
    for (int i = 0; i < _items.count; i++) {
        ((M13InfiniteTabBarItem *)_items[i]).index = i;
    }
    
    //Make sure the selections are correct.
    BOOL previousSelectionExists = false;
    for (M13InfiniteTabBarItem *item in _items) {
        if ([item isEqual:_selectedItem]) {
            previousSelectionExists = true;
            if (item.selected == false) {
                [item setSelected:true];
            }
        } else {
            [item setSelected:false];
        }
    }
    //If there is no previous selection, select the first item.
    if (!previousSelectionExists && _items.count > 0) {
        ((M13InfiniteTabBarItem *)_items[0]).selected = true;
        _selectedItem = _items[0];
    }
    
    _itemsChangedSinceLastLayout = true;
    
    //Update cell class
    [self updateCollectionViewCellClass];
    
    //Make sure we fully update tabs
    [self updateTabLayout:animated];
    [self updateSelectionIndicator];
}

/**Rotate all the tab bar items in the tab bar to the given angle.*/
- (void)rotateItemsToAngle:(CGFloat)angle
{
    //Rotate the offscreen items
    for (M13InfiniteTabBarItem *item in _items) {
        [item rotateToAngle:angle];
    }
}

- (void)setTabBarItemInsets:(UIEdgeInsets)tabBarItemInsets
{
    _tabBarItemInsets = tabBarItemInsets;
    [self setNeedsLayout];
}

//---------------------------------------
#pragma mark Supporting User Customization of Tab Bars
//---------------------------------------

- (void)beginCustomizingItems:(NSArray *)items
{
    if ([_customizationDelegate respondsToSelector:@selector(infiniteTabBar:willBeginCustomizingItems:)]) {
        [_customizationDelegate infiniteTabBar:self willBeginCustomizingItems:items];
    }
    
    
}

- (BOOL)endCustomizingItems
{
    if ([_customizationDelegate respondsToSelector:@selector(infiniteTabBar:didEndCustomizingItems:changed:)]) {
        [_customizationDelegate infiniteTabBar:self didEndCustomizingItems:_items changed:false];
    }
    return NO;
}

- (BOOL)isCustomizingItems
{
    return NO;
}

//---------------------------------------
#pragma mark Customizing Tab Bar Appearance
//---------------------------------------

- (void)setInfiniteScrollingEnabled:(BOOL)infiniteScrollingEnabled
{
    //Do we need to update the tabs?
    if (_infiniteScrollingEnabled != infiniteScrollingEnabled) {
        _infiniteScrollingEnabled = infiniteScrollingEnabled;
        [self updateTabLayout:false];
    }
}

- (void)setBarTintColor:(UIColor *)barTintColor
{
    _barTintColor = barTintColor;
    
    if (_translucent) {
        _backgroundVisualEffectView.contentView.backgroundColor = _barTintColor;
        self.backgroundColor = [UIColor clearColor];
    } else {
        self.backgroundColor = _barTintColor;
    }
}

- (void)setItemWidth:(CGFloat)itemWidth
{
    _itemWidth = itemWidth;
    [self setNeedsLayout];
}

- (void)setTranslucent:(BOOL)translucent
{
    _translucent = translucent;
    //Update the background
    [self updateBackground];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    //Update the background
    [self updateBackground];
}

- (void)updateBackground
{
    //If we have a background image, and not a view to add it to, create the view
    if (_backgroundImage && !_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self insertSubview:_backgroundImageView belowSubview:_tabCollectionView];
    }
    
    //Add the image to the backgroundImageView if necessary
    if (_backgroundImage) {
        //Depending on the resize mode, set the image differently
        if (_backgroundImage.resizingMode == UIImageResizingModeTile) {
            _backgroundImageView.image = nil;
            _backgroundImageView.backgroundColor = [UIColor colorWithPatternImage:_backgroundImage];
        } else {
            _backgroundImageView.image = _backgroundImage;
            _backgroundImageView.backgroundColor = [UIColor clearColor];
        }
    }
    
    //Create the visual effect view if it does not exist.
    if (!_backgroundImage && _translucent && !_backgroundVisualEffectView) {
        _backgroundVisualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
        _backgroundVisualEffectView.frame = self.bounds;
        _backgroundVisualEffectView.contentView.backgroundColor = _barTintColor;
    }
    
    //Remove the background visual effect view if necessary
    if ((_backgroundImage || !_translucent) && _backgroundVisualEffectView.superview != nil) {
        [_backgroundVisualEffectView removeFromSuperview];
    }
    
    //Show the background visual effect view if necessary
    if (!_backgroundImage && _translucent && _backgroundVisualEffectView.superview == nil) {
        [self insertSubview:_backgroundVisualEffectView belowSubview:_tabCollectionView];
    }
}

- (void)setShowSelectionIndicator:(BOOL)showSelectionIndicator
{
    _showSelectionIndicator = showSelectionIndicator;
    [self updateSelectionIndicator];
}

- (void)setSelectionIndicatorLocation:(M13InfiniteTabBarSelectionIndicatorLocation)selectionIndicatorLocation
{
    _selectionIndicatorLocation = selectionIndicatorLocation;
    [self updateSelectionIndicator];
}

/**Draws the mask that is the selection indicator triangle.*/
- (void)updateSelectionIndicator
{
    //Do we need a mask?
    if (_layoutType == M13InfiniteTabBarLayoutStatic) {
        self.layer.mask = nil;
        return;
    }
    
    //Prepare to create the mask
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat triangleDepth = 5.0;
    
    //Start with the top left corner
    CGPathMoveToPoint(path, nil, 0, 0);
    
    //Draw the triangle on top if necessary
    if (_selectionIndicatorLocation == M13InfiniteTabBarSelectionIndicatorLocationTop) {
        CGPathAddLineToPoint(path, nil, (self.frame.size.width / 2.0) - triangleDepth, 0);
        CGPathAddLineToPoint(path, nil, (self.frame.size.width / 2.0), triangleDepth);
        CGPathAddLineToPoint(path, nil, (self.frame.size.width / 2.0) + triangleDepth, 0);
    }
    
    //Top right
    CGPathAddLineToPoint(path, nil, self.frame.size.width, 0);
    
    //Bottom right
    CGPathAddLineToPoint(path, nil, self.frame.size.width, self.frame.size.height);
    
    //Draw the triangle on bottom if necessary
    if (_selectionIndicatorLocation == M13InfiniteTabBarSelectionIndicatorLocationBottom) {
        CGPathAddLineToPoint(path, nil, (self.frame.size.width / 2.0) + triangleDepth, self.frame.size.height);
        CGPathAddLineToPoint(path, nil, (self.frame.size.width / 2.0), self.frame.size.height - triangleDepth);
        CGPathAddLineToPoint(path, nil, (self.frame.size.width / 2.0) - triangleDepth, self.frame.size.height);
    }
    
    //Bottom left
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    
    //Close the path and set the mask
    CGPathCloseSubpath(path);
    if (self.layer.mask == nil) {
        self.layer.mask = [CAShapeLayer layer];
    }
    ((CAShapeLayer *)self.layer.mask).path = path;
    CGPathRelease(path);
}

- (void)setBackgroundVisualEffectView:(UIVisualEffectView *)backgroundVisualEffectView
{
    if (_backgroundVisualEffectView) {
        //Replace the visual effect view if it already exists
        [_backgroundVisualEffectView removeFromSuperview];
        _backgroundVisualEffectView = backgroundVisualEffectView;
        [self insertSubview:_backgroundVisualEffectView belowSubview:_tabCollectionView];
    } else {
        //Add it if necessary
        [self updateBackground];
    }
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric);
}

- (void)updateCollectionViewCellClass
{
    if (_items.count <= 0) {
        return;
    }
    M13InfiniteTabBarItem *item = _items[0];
    if (item) {
        [_tabCollectionView registerClass:[item representedTabBarItemViewClass] forCellWithReuseIdentifier:@"M13InfiniteTabBarItemCell"];
    }
}

//---------------------------------------
#pragma mark Interaction
//---------------------------------------

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    M13InfiniteTabBarItem *item = _items[indexPath.row];
    [self setSelectedItem:item atIndexPath:indexPath];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _scrollViewIsDragging = true;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        NSIndexPath *centeredIndexPath = [_tabCollectionView indexPathForItemAtPoint:CGPointMake((_tabCollectionView.frame.size.width / 2.0) + _tabCollectionView.contentOffset.x, _tabCollectionView.frame.size.height / 2.0)];
        [self setSelectedItem:_items[centeredIndexPath.row]];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSIndexPath *centeredIndexPath = [_tabCollectionView indexPathForItemAtPoint:CGPointMake((_tabCollectionView.frame.size.width / 2.0) + _tabCollectionView.contentOffset.x, _tabCollectionView.frame.size.height / 2.0)];
    [self setSelectedItem:_items[centeredIndexPath.row]];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (_layoutType == M13InfiniteTabBarLayoutInfinite) {
        [self recenterIfNecessary];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_layoutType == M13InfiniteTabBarLayoutInfinite && _scrollViewIsDragging) {
        [self recenterWhileScrolling];
    }
}

- (void)setSelectedItem:(M13InfiniteTabBarItem *)selectedItem
{
    [self setSelectedItem:selectedItem atIndexPath:nil];
}

- (void)setSelectedItem:(M13InfiniteTabBarItem *)selectedItem atIndexPath:(NSIndexPath *)indexPath
{
    //Check to see if we can select an item.
    if (_items.count == 0) {
        return;
    }
    
    if (_layoutType == M13InfiniteTabBarLayoutStatic) {
        //Just select the item, no scrolling needs to occur
        [self selectItem:selectedItem];
        return;
    } else if (_layoutType == M13InfiniteTabBarLayoutScrolling) {
        NSUInteger indexToSelect = [_items indexOfObject:selectedItem];
        [_tabCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexToSelect inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [self selectItem:selectedItem];
    } else if (_layoutType == M13InfiniteTabBarLayoutInfinite) {
        NSIndexPath *pathToSelect = indexPath;
        if (pathToSelect == nil) {
            NSUInteger indexToSelect = [_items indexOfObject:selectedItem];
            NSUInteger sectionToSelect = [_tabCollectionView indexPathForItemAtPoint:CGPointMake(_tabCollectionView.contentOffset.x + (_tabCollectionView.frame.size.width / 2.0), _tabCollectionView.frame.size.height / 2.0)].section;
            pathToSelect = [NSIndexPath indexPathForItem:indexToSelect inSection:sectionToSelect];
        }
        
        [_tabCollectionView scrollToItemAtIndexPath:pathToSelect atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [self selectItem:selectedItem];
        _scrollViewIsDragging = false;
    }
}

/**Handles the animations (for the item) of setting an item to selected.*/
- (void)selectItem:(M13InfiniteTabBarItem *)item
{
    //Should we allow the selection?
    BOOL shouldUpdate = true;
    if ([_selectionDelegate respondsToSelector:@selector(infiniteTabBar:shouldSelectItem:)]) {
        shouldUpdate = [_selectionDelegate infiniteTabBar:self shouldSelectItem:item];
    }
    
    if (shouldUpdate) {
        //Notify the delegate that we will be selecting an item
        if ([_selectionDelegate respondsToSelector:@selector(infiniteTabBar:willSelectItem:)]) {
            [_selectionDelegate infiniteTabBar:self willSelectItem:item];
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            //Ask for the concurrent animations
            if ([_selectionDelegate respondsToSelector:@selector(infiniteTabBar:concurrentAnimationsForSelectingItem:)]) {
                [_selectionDelegate infiniteTabBar:self concurrentAnimationsForSelectingItem:item];
            }
            
            //Animate the tab change, we need to deselect the prevoiusly selected tab, and select the current tab.
            for (M13InfiniteTabBarItem *anItem in _items) {
                if ([anItem isEqual:item]) {
                    anItem.selected = true;
                } else {
                    if (anItem.selected) {
                        anItem.selected = false;
                    }
                }
            }
            
            //Set the selected item
            _selectedItem = item;
        } completion:^(BOOL finished) {
            if ([_selectionDelegate respondsToSelector:@selector(infiniteTabBar:didSelectItem:)]) {
                [_selectionDelegate infiniteTabBar:self didSelectItem:_selectedItem];
            }
        }];
        
    } else {
        //Animate back to the original selection since the new selection was denied
        
        //If we are a static layout do nothing, no need to bring the old tab back into view.
        if (_layoutType == M13InfiniteTabBarLayoutStatic) {
            return;
        }
    }
}

//---------------------------------------
#pragma mark Layout
//---------------------------------------

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //Visual effect view
    if (_backgroundVisualEffectView) {
        _backgroundVisualEffectView.frame = self.bounds;
    }
    
    //Image view
    if (_backgroundImageView) {
        _backgroundImageView.frame = self.bounds;
    }
    
    //Scroll View
    _tabCollectionView.frame = CGRectMake(self.bounds.origin.x + _tabBarItemInsets.left, self.bounds.origin.y + _tabBarItemInsets.top, self.bounds.size.width - _tabBarItemInsets.left - _tabBarItemInsets.right, self.bounds.size.height - _tabBarItemInsets.top - _tabBarItemInsets.bottom);
    
    //Update the tabs and indicator if necessary
    [self updateTabLayout:true];
    [self updateSelectionIndicator];
}

- (void)updateTabLayout:(BOOL)animated
{
    //Determine what kind of layout is needed
    //Calculate the total width of all tabs
    CGFloat simulatedItemWidth = 64.0;
    if (_itemWidth > 0.0) {
        simulatedItemWidth = _itemWidth;
    }
    CGFloat totalWidth = simulatedItemWidth * (CGFloat)_items.count;
    
    //What kind of tab bar do we use?
    if (totalWidth <= _tabCollectionView.frame.size.width) {
        //Static
        _layoutType = M13InfiniteTabBarLayoutStatic;
        [self layoutTabsStatically:animated];
    } else if (!_infiniteScrollingEnabled) {
        _layoutType = M13InfiniteTabBarLayoutScrolling;
        [self layoutTabsForNonInfiniteScrolling:animated];
    } else {
        _layoutType = M13InfiniteTabBarLayoutInfinite;
        [self layoutTabsForInfiniteScrolling:animated];
    }
}

- (void)layoutTabsAnimated:(BOOL)animated completion:(void(^)(BOOL finished))completion
{
    if (animated) {
        if (_itemsChangedSinceLastLayout) {
            [_tabCollectionView performBatchUpdates:^{
                
                //Did the number of sections change (Section 0 will always exist)
                NSUInteger currentNumberOfSections = [_tabCollectionView.dataSource numberOfSectionsInCollectionView:_tabCollectionView];
                if (_previousSectionCount < currentNumberOfSections) {
                    [_tabCollectionView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, currentNumberOfSections - 1)]];
                } else if (_previousSectionCount > currentNumberOfSections) {
                    //Since we are deleting sections, move to section 0 so that crazy scrolling doesn't occur
                    NSIndexPath *centerItemIndexPath = [_tabCollectionView indexPathForItemAtPoint:CGPointMake(_tabCollectionView.contentOffset.x + (_tabCollectionView.frame.size.width / 2.0), _tabCollectionView.frame.size.height / 2.0)];
                    [_tabCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:centerItemIndexPath.item inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
                    [_tabCollectionView deleteSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, _previousSectionCount - 1)]];
                }
                
                //How many sections do we need to iterate over? If we are infinite, we have more than one section...
                NSUInteger iterateTo = _previousSectionCount == currentNumberOfSections ? _previousSectionCount : 1;
                
                //Determine what index paths to change.
                NSArray *changes = [NSArray changesBetweenArray:_items andPreviousArray:_previousItems];
                
                for (int i = 0; i < iterateTo; i++) {
                    [_tabCollectionView applyChanges:changes toSection:i];
                }
                
                //Setup for next layout
                _previousSectionCount = currentNumberOfSections;
                _previousItems = _items;
                
            } completion:completion];
        } else {
            [_tabCollectionView.collectionViewLayout invalidateLayout];
        }
    } else {
        if (_itemsChangedSinceLastLayout) {
            [_tabCollectionView reloadData];
            //Setup for next layout
            _previousSectionCount = [_tabCollectionView.dataSource numberOfSectionsInCollectionView:_tabCollectionView];
            _previousItems = _items;
        } else {
            [_tabCollectionView.collectionViewLayout invalidateLayout];
        }
        
    }
}

//---------------------------------------
#pragma mark Static Layout
//---------------------------------------

- (void)layoutTabsStatically:(BOOL)animated
{
    //Update the tab layout
    [self layoutTabsAnimated:animated completion:^(BOOL finished) {
        if (finished) {
            //Changes have been handled if they existed
            _itemsChangedSinceLastLayout = false;
        }
    }];
}

//---------------------------------------
#pragma mark Non infinite scrolling Layout
//---------------------------------------

- (void)layoutTabsForNonInfiniteScrolling:(BOOL)animated
{
    //Update the tab layout
    [self layoutTabsAnimated:animated completion:^(BOOL finished) {
        if (finished) {
            //Center the currentl selected tab.
            NSUInteger indexToSelect = [_items indexOfObject:_selectedItem];
            [_tabCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexToSelect inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            //Changes have been handled if they existed
            _itemsChangedSinceLastLayout = false;
        }
    }];
}

//---------------------------------------
#pragma mark Infinite Layout
//---------------------------------------

- (void)layoutTabsForInfiniteScrolling:(BOOL)animated
{
    //Update the tab layout
    [self layoutTabsAnimated:animated completion:^(BOOL finished) {
        if (finished) {
            //Center the currentl selected tab.
            NSUInteger indexToSelect = [_items indexOfObject:_selectedItem];
            //First shift to the center section, then animate to the given tab.
            [self recenterIfNecessary];
            [_tabCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexToSelect inSection:_centerSectionForInfiniteScrolling] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            //Changes have been handled if they existed
            _itemsChangedSinceLastLayout = false;
        }
    }];
}

- (void)recenterIfNecessary
{
    NSIndexPath *centerItemIndexPath = [_tabCollectionView indexPathForItemAtPoint:CGPointMake(_tabCollectionView.contentOffset.x + (_tabCollectionView.frame.size.width / 2.0), _tabCollectionView.frame.size.height / 2.0)];
    [_tabCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:centerItemIndexPath.item inSection:_centerSectionForInfiniteScrolling] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
}

- (void)recenterWhileScrolling
{
    //Get the width of the section, the first section always starts at x=0.
    UICollectionViewLayoutAttributes *endAttributs = [_tabCollectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:(_items.count - 1) inSection:0]];
    CGFloat sectionWidth = CGRectGetMaxX(endAttributs.frame);
    //If the center item is not in the center section
    NSIndexPath *centerItemIndexPath = [_tabCollectionView indexPathForItemAtPoint:CGPointMake(_tabCollectionView.contentOffset.x + (_tabCollectionView.frame.size.width / 2.0), _tabCollectionView.frame.size.height / 2.0)];
    if (centerItemIndexPath.section != _centerSectionForInfiniteScrolling) {
        //Get the offset we are from the begining of what section we are in.
        CGFloat offsetFromSection = _tabCollectionView.contentOffset.x - (floor(_tabCollectionView.contentOffset.x / sectionWidth) * sectionWidth);
        //Set the content offset without animation to the begining of the center section + some offset.
        _tabCollectionView.contentOffset = CGPointMake(sectionWidth * (CGFloat)(_centerSectionForInfiniteScrolling - 1) + offsetFromSection, 0.0);
    }
}

//---------------------------------------
#pragma mark Collection view
//---------------------------------------

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (_layoutType == M13InfiniteTabBarLayoutStatic) {
        return 1;
    } else if (_layoutType == M13InfiniteTabBarLayoutScrolling) {
        return 1;
    } else {
        return _numberOfSectionsForInfiniteScrolling;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Create the cell if necessary
    M13InfiniteTabBarItemView *cell = (M13InfiniteTabBarItemView *)[collectionView dequeueReusableCellWithReuseIdentifier:@"M13InfiniteTabBarItemCell" forIndexPath:indexPath];
    
    [cell setItem:_items[indexPath.row]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Is there a custom height?
    if (_itemWidth > 0) {
        return CGSizeMake(_itemWidth, _tabCollectionView.frame.size.height);
    }
    
    //If static:
    if (_layoutType == M13InfiniteTabBarLayoutStatic) {
        //Style the tab bar based on the interface size
        UITraitCollection *traits = self.traitCollection;
        if (traits.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
            //For compact views, the tabs fill the bar
            return CGSizeMake(_tabCollectionView.frame.size.width / (CGFloat)_items.count, _tabCollectionView.frame.size.height);
        } else {
            //For regular views, the tabs are centered
            return CGSizeMake(64.0, _tabCollectionView.frame.size.height);
        }
    }

    return CGSizeMake(64.0, _tabCollectionView.frame.size.height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //We only need the insets for static layout.
    if (_layoutType == M13InfiniteTabBarLayoutStatic) {
        //Style the tab bar based on the interface size
        UITraitCollection *traits = self.traitCollection;
        if (traits.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
            //For compact views, the tabs fill the bar
            return UIEdgeInsetsZero;
        } else {
            //For regular views, the tabs are centered
            CGFloat itemWidth = [self collectionView:_tabCollectionView layout:_tabCollectionView.collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]].width;
            return UIEdgeInsetsMake(0, (_tabCollectionView.frame.size.width - ((CGFloat)[_tabCollectionView.dataSource collectionView:_tabCollectionView numberOfItemsInSection:section]) * itemWidth) / 2.0, 0, 0);
        }
    } else if (_layoutType == M13InfiniteTabBarLayoutScrolling) {
        CGFloat itemWidth = [self collectionView:_tabCollectionView layout:_tabCollectionView.collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]].width;
        return UIEdgeInsetsMake(0, (_tabCollectionView.frame.size.width / 2.0) - (itemWidth / 2.0), 0, (_tabCollectionView.frame.size.width / 2.0) - (itemWidth / 2.0));
    }
    
    return UIEdgeInsetsZero;
}

@end
