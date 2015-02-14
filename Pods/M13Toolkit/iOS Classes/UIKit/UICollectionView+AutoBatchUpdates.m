//
//  UICollectionView+AutoBatchUpdates.m
//  M13Toolkit
//
//  Created by Brandon McQuilkin on 2/4/15.
//  Copyright (c) 2015 BrandonMcQuilkin. All rights reserved.
//

#import "UICollectionView+AutoBatchUpdates.h"
#import "NSArray+Changes.h"

@implementation UICollectionView (AutoBatchUpdates)

- (void)performBatchChanges:(NSArray *)changes inSection:(NSUInteger)section completion:(void (^)(BOOL))completion
{
    [self performBatchUpdates:^{
        [self applyChanges:changes toSection:section];
    } completion:completion];
    
}

- (void)applyChanges:(NSArray *)changes toSection:(NSUInteger)section
{
    NSMutableArray *inserted = [NSMutableArray array];
    NSMutableArray *deleted = [NSMutableArray array];
    
    for (M13ObjectIndexChange *change in changes) {
        switch (change.changeType) {
            case M13ObjectIndexChangeTypeMoved:
                [self moveItemAtIndexPath:[NSIndexPath indexPathForItem:change.previousIndex inSection:section] toIndexPath:[NSIndexPath indexPathForItem:change.currentIndex inSection:section]];
                break;
            case M13ObjectIndexChangeTypeInserted:
                [inserted addObject:[NSIndexPath indexPathForItem:change.currentIndex inSection:section]];
                break;
            case M13ObjectIndexChangeTypeDeleted:
                [deleted addObject:[NSIndexPath indexPathForItem:change.previousIndex inSection:section]];
                break;
            default:
                break;
        }
    }
    
    [self insertItemsAtIndexPaths:inserted];
    [self deleteItemsAtIndexPaths:deleted];
}

@end
