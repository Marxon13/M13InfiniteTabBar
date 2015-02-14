//
//  M13InfiniteTabBarLayoutStatic.m
//  M13InfiniteTabBar
/*
 Copyright (c) 2015 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 One does not claim this software as ones own.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "M13InfiniteTabBarFlowLayout.h"

@interface M13InfiniteTabBarFlowLayout ()

// Containers for keeping track of changing items
@property (nonatomic, strong) NSMutableArray *insertedIndexPaths;
@property (nonatomic, strong) NSMutableArray *removedIndexPaths;
@property (nonatomic, strong) NSMutableArray *insertedSectionIndices;
@property (nonatomic, strong) NSMutableArray *removedSectionIndices;

// Caches for keeping current/previous attributes
@property (nonatomic, strong) NSMutableDictionary *currentCellAttributes;
@property (nonatomic, strong) NSMutableDictionary *currentSupplementaryAttributesByKind;
@property (nonatomic, strong) NSMutableDictionary *cachedCellAttributes;
@property (nonatomic, strong) NSMutableDictionary *cachedSupplementaryAttributesByKind;

@end

@implementation M13InfiniteTabBarFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self internalSetup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self internalSetup];
    }
    return self;
}

- (void)internalSetup
{
    [self setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.minimumInteritemSpacing = 0.0;
    self.minimumLineSpacing = 0.0;
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    [super prepareForCollectionViewUpdates:updateItems];
    
    // Keep track of updates to items and sections so we can use this information to create nifty animations
    self.insertedIndexPaths     = [NSMutableArray array];
    self.removedIndexPaths      = [NSMutableArray array];
    self.insertedSectionIndices = [NSMutableArray array];
    self.removedSectionIndices  = [NSMutableArray array];
    
    [updateItems enumerateObjectsUsingBlock:^(UICollectionViewUpdateItem *updateItem, NSUInteger idx, BOOL *stop) {
        if (updateItem.updateAction == UICollectionUpdateActionInsert) {
            // If the update item's index path has an "item" value of NSNotFound, it means it was a section update, not an individual item.
            // This is 100% undocumented but 100% reproducible.
            
            if (updateItem.indexPathAfterUpdate.item == NSNotFound) {
                [self.insertedSectionIndices addObject:@(updateItem.indexPathAfterUpdate.section)];
            } else {
                [self.insertedIndexPaths addObject:updateItem.indexPathAfterUpdate];
            }
        } else if (updateItem.updateAction == UICollectionUpdateActionDelete) {
            if (updateItem.indexPathBeforeUpdate.item == NSNotFound) {
                [self.removedSectionIndices addObject:@(updateItem.indexPathBeforeUpdate.section)];
            } else {
                [self.removedIndexPaths addObject:updateItem.indexPathBeforeUpdate];
            }
        }
    }];
}

- (void)finalizeCollectionViewUpdates
{
    [super finalizeCollectionViewUpdates];
    
    self.insertedIndexPaths     = nil;
    self.removedIndexPaths      = nil;
    self.insertedSectionIndices = nil;
    self.removedSectionIndices  = nil;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    // Deep-copy attributes in current cache
    self.cachedCellAttributes = [[NSMutableDictionary alloc] initWithDictionary:self.currentCellAttributes copyItems:YES];
    self.cachedSupplementaryAttributesByKind = [NSMutableDictionary dictionary];
    [self.currentSupplementaryAttributesByKind enumerateKeysAndObjectsUsingBlock:^(NSString *kind, NSMutableDictionary * attribByPath, BOOL *stop) {
        NSMutableDictionary * cachedAttribByPath = [[NSMutableDictionary alloc] initWithDictionary:attribByPath copyItems:YES];
        [self.cachedSupplementaryAttributesByKind setObject:cachedAttribByPath forKey:kind];
    }];
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray * attributes = [super layoutAttributesForElementsInRect:rect];
    
    // Always cache all visible attributes so we can use them later when computing final/initial animated attributes
    // Never clear the cache as certain items may be removed from the attributes array prior to being animated out
    [attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attributes, NSUInteger idx, BOOL *stop) {
        
        if (attributes.representedElementCategory == UICollectionElementCategoryCell) {
            [self.currentCellAttributes setObject:attributes forKey:attributes.indexPath];
        } else if (attributes.representedElementCategory == UICollectionElementCategorySupplementaryView) {
            NSMutableDictionary *supplementaryAttribuesByIndexPath = [self.currentSupplementaryAttributesByKind objectForKey:attributes.representedElementKind];
            if (supplementaryAttribuesByIndexPath == nil) {
                supplementaryAttribuesByIndexPath = [NSMutableDictionary dictionary];
                [self.currentSupplementaryAttributesByKind setObject:supplementaryAttribuesByIndexPath forKey:attributes.representedElementKind];
            }
            [supplementaryAttribuesByIndexPath setObject:attributes forKey:attributes.indexPath];
        }
    }];
    
    return attributes;
}

- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    
    if ([self.insertedIndexPaths containsObject:itemIndexPath]) {
        // If this is a newly inserted item, make it grow into place from its nominal index path
        attributes = [[self.currentCellAttributes objectForKey:itemIndexPath] copy];
        attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
    } else if ([self.insertedSectionIndices containsObject:@(itemIndexPath.section)]) {
        // if it's part of a new section, fly it in from the left
        attributes = [[self.currentCellAttributes objectForKey:itemIndexPath] copy];
        attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
    }
    
    return attributes;
}

- (UICollectionViewLayoutAttributes*)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    
    if ([self.removedIndexPaths containsObject:itemIndexPath] || [self.removedSectionIndices containsObject:@(itemIndexPath.section)]) {
        // Make it fall off the screen with a slight rotation
        attributes = [[self.cachedCellAttributes objectForKey:itemIndexPath] copy];
        attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
    }
    return attributes;
}

@end
