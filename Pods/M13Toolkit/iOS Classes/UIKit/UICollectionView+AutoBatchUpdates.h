//
//  UICollectionView+AutoBatchUpdates.h
//  M13Toolkit
//
//  Created by Brandon McQuilkin on 2/4/15.
//  Copyright (c) 2015 BrandonMcQuilkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (AutoBatchUpdates)

/**
 Animates the multiple additions, changes, and deletions as a group in a given section.
 
 @param changes    The array of M13ObjectIndexChanges denoting the moves, insertions, and deletions that need to occur.
 @param section    The section the changes need to occur in.
 @param completion A completion handler block to execute when all of the operations are finished. This block takes a single Boolean parameter that contains the value YES if all of the related animations completed successfully or NO if they were interrupted. This parameter may be nil.
 */
- (void)performBatchChanges:(NSArray *)changes inSection:(NSUInteger)section completion:(void (^)(BOOL))completion;

/**
 Updates the given section with the given changes.
 
 @param changes The array of M13ObjectIndexChanges denoting the moves, insertions, and deletions that need to occur.
 @param section The section the changes need to occur in.
 */
- (void)applyChanges:(NSArray *)changes toSection:(NSUInteger)section;

@end
