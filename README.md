M13InfiniteTabBar
=============
A fully customizable UITabBar replacement for tab bars with five or more tabs.

M13InfiniteTabBar was created to get rid of the "More" button on the UITabBar. Why should have to preform an extra two taps to get to the tab I want. M13InfiniteTabBar puts all the tabs on one level, in an intuitive, stylized manner. I've been using this in my app, "What's My Stage On?" since August 2012, and have decided to clean it up, and turn it into an easy to use subclass for everyone.

Features:
-----------
* Simple to setup, has a single initialization method, into which you can pass all the view controllers.
* All the colors can be customized to match the theme of your app. Most things follow the UIAppearance protocol.
* All the delegate methods work just like the UITabBarControllerDelegate methods. So it is very easy to add this to an app with an existing UITabBar.
* Contains an "central view controller" that works like Apple's Notification Center. Just pull up on the tab bar.

Screenshots from WMSO?
-----------
<img width="320">https://raw.github.com/Marxon13/M13InfiniteTabBar/master/Screenshots/WMSOTab1.png</img>
<img width="320">https://raw.github.com/Marxon13/M13InfiniteTabBar/master/Screenshots/WMSOTab2.png</img>
<img width="320">https://raw.github.com/Marxon13/M13InfiniteTabBar/master/Screenshots/WMSOAlertProgress.png</img>
<img width="320">https://raw.github.com/Marxon13/M13InfiniteTabBar/master/Screenshots/WMSOAlert.png</img>

Watch the demo video here: https://raw.github.com/Marxon13/M13InfiniteTabBar/master/M13InfiniteTabBar.mp4

Set Up:
--------------
* First, create all of your UIViewControllers, and create all of the M13InfiniteTabBarItems that correspond to those view controllers. The M13InfiniteTabBarItems are created with ```- (id)initWithTitle:(NSString *)title andIcon:(UIImage *)icon```, where the title is the title text you want displayed, and the icon is a black and white mask for the icon.
* Next create the M13InfiniteTabBarController with, ```- (id)initWithViewControllers:(NSArray *)viewControllers pairedWithInfiniteTabBarItems:(NSArray *)items```, passing in an array of the UIViewControllers, and an array of M13InfiniteTabBarItems. Make sure the indices of the UIViewController and its M13InfiniteTabBarItem match.
* Now just push the M13InfiniteTabBarController just like you would show any UIViewController. That's it!
* If you want to add a "Central View Controller" just set any UIViewController to M13InfiniteTabBarController's centralViewController property.

Appearance Customization:
----------------------
* M13InfiniteTabBarController
    * ```UIColor *tabBarBackgroundColor UI_APPEARANCE_SELECTOR``` This is the background of the tab bar.
* M13InfiniteTabBarItem
    * ```UIFont *titleFont UI_APPEARANCE_SELECTOR``` This is the font of the title label. I suggest leaving the font size at 7.0.
    * ```UIImage *selectedIconOverlayImage UI_APPEARANCE_SELECTOR``` The image that is overlaid onto the icon when that tab is selected. If this is nil, the tint color will be used.
    * ```UIColor *selectedIconTintColor UI_APPEARANCE_SELECTOR``` A solid color tint that is overlaid onto the icon when the tab is selected.
    * ``` UIImage *unselectedIconOverlayImage UI_APPEARANCE_SELECTOR``` The image that is overlaid onto the icon when that tab is not selected. If this is nil, the tint color will be used.
    * ```UIColor *unselectedIconTintColor UI_APPEARANCE_SELECTOR``` A solid color tint that is overlaid onto the icon when the tab is not selected.
    * ```UIColor *selectedTitleColor UI_APPEARANCE_SELECTOR``` The color of the title when the tab is selected.
    * ```UIColor *unselectedTitleColor UI_APPEARANCE_SELECTOR``` The color of the title when the tab is unselected.
* If you want to override the animation for when there is an "alert", subclass ```M13InfiniteTabBarCentralPullNotificationBackgroundView``` and set your subclass to ```M13InfiniteTabBarController```'s ```pullNotificatonBackgroundView``` property.

Limitations / To Do:
-------------------
I will be continuing to develop the M13InfniteTabBar. Adding features as I need them. These are the rings currently on my to do list:

* Create methods to add badges to tab bar items.
* Handle device rotation. Implemented but buggy. Need to learn a bit more about bounds and frames.
* Allow switching the order, adding, and removing of tabs.

License:
--------
MIT License

> Copyright (c) 2013 Brandon McQuilkin
> 
> Permission is hereby granted, free of charge, to any person obtaining 
>a copy of this software and associated documentation files (the  
>"Software"), to deal in the Software without restriction, including 
>without limitation the rights to use, copy, modify, merge, publish, 
>distribute, sublicense, and/or sell copies of the Software, and to 
>permit persons to whom the Software is furnished to do so, subject to  
>the following conditions:
> 
> The above copyright notice and this permission notice shall be 
>included in all copies or substantial portions of the Software.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
>EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
>MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
>IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
>CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
>TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
>SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.