//
//  M13InfiniteTabBarItemViewCollectionViewCell.m
//  M13InfiniteTabBar
/*
 Copyright (c) 2015 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 One does not claim this software as ones own.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "M13InfiniteTabBarItemView.h"
#import "M13InfiniteTabBarItem.h"

@interface M13InfiniteTabBarItemView ()

@property (nonatomic, assign) BOOL requiresUserAttention;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) BOOL tabSelected;

@end

@implementation M13InfiniteTabBarItemView

- (id)init
{
    self = [super init];
    if (self) {
        [self internalSetup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self internalSetup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self internalSetup];
    }
    return self;
}

- (void)internalSetup
{
    _tabContentView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:_tabContentView];
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
}

-(void)dealloc
{
    //Remove the item to end observing
    self.item = nil;
}

- (void)setItem:(M13InfiniteTabBarItem *)item
{
    //Remove the previous observer
    if (_item) {
        [_item removeObserver:self forKeyPath:@"transform"];
    }
    //Set the item
    _item = item;
    
    //Start observing if necessary, and update properties.
    if (_item) {
        //Set initial
        //_tabContentView.transform = _item.transform;
        
        //Begin observing
        [_item addObserver:self forKeyPath:@"transform" options:NSKeyValueObservingOptionNew context:nil];
    }
}

//This method should be overridden by the subclass.
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"transform"]) {
        [UIView animateWithDuration:0.25 animations:^{
            _tabContentView.transform = ((M13InfiniteTabBarItem *)object).transform;
        }];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //Update the tab content view
    self.tabContentView.bounds = CGRectMake(self.tabContentView.bounds.origin.x, self.tabContentView.bounds.origin.y, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    self.tabContentView.center = CGPointMake(self.contentView.frame.size.width / 2.0, self.contentView.frame.size.height / 2.0);
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    //self.item = nil;
}

@end
