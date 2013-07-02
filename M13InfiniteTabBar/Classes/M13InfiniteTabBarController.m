//
//  M13InfiniteTabBarController.m
//  M13InfiniteTabBar
/*
 Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 One does not claim this software as ones own.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "M13InfiniteTabBarController.h"
#import <QuartzCore/QuartzCore.h>

#import "M13InfiniteTabBarItem.h"


@interface M13InfiniteTabBarController ()
@property (nonatomic, assign) BOOL isCentralViewControllerOpen;
@end

@implementation M13InfiniteTabBarController
{
    M13InfiniteTabBarCentralPullViewController *_pullViewController;
    UIView *_maskView;
    UIView *_contentView;
    NSArray *_viewControllers;
    NSArray *_tabBarItems;
    BOOL _continueShowingAlert;
}

- (id)initWithViewControllers:(NSArray *)viewControllers pairedWithInfiniteTabBarItems:(NSArray *)items
{
    self = [super init];
    if (self) {
        _tabBarItems = items;
        _viewControllers = viewControllers;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    _continueShowingAlert = NO;
	
    //create content view to hold view controllers
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50.0)];
    _contentView.backgroundColor = [UIColor blackColor];
    _contentView.clipsToBounds = YES;
    
    //initalize the tab bar
    _infiniteTabBar = [[M13InfiniteTabBar alloc] initWithInfiniteTabBarItems:_tabBarItems];
    _infiniteTabBar.tabBarDelegate = self;
        
    //Create mask for tab bar
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] applicationFrame].size.height - 60.0, [[UIScreen mainScreen] applicationFrame].size.width, 60.0)];
    //Add shadow gradient to mask layer
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, _infiniteTabBar.frame.size.width, 20);
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor clearColor] CGColor], nil];
    gradient.opacity = .4;
    
    //Combine views
    _maskView.backgroundColor = [UIColor underPageBackgroundColor];
    [self.view addSubview:_maskView];
    [_maskView.layer insertSublayer:gradient above:0];
    [_maskView addSubview:_infiniteTabBar];
    [self.view addSubview:_contentView];
    
    //Catch rotation changes for tabs
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRotation:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    //Set Up View Controllers
    _selectedIndex = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? 2 : 5;
    _selectedViewController = [_viewControllers objectAtIndex:_selectedIndex];
    _selectedViewController.view.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
    _selectedViewController.view.contentScaleFactor = [UIScreen mainScreen].scale;
    [_contentView addSubview:_selectedViewController.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_selectedViewController viewWillAppear:animated];
    
    [_infiniteTabBar rotateItemsToOrientation:[UIDevice currentDevice].orientation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_selectedViewController viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_selectedViewController viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_selectedViewController viewDidDisappear:animated];
}

- (void)dealloc
{
    if (_pullNotificatonBackgroundView) {
        [_pullNotificatonBackgroundView.layer removeAllAnimations];
    }
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//Handle rotating all view controllers
- (void)handleRotation:(NSNotification *)notification
{
    if (_selectedViewController.shouldAutorotate) {
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        
        //check to see if we should rotate, and set proper rotation values for animation
        UIInterfaceOrientationMask mask = _selectedViewController.supportedInterfaceOrientations;
        CGFloat angle = 0.0;
        UIInterfaceOrientation interfaceOrientation = UIInterfaceOrientationPortrait;
        BOOL go = FALSE;
        if (((mask == UIInterfaceOrientationMaskPortrait || mask == UIInterfaceOrientationMaskAllButUpsideDown || mask == UIInterfaceOrientationMaskAll) && orientation == UIDeviceOrientationPortrait)) {
            go = TRUE;
        } else if (((mask == UIInterfaceOrientationMaskLandscape || mask == UIInterfaceOrientationMaskLandscapeLeft || mask == UIInterfaceOrientationMaskAllButUpsideDown || mask == UIInterfaceOrientationMaskAll) && orientation == UIDeviceOrientationLandscapeLeft)) {
            go = TRUE;
            angle = -M_PI_2;
            interfaceOrientation = UIInterfaceOrientationLandscapeLeft;
        } else if (((mask == UIInterfaceOrientationMaskPortraitUpsideDown ||  mask == UIInterfaceOrientationMaskAllButUpsideDown || mask == UIInterfaceOrientationMaskAll) && orientation == UIDeviceOrientationPortraitUpsideDown)) {
            go = TRUE;
            angle = -M_PI;
            interfaceOrientation = UIInterfaceOrientationPortraitUpsideDown;
        } else if (((mask == UIInterfaceOrientationMaskLandscape || mask == UIInterfaceOrientationMaskLandscapeRight ||  mask == UIInterfaceOrientationMaskAllButUpsideDown || mask == UIInterfaceOrientationMaskAll) && orientation == UIDeviceOrientationLandscapeRight)) {
            go = TRUE;
            angle = M_PI_2;
            interfaceOrientation = UIInterfaceOrientationLandscapeRight;
        }
        
        if (go) {
            //begin rotation
            [UIView beginAnimations:@"HandleRotation" context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            
            CGSize totalSize = [UIScreen mainScreen].bounds.size;
            CGFloat triangleDepth = 10.0;
            CGFloat statusBarHeight = ([UIApplication sharedApplication].statusBarFrame.size.height < [UIApplication sharedApplication].statusBarFrame.size.width ? [UIApplication sharedApplication].statusBarFrame.size.height : [UIApplication sharedApplication].statusBarFrame.size.width);
            
            //Rotate Status Bar
            [[UIApplication sharedApplication] setStatusBarOrientation:interfaceOrientation];
            //Rotate tab bar items
            [_infiniteTabBar rotateItemsToOrientation:orientation];
            //Recreate mask and adjust frames to make room for status bar.
            if (interfaceOrientation == UIInterfaceOrientationPortrait) {
                //Resize View
                CGRect tempFrame = CGRectMake(0, 0, totalSize.width, totalSize.height - statusBarHeight - 50.0);
                _contentView.frame = tempFrame;
                _selectedViewController.view.frame = CGRectMake(0, 0, totalSize.width, totalSize.height - statusBarHeight - 50.0);
                _maskView.frame = CGRectMake(0, totalSize.height - statusBarHeight - 50.0 - triangleDepth, _maskView.frame.size.width, _maskView.frame.size.height);
                
                //If the child view controller supports this orientation
                if (_selectedViewController.supportedInterfaceOrientations == UIInterfaceOrientationMaskAll || _selectedViewController.supportedInterfaceOrientations == UIInterfaceOrientationMaskAllButUpsideDown || _selectedViewController.supportedInterfaceOrientations == UIInterfaceOrientationMaskPortrait) {
                    //Rotate View Bounds
                    _selectedViewController.view.transform = CGAffineTransformMakeRotation(angle);
                    _selectedViewController.view.bounds = CGRectMake(0, 0, totalSize.width, totalSize.height - statusBarHeight - 50.0);
                }
                
                //Create content mask
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                CGMutablePathRef path = CGPathCreateMutable();
                CGPathMoveToPoint(path, NULL, 0, 0);
                CGPathAddLineToPoint(path, NULL, tempFrame.size.width, 0);
                CGPathAddLineToPoint(path, NULL, tempFrame.size.width, tempFrame.size.height);
                CGPathAddLineToPoint(path, NULL, (tempFrame.size.width / 2.0) + triangleDepth, tempFrame.size.height);
                CGPathAddLineToPoint(path, NULL, (tempFrame.size.width / 2.0), tempFrame.size.height - triangleDepth);
                CGPathAddLineToPoint(path, NULL, (tempFrame.size.width / 2.0) - triangleDepth, tempFrame.size.height);
                CGPathAddLineToPoint(path, NULL, 0, tempFrame.size.height);
                CGPathCloseSubpath(path);
                [maskLayer setPath:path];
                CGPathRelease(path);
                _contentView.layer.mask = maskLayer;
            } else if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
                //Resize View
                CGRect tempFrame = CGRectMake(0, - statusBarHeight, totalSize.width, totalSize.height - statusBarHeight - 50.0);
                _contentView.frame = tempFrame;
                _selectedViewController.view.frame = CGRectMake(0, 0, totalSize.width, totalSize.height - statusBarHeight - 50);
                _maskView.frame = CGRectMake(0, totalSize.height - statusBarHeight - 50.0 - triangleDepth, _maskView.frame.size.width, _maskView.frame.size.height);
                
                //If the child view controller supports this interface orientation.
                if (_selectedViewController.supportedInterfaceOrientations == UIInterfaceOrientationMaskAll || _selectedViewController.supportedInterfaceOrientations == UIInterfaceOrientationMaskPortraitUpsideDown) {
                    //Rotate View Bounds
                    _selectedViewController.view.transform = CGAffineTransformMakeRotation(angle);
                    _selectedViewController.view.bounds = CGRectMake(0, 0, totalSize.width, totalSize.height - statusBarHeight - 50.0);
                }
                
                //Create content mask
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                CGMutablePathRef path = CGPathCreateMutable();
                CGPathMoveToPoint(path, NULL, 0, 0);
                CGPathAddLineToPoint(path, NULL, tempFrame.size.width, 0);
                CGPathAddLineToPoint(path, NULL, tempFrame.size.width, tempFrame.size.height);
                CGPathAddLineToPoint(path, NULL, (tempFrame.size.width / 2.0) + triangleDepth, tempFrame.size.height);
                CGPathAddLineToPoint(path, NULL, (tempFrame.size.width / 2.0), tempFrame.size.height - triangleDepth);
                CGPathAddLineToPoint(path, NULL, (tempFrame.size.width / 2.0) - triangleDepth, tempFrame.size.height);
                CGPathAddLineToPoint(path, NULL, 0, tempFrame.size.height);
                CGPathCloseSubpath(path);
                [maskLayer setPath:path];
                CGPathRelease(path);
                _contentView.layer.mask = maskLayer;
            } else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
                //Resize View
                CGRect tempFrame = CGRectMake(statusBarHeight, -statusBarHeight, totalSize.width - statusBarHeight, totalSize.height - 50.0);
                _contentView.frame = tempFrame;
                _selectedViewController.view.frame = CGRectMake(0, 0, totalSize.width - statusBarHeight, totalSize.height - 50.0);
                _maskView.frame = CGRectMake(0, totalSize.height - statusBarHeight - 50.0 - triangleDepth, _maskView.frame.size.width, _maskView.frame.size.height);
                
                //If the child view controller supports this interface orientation
                if (_selectedViewController.supportedInterfaceOrientations == UIInterfaceOrientationMaskAll || _selectedViewController.supportedInterfaceOrientations == UIInterfaceOrientationMaskAllButUpsideDown || _selectedViewController.supportedInterfaceOrientations == UIInterfaceOrientationMaskLandscape || _selectedViewController.supportedInterfaceOrientations == UIInterfaceOrientationMaskLandscapeLeft) {
                    //Rotate View Bounds
                    _selectedViewController.view.transform = CGAffineTransformMakeRotation(angle);
                    _selectedViewController.view.bounds = CGRectMake(0, 0, totalSize.height - 50.0, totalSize.width - statusBarHeight);
                }
                
                //Create content mask
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                CGMutablePathRef path = CGPathCreateMutable();
                CGPathMoveToPoint(path, NULL, 0, 0);
                CGPathAddLineToPoint(path, NULL, tempFrame.size.width, 0);
                CGPathAddLineToPoint(path, NULL, tempFrame.size.width, tempFrame.size.height);
                CGPathAddLineToPoint(path, NULL, (tempFrame.size.width / 2.0) + triangleDepth - (statusBarHeight / 2.0), tempFrame.size.height);
                CGPathAddLineToPoint(path, NULL, (tempFrame.size.width / 2.0) - (statusBarHeight / 2.0), tempFrame.size.height - triangleDepth);
                CGPathAddLineToPoint(path, NULL, (tempFrame.size.width / 2.0) - triangleDepth - (statusBarHeight / 2.0), tempFrame.size.height);
                CGPathAddLineToPoint(path, NULL, 0, tempFrame.size.height);
                CGPathCloseSubpath(path);
                [maskLayer setPath:path];
                CGPathRelease(path);
                _contentView.layer.mask = maskLayer;
            } else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
                //Resize View
                CGRect tempFrame = CGRectMake(0, - statusBarHeight, totalSize.width - statusBarHeight, totalSize.height - 50.0);
                _contentView.frame = tempFrame;
                _selectedViewController.view.frame = CGRectMake(0, 0, totalSize.width - statusBarHeight, totalSize.height - 50.0);
                _maskView.frame = CGRectMake(0, totalSize.height - statusBarHeight - 50.0 - triangleDepth, _maskView.frame.size.width, _maskView.frame.size.height);
                
                //If the child view controller supports this interface orientation
                if (_selectedViewController.supportedInterfaceOrientations == UIInterfaceOrientationMaskAll || _selectedViewController.supportedInterfaceOrientations == UIInterfaceOrientationMaskAllButUpsideDown || _selectedViewController.supportedInterfaceOrientations == UIInterfaceOrientationMaskLandscape || _selectedViewController.supportedInterfaceOrientations == UIInterfaceOrientationMaskLandscapeRight) {
                    //Rotate View Bounds
                    _selectedViewController.view.transform = CGAffineTransformMakeRotation(angle);
                    _selectedViewController.view.bounds = CGRectMake(0, 0, totalSize.height - 50.0, totalSize.width - statusBarHeight);
                }
                
                //Create content mask
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                CGMutablePathRef path = CGPathCreateMutable();
                CGPathMoveToPoint(path, NULL, 0, 0);
                CGPathAddLineToPoint(path, NULL, tempFrame.size.width, 0);
                CGPathAddLineToPoint(path, NULL, tempFrame.size.width, tempFrame.size.height);
                CGPathAddLineToPoint(path, NULL, (tempFrame.size.width / 2.0) + triangleDepth + (statusBarHeight / 2.0), tempFrame.size.height);
                CGPathAddLineToPoint(path, NULL, (tempFrame.size.width / 2.0) + (statusBarHeight / 2.0), tempFrame.size.height - triangleDepth);
                CGPathAddLineToPoint(path, NULL, (tempFrame.size.width / 2.0) - triangleDepth + (statusBarHeight / 2.0), tempFrame.size.height);
                CGPathAddLineToPoint(path, NULL, 0, tempFrame.size.height);
                CGPathCloseSubpath(path);
                [maskLayer setPath:path];
                CGPathRelease(path);
                _contentView.layer.mask = maskLayer;
            }
            [UIView commitAnimations];
        }
        
    }
    
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


//Tab bar delegate
- (BOOL)infiniteTabBar:(M13InfiniteTabBar *)tabBar shouldSelectItem:(M13InfiniteTabBarItem *)item
{
    BOOL should = YES;
    if ([_delegate respondsToSelector:@selector(infiniteTabBarController:shouldSelectViewContoller:)]) {
        should = [_delegate infiniteTabBarController:self shouldSelectViewContoller:[_viewControllers objectAtIndex:item.tag]];
    }
    return should;
}

- (void)infiniteTabBar:(M13InfiniteTabBar *)tabBar didSelectItem:(M13InfiniteTabBarItem *)item
{
    //Clean up animation
    if (_contentView.subviews.count > 1) {
        UIView *aView = [_contentView.subviews objectAtIndex:0];
        aView.layer.opacity = 0.0;
        [aView removeFromSuperview];
    }
    
    if ([_delegate respondsToSelector:@selector(infiniteTabBarController:didSelectViewController:)]) {
        [_delegate infiniteTabBarController:self didSelectViewController:[_viewControllers objectAtIndex:item.tag]];
    }
}

- (void)infiniteTabBar:(M13InfiniteTabBar *)tabBar willAnimateInViewControllerForItem:(M13InfiniteTabBarItem *)item
{
    UIViewController *newController = [_viewControllers objectAtIndex:item.tag];
    
    //check to see if we should rotate, and set proper rotation values
    UIInterfaceOrientationMask mask = _selectedViewController.supportedInterfaceOrientations;
    CGFloat angle = 0.0;
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (((mask == UIInterfaceOrientationMaskPortrait || mask == UIInterfaceOrientationMaskAllButUpsideDown || mask == UIInterfaceOrientationMaskAll) && interfaceOrientation == UIInterfaceOrientationPortrait)) {
    } else if (((mask == UIInterfaceOrientationMaskLandscape || mask == UIInterfaceOrientationMaskLandscapeLeft || mask == UIInterfaceOrientationMaskAllButUpsideDown || mask == UIInterfaceOrientationMaskAll) && interfaceOrientation == UIInterfaceOrientationLandscapeLeft)) {
        angle = -M_PI_2;
    } else if (((mask == UIInterfaceOrientationMaskPortraitUpsideDown || mask == UIInterfaceOrientationMaskAll) && interfaceOrientation == UIInterfaceOrientationMaskPortraitUpsideDown)) {
        angle = -M_PI;
    } else if (((mask == UIInterfaceOrientationMaskLandscape || mask == UIInterfaceOrientationMaskLandscapeRight ||  mask == UIInterfaceOrientationMaskAllButUpsideDown || mask == UIInterfaceOrientationMaskAll) && interfaceOrientation == UIInterfaceOrientationLandscapeRight)) {
        angle = M_PI_2;
    }
    
    CGSize totalSize = [UIScreen mainScreen].bounds.size;
    CGFloat statusBarHeight = ([UIApplication sharedApplication].statusBarFrame.size.height < [UIApplication sharedApplication].statusBarFrame.size.width ? [UIApplication sharedApplication].statusBarFrame.size.height : [UIApplication sharedApplication].statusBarFrame.size.width);
    
    //Rotate Status Bar
    [[UIApplication sharedApplication] setStatusBarOrientation:interfaceOrientation];
    //Rotate tab bar items
    //Recreate mask and adjust frames to make room for status bar.
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        //Resize View
        newController.view.frame = CGRectMake(0, 0, totalSize.width, totalSize.height - statusBarHeight - 50.0);
        
        //If the child view controller supports this orientation
        if (newController.supportedInterfaceOrientations == UIInterfaceOrientationMaskAll || newController.supportedInterfaceOrientations == UIInterfaceOrientationMaskAllButUpsideDown || newController.supportedInterfaceOrientations == UIInterfaceOrientationMaskPortrait) {
            //Rotate View Bounds
            newController.view.bounds = CGRectMake(0, 0, totalSize.width, totalSize.height - statusBarHeight - 50.0);
            newController.view.transform = CGAffineTransformMakeRotation(angle);
        }
    } else if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        //Resize View
        newController.view.frame = CGRectMake(0, 0, totalSize.width, totalSize.height - statusBarHeight - 50);
        
        //If the child view controller supports this interface orientation.
        if (newController.supportedInterfaceOrientations == UIInterfaceOrientationMaskAll || newController.supportedInterfaceOrientations == UIInterfaceOrientationMaskPortraitUpsideDown) {
            //Rotate View Bounds
            newController.view.bounds = CGRectMake(0, 0, totalSize.width, totalSize.height - statusBarHeight - 50.0);
            newController.view.transform = CGAffineTransformMakeRotation(angle);
        }
    } else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        //Resize View
        newController.view.frame = CGRectMake(0, 0, totalSize.width - statusBarHeight, totalSize.height - 50.0);
        
        //If the child view controller supports this interface orientation
        if (newController.supportedInterfaceOrientations == UIInterfaceOrientationMaskAll || newController.supportedInterfaceOrientations == UIInterfaceOrientationMaskAllButUpsideDown || newController.supportedInterfaceOrientations == UIInterfaceOrientationMaskLandscape || newController.supportedInterfaceOrientations == UIInterfaceOrientationMaskLandscapeLeft) {
            //Rotate View Bounds
            newController.view.bounds = CGRectMake(0, 0, totalSize.height - 50.0, totalSize.width - statusBarHeight);
            newController.view.transform = CGAffineTransformMakeRotation(angle);
        }
    } else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        //Resize View
        newController.view.frame = CGRectMake(0, 0, totalSize.width - statusBarHeight, totalSize.height - 50.0);
        
        //If the child view controller supports this interface orientation
        if (newController.supportedInterfaceOrientations == UIInterfaceOrientationMaskAll || newController.supportedInterfaceOrientations == UIInterfaceOrientationMaskAllButUpsideDown || newController.supportedInterfaceOrientations == UIInterfaceOrientationMaskLandscape || newController.supportedInterfaceOrientations == UIInterfaceOrientationMaskLandscapeRight) {
            //Rotate View Bounds
            newController.view.bounds = CGRectMake(0, 0, totalSize.height - 50.0, totalSize.width - statusBarHeight);
            newController.view.transform = CGAffineTransformMakeRotation(angle);
        }
    }
    
    //Set up for transition
    newController.view.layer.opacity = 0;
}

- (void)infiniteTabBar:(M13InfiniteTabBar *)tabBar animateInViewControllerForItem:(M13InfiniteTabBarItem *)item
{
    if ([[_viewControllers objectAtIndex:item.tag] isKindOfClass:[UINavigationController class]] && item.tag == _selectedIndex) {
        //Pop to root controller when tapped
        UINavigationController *controller = [_viewControllers objectAtIndex:item.tag];
        [controller popToRootViewControllerAnimated:YES];
    } else {
        UIViewController *newController = [_viewControllers objectAtIndex:item.tag];
        [_contentView addSubview:newController.view];
        newController.view.layer.opacity = 1.0;
        _selectedViewController = newController;
        _selectedIndex = [_viewControllers indexOfObject:newController];
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [_infiniteTabBar setSelectedItem:[_tabBarItems objectAtIndex:selectedIndex]];
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController
{
    [_infiniteTabBar setSelectedItem:[_tabBarItems objectAtIndex:[_viewControllers indexOfObject:selectedViewController]]];
}

//Central View controller alerts
- (void)setCentralViewController:(UIViewController *)centralViewController
{
    //Add view
    _pullViewController = [[M13InfiniteTabBarCentralPullViewController alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    _pullViewController.delegate = self;
    centralViewController.view.frame = CGRectMake(0.0, 30.0, self.view.frame.size.width, self.view.frame.size.height - 30.0);
    [_pullViewController addSubview:centralViewController.view];
    //set properties
    _pullViewController.closedCenter = _pullViewController.center;
    CGPoint openCenter = _pullViewController.center;
    openCenter.y = openCenter.y - self.view.frame.size.height;
    _pullViewController.openCenter = openCenter;
    //add handle view to view
    _pullViewController.handleView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 30.0);
    _pullViewController.handleView.backgroundColor = [UIColor clearColor];
    UIImage *handleImage = [UIImage imageNamed:@"Grabber.png"];
    UIImageView *handle = [[UIImageView alloc] initWithFrame:CGRectMake((_pullViewController.handleView.frame.size.width / 2.0) - (handleImage.size.width / 2.0), _pullViewController.handleView.frame.size.height - handleImage.size.height, handleImage.size.width, handleImage.size.height)];
    handle.layer.opacity = 0.3;
    [handle setImage:handleImage];
    [_pullViewController.handleView addSubview:handle];
    //Add gesture to tab bar
    M13PanGestureRecognizer *dragRecoginizer = [[M13PanGestureRecognizer alloc] initWithTarget:_pullViewController action:@selector(handleDrag:)];
    dragRecoginizer.panDirection = M13PanGestureRecognizerDirectionVertical;
    dragRecoginizer.minimumNumberOfTouches = 1;
    dragRecoginizer.maximumNumberOfTouches = 1;
    dragRecoginizer.delegate = _infiniteTabBar;
    dragRecoginizer.cancelsTouchesInView = NO;
    dragRecoginizer.delaysTouchesBegan = NO;
    [_infiniteTabBar addGestureRecognizer:dragRecoginizer];
    //Appearance
    _pullViewController.backgroundColor = centralViewController.view.backgroundColor;
    centralViewController.view.backgroundColor = [UIColor clearColor];
    
    //Add pull view to tab bar
    [self.view addSubview:_pullViewController];
    
    //Other
    _continueShowingAlert = YES;
}

- (void)pullableView:(M13InfiniteTabBarCentralPullViewController *)pullableView didChangeState:(BOOL)isOpen
{
    if (!isOpen) {
        [self endAlertAnimation];
    }
}

- (void)showAlertForCentralViewControllerIsEmergency:(BOOL)emergency
{
    if (_pullViewController != nil) {
        _continueShowingAlert = YES;
        if (_pullNotificatonBackgroundView == nil) {
            _pullNotificatonBackgroundView = [[M13InfiniteTabBarCentralPullNotificationBackgroundView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 0)];
            _pullNotificatonBackgroundView.layer.opacity = 0.0;
            [_maskView insertSubview:_pullNotificatonBackgroundView belowSubview:_infiniteTabBar];
        }
        _pullNotificatonBackgroundView.frame = CGRectMake(0.0, 0.0, _pullNotificatonBackgroundView.frame.size.width, _pullNotificatonBackgroundView.frame.size.height);
        [_pullNotificatonBackgroundView setIsEmergency:emergency];
        [UIView beginAnimations:@"Chevron Animation" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(repeatAlertAnimation)];
        [UIView setAnimationDuration:2.0];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        _pullNotificatonBackgroundView.layer.opacity = 1.0;
        _pullNotificatonBackgroundView.frame = CGRectMake(0, -_pullNotificatonBackgroundView.notificationPatternRepeatDistance, _pullNotificatonBackgroundView.frame.size.width, _pullNotificatonBackgroundView.frame.size.height);
        [UIView commitAnimations];
    }
}

- (void)endAlertAnimation
{
    _continueShowingAlert = NO;
}

- (void)repeatAlertAnimation
{
    if (_continueShowingAlert) { //repeat
        _pullNotificatonBackgroundView.frame = CGRectMake(0, 0, _pullNotificatonBackgroundView.frame.size.width, _pullNotificatonBackgroundView.frame.size.height);
        [UIView beginAnimations:@"CheveronAnimation" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(repeatAlertAnimation)];
        [UIView setAnimationDuration:2.0];
        [UIView setAnimationRepeatCount:5];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        _pullNotificatonBackgroundView.frame = CGRectMake(0, -_pullNotificatonBackgroundView.notificationPatternRepeatDistance, _pullNotificatonBackgroundView.frame.size.width, _pullNotificatonBackgroundView.frame.size.height);
        [UIView commitAnimations];
    } else { //end
        _pullNotificatonBackgroundView.frame = CGRectMake(0, 0, _pullNotificatonBackgroundView.frame.size.width, _pullNotificatonBackgroundView.frame.size.height);
        [UIView beginAnimations:@"CheveronAnimation" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(repeatAnimation)];
        [UIView setAnimationDuration:2.0];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        _pullNotificatonBackgroundView.layer.opacity = 0.0;
        _pullNotificatonBackgroundView.frame = CGRectMake(0, -_pullNotificatonBackgroundView.notificationPatternRepeatDistance, _pullNotificatonBackgroundView.frame.size.width, _pullNotificatonBackgroundView.frame.size.height);
        [UIView commitAnimations];
    }
}

- (void)setCentralViewControllerOpened:(BOOL)opened animated:(BOOL)animated
{
    [_pullViewController setOpened:opened animated:animated];
}

//Appearance
- (void)setTabBarBackgroundColor:(UIColor *)tabBarBackgroundColor
{
    _maskView.backgroundColor = tabBarBackgroundColor;
    _tabBarBackgroundColor = tabBarBackgroundColor;
}

@end
