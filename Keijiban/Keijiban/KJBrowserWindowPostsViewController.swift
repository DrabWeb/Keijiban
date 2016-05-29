//
//  KJPostsViewController.swift
//  Keijiban
//
//  Created by Seth on 2016-05-26.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

/// The view controller for the posts view. Controls the tabs and creating new post viewer views
class KJBrowserWindowPostsViewController: NSViewController, LITabDataSource {

    /// The tabs control for this browser window
    @IBOutlet var tabsControl: LITabControl!
    
    /// The visual effect view for the background of the tab bar
    @IBOutlet var tabsControlBackgroundVisualEffectView: NSVisualEffectView!
    
    /// The NSTabView that holds the actual views for the tab bar
    @IBOutlet var postViewersTabView: NSTabView!
    
    /// The tabs for tabsControl
    var tabs : [KJBrowserWindowPostsTabItem] = [];
    
    /// The current selected KJBrowserWindowPostsTabItem
    var currentTab : KJBrowserWindowPostsTabItem {
        return tabsControl.selectedItem as! KJBrowserWindowPostsTabItem;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        // Style the view
        styleView();
    }
    
    /// Updates postViewersTabView to match the current tabs
    func updatePostViewersTabView() {
        // Clear all the current tab view items
        for(_, currentTabViewItem) in postViewersTabView.tabViewItems.enumerate() {
            postViewersTabView.removeTabViewItem(currentTabViewItem);
        }
        
        // For every tab...
        for(currentIndex, currentTab) in tabs.enumerate() {
            // If the current tab's view controller is nil...
            if(currentTab.viewController == nil) {
                // Set the current tab's view controller to a new KJPostViewerViewController
                tabs[currentIndex].viewController = storyboard!.instantiateControllerWithIdentifier("postViewerViewController") as? KJPostViewerViewController;
            }
            
            /// The new tab item to add to postViewersTabView
            let newTabItem : NSTabViewItem = NSTabViewItem(viewController: currentTab.viewController!);
            
            // Set the tabs label(Even though its not seen)
            newTabItem.label = currentTab.title;
            
            // Add newTabItem to postViewersTabView
            postViewersTabView.addTabViewItem(newTabItem);
        }
    }
    
    /// The grid scroll point stored by storeCurrentSelection
    private var storedTabScrollPoint : NSPoint = NSPoint();
    
    /// Restores the selection that was stored by storeTabScrollPosition
    func restoreTabScrollPosition() {
        // Restore the scroll position
        (tabsControl.subviews[0] as! NSScrollView).contentView.scrollToPoint(storedTabScrollPoint);
    }
    
    /// Stores the current scroll position in the tab bar in storedTabScrollPoint
    func storeTabScrollPosition() {
        // Store the scroll point for the tab bar
        storedTabScrollPoint = (tabsControl.subviews[0] as! NSScrollView).contentView.bounds.origin;
    }
    
    /// Tries to jump to the tab at the given index. If it is out of range the selection doesnt change(The tab index should be given in array index format)
    func tryToJumpToTab(tab : Int) {
        // If the index is in range...
        if(tab >= 0 && tab < tabs.count) {
            // Change the selected tab to the tab at the given index
            tabsControl.selectedItem = tabs[tab];
            
            // Call tabsControlTabSelectionChanged
            tabsControlTabSelectionChanged();
        }
    }
    
    /// Adds a new tab with the users default new tab page(Catalog or Index). Also called when the user hits + or does CMD+T
    func addNewTab() {
        // Add a new example tab
        tabs.append(KJBrowserWindowPostsTabItem(title: "Catalog"));
        
        // Reload the tabs control
        tabsControl.reloadData();
        
        // Select the new tab
        tabsControl.selectedItem = tabs.last!;
        
        // Scroll to the end of the tab bar
        ((tabsControl.subviews[0] as! NSScrollView).subviews[0] as! NSClipView).scrollToPoint(NSPoint(x: ((tabsControl.subviews[0] as! NSScrollView).subviews[0] as! NSClipView).frame.width * 1000000, y: 0));
        
        // Update postViewersTabView
        updatePostViewersTabView();
        
        // Call tabsControlTabSelectionChanged
        tabsControlTabSelectionChanged();
    }
    
