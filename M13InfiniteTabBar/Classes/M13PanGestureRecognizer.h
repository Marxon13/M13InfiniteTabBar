//
//  M13PanGestureRecognizer.h
//  M13InfiniteTabBar
//
//  Created by Brandon McQuilkin on 2/13/13.
//  Copyright (c) 2013 Brandon McQuilkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

typedef enum {
    M13PanGestureRecognizerDirectionVertical,
    M13PanGestureRecognizerDirectionHorizontal
} M13PanGestureRecognizerDirection;

@interface M13PanGestureRecognizer : UIPanGestureRecognizer

//The direction to allow dragging in
@property (nonatomic, assign) M13PanGestureRecognizerDirection panDirection;

@end
