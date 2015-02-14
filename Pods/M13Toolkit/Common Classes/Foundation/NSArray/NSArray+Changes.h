//
//  NSArray+Differences.h
//  
/*Copyright (c) 2015 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <Foundation/Foundation.h>

@interface NSArray (Changes)

/**
 Returns an array of object index change objects to identify changes between the current and previous array. Objects that exist in the current array but not the previous array will be identified with insertion objects. Objects that do not exist in the current array but in the previous array will be identified with deletion objects. Objects that exist in both, but have different indices will be identified with a moved object.
 
 @param currentArray  The array of objects to compare to.
 @param previousArray The previous array of objects to observe changes from.
 
 @return Returns the differences between the current array and the previous array.
 */
+ (NSArray *)changesBetweenArray:(NSArray *)currentArray andPreviousArray:(NSArray *)previousArray;

@end

typedef NS_ENUM(NSUInteger, M13ObjectIndexChangeType) {
    M13ObjectIndexChangeTypeMoved,
    M13ObjectIndexChangeTypeInserted,
    M13ObjectIndexChangeTypeDeleted
};

/**
 Stores a change in indices of an object in an array.
 */
@interface M13ObjectIndexChange : NSObject

/**@name Creation*/

/**
Creates an index change for an object that changed positions.

@param fromIndex    The previous index of the object.
@param toIndex      The new index of the object.

@return A new object index change object.
*/
+ (instancetype)indexChangeForMoveFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

/**
 Creates an index change of an object that was added.
 
 @param index The new index of the object.
 
 @return A new object index change object.
 */
+ (instancetype)indexChangeForInsertionAtIndex:(NSUInteger)index;

/**
 Creates an index change of an object that was deleted.
 
 @param index The previous index of the object.
 
 @return A new object index change object.
 */
+ (instancetype)indexChangeForDeletionAtIndex:(NSUInteger)index;

/**@name Properties*/

/**
 The type of change that occured.
 */
@property (nonatomic, assign, readonly) M13ObjectIndexChangeType changeType;

/**
 The current index of the object.
 */
@property (nonatomic, assign, readonly) NSUInteger currentIndex;

/**
 The previous index of the object.
 */
@property (nonatomic, assign, readonly) NSUInteger previousIndex;

@end
