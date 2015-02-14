//
//  UITableView+AutoBatchUpdates.m
//  M13Toolkit
//
//  Created by Brandon McQuilkin on 2/5/15.
//  Copyright (c) 2015 BrandonMcQuilkin. All rights reserved.
//

#import "UITableView+AutoBatchUpdates.h"
#import "NSArray+Changes.h"

@implementation UITableView (AutoBatchUpdates)

- (void)applyChanges:(NSArray *)changes toSection:(NSUInteger)section
{
    NSMutableArray *inserted = [NSMutableArray array];
    NSMutableArray *deleted = [NSMutableArray array];
    
    for (M13ObjectIndexChange *change in changes) {
        switch (change.changeType) {
            case M13ObjectIndexChangeTypeMoved:
                [self moveRowAtIndexPath:[NSIndexPath indexPathForItem:change.previousIndex inSection:section] toIndexPath:[NSIndexPath indexPathForItem:change.currentIndex inSection:section]];
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
    
    [self insertRowsAtIndexPaths:inserted withRowAnimation:UITableViewRowAnimationAutomatic];
    [self deleteRowsAtIndexPaths:deleted withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
