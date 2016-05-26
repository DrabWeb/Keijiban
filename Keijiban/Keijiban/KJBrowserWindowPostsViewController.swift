//
//  KJPostsViewController.swift
//  Keijiban
//
//  Created by Seth on 2016-05-26.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

/// The view controller for the posts view(Catalog, index, threads, ETC.) of browsing windows
class KJBrowserWindowPostsViewController: NSViewController, LITabDataSource {

    /// The tabs control for this browser window
    @IBOutlet var tabsControl: LITabControl!
    
    /// The tabs for tabsControl
    var tabs : [KJBrowserWindowPostsTabItem] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        // Style the view
        styleView();
    }
    
    /// Styles the view controller
    func styleView() {
        // Style the tabs
        tabsControl.borderWidth = 0;
        tabsControl.backgroundColor = NSColor(calibratedWhite: 0, alpha: 0.2);
        
        // Set the tabs control's add action and target
        tabsControl.addTarget = self;
        tabsControl.addAction = Selector("addNewTab");
        
        // Set tabsControl's data source
        tabsControl.dataSource = self;
    }
    
    /// Called when the user clicks the "+" button in the tab bar or hits CMD+T
    func addNewTab() {
        // Add a new example tab
        tabs.append(KJBrowserWindowPostsTabItem(title: "Catalog"));
        
        // Reload the tabs control
        tabsControl.reloadData();
        
        // Select the new tab
        tabsControl.selectedItem = tabs.last!;
        
        // Scroll to the end of the tab bar
        ((tabsControl.subviews[0] as! NSScrollView).subviews[0] as! NSClipView).scrollToPoint(NSPoint(x: ((tabsControl.subviews[0] as! NSScrollView).subviews[0] as! NSClipView).frame.width + 10000, y: 0));
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
        print("Selection changed to \((tabsControl.selectedItem as! KJBrowserWindowPostsTabItem).title)");
    }
}
