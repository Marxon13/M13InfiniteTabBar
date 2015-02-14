<img src="https://raw.github.com/Marxon13/M13InfiniteTabBar/master/ReadmeResources/M13InfiniteTabBarBanner.png">

M13InfiniteTabBar: 3.0
=============
This update/overhaul is to address issues with efficiency, screen sizes, and manageability of the code. I decided to take the time to completely redo the tab bar from scratch, as I needed to add support for the screen sizes of the iPhone 6 and 6 plus.

Changes
--------

**M13InfiniteTabBarItem:** 
Split into M13InfiniteTabBarItem and M13InfiniteTabBarItemView. The item which was a UIView has been split into two components, an item object which represents the other component: an item view/cell. The cells subscribe to KVO notifications from the item object to know when to update their views. All image rendering, and visual logic is performed by the item object and the cells get updated when changes are made to the item. This way (for the iOS items at least) the icon that is displayed is rendered once, not one per view that exists (was 1-5 copies). Now UIViewControllers will have an item object that represents them, not a view. Only one copy of this item exists. So that multiple objects do not have to be updated in a loop.

**M13InfiniteTabBar:**
The tab bar has changed from a UIScrollView to a UICollectionView. This simplifies layout management and increases efficiency with view recycling. Also by using a UICollectionView it will be easy to Implement reordering.