    /// Closes the current selected tab
    func closeCurrentTab() {
        /// The current selected tab
        let currentTab : KJBrowserWindowPostsTabItem = tabsControl.selectedItem as! KJBrowserWindowPostsTabItem;
        
        /// The index of currentTab
        var currentTabIndex = -1;
        
        // Store the tab scroll point
        storeTabScrollPosition();
        
        /// tabs as an NSMutableArray
        let tabsAsMutableArray : NSMutableArray = NSMutableArray(array: tabs);
        
        // Set currentTabIndex
        currentTabIndex = tabsAsMutableArray.indexOfObject(currentTab);
        
        // Remove currentTab from tabs
        tabsAsMutableArray.removeObject(currentTab);
        tabs = Array(tabsAsMutableArray) as! [KJBrowserWindowPostsTabItem];
        
        // Reload the tab bar
        tabsControl.reloadData();
        
        // Restore the tab scroll point
        restoreTabScrollPosition();
        
        // If we closed the last tab...
        if(currentTabIndex == tabs.count) {
            // Select the last tab
            tabsControl.selectedItem = tabs.last!;
        }
        // If we didnt close the last tab...
        else {
            // Select the tab after the one we closed
            tabsControl.selectedItem = tabs[currentTabIndex];
        }
        
        // Update postViewersTabView
        updatePostViewersTabView();
        
        // Call tabsControlTabSelectionChanged
        tabsControlTabSelectionChanged();
    }
    
    /// Called when the tabs control tab selection is changed
    func tabsControlTabSelectionChanged() {
        // Jump to the tab in postViewersTabView
        postViewersTabView.selectTabViewItemAtIndex(NSMutableArray(array: tabs).indexOfObject(tabsControl.selectedItem as! KJBrowserWindowPostsTabItem));
    }
    
    /// Styles the view controller
    func styleView() {
        // Style the visual effect views
        tabsControlBackgroundVisualEffectView.material = .Dark;
        
        // Style the tabs
        tabsControl.borderWidth = 0;
        tabsControl.backgroundColor = NSColor(calibratedWhite: 0, alpha: 0.5);
        
        // Set the tabs control's add action and target
        tabsControl.addTarget = self;
        tabsControl.addAction = Selector("addNewTab");
        
        // Set tabsControl's data source
        tabsControl.dataSource = self;
    }
    
    func tabControlNumberOfTabs(tabControl: LITabControl!) -> UInt {
        // Return the amount of items in tabs
        return UInt(tabs.count);
    }
    
    func tabControl(tabControl: LITabControl!, itemAtIndex index: UInt) -> AnyObject! {
        // Return the tab at the given index
        return tabs[Int(index)];
    }
    
    func tabControl(tabControl: LITabControl!, menuForItem item: AnyObject!) -> NSMenu! {
        // Return nil so there is no menu
        return nil;
    }
    
    func tabControl(tabControl: LITabControl!, titleForItem item: AnyObject!) -> String! {
        // Return the title of the given tab item
        return (item as! KJBrowserWindowPostsTabItem).title;
    }
    
    func tabControl(tabControl: LITabControl!, setTitle title: String!, forItem item: AnyObject!) {
        // Do nothing
    }
    
    func tabControl(tabControl: LITabControl!, canReorderItem item: AnyObject!) -> Bool {
        // Say we can always reorder any tab
        return true;
    }
    
    func tabControlDidReorderItems(tabControl: LITabControl!, orderedItems itemArray: [AnyObject]!) {
        // Set tabs to the given array as an array of KJBrowserWindowPostsTabItems
        tabs = itemArray as! [KJBrowserWindowPostsTabItem];
    }
    
    func tabControl(tabControl: LITabControl!, canEditItem item: AnyObject!) -> Bool {
        // Make it so we can never edit tab items
        return false;
    }
    
    func tabControlDidChangeSelection(notification: NSNotification!) {
        // Call tabsControlTabSelectionChanged
        tabsControlTabSelectionChanged();
    }
}
