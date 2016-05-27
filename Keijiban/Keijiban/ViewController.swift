//
//  ViewController.swift
//  Keijiban
//
//  Created by Seth on 2016-05-26.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSWindowDelegate {
    
    /// The main window of this view controller
    var window : NSWindow = NSWindow();
    
    /// The visual effect view for the background of the window
    @IBOutlet var backgroundVisualEffectView: NSVisualEffectView!
    
    /// The visual effect view for the titlebar of the window
    @IBOutlet var titlebarVisualEffectView: NSVisualEffectView!
    
    /// The split view controller for the content of this window(Sidebar and posts)
    var contentSplitViewController: KJBrowserWindowSplitViewController!
    
    /// The sidebar view controller for this window
    var contentSidebarViewController: KJBrowserWindowSidebarViewController!
    
    /// The posts view controller for this window
    var contentPostsViewController: KJBrowserWindowPostsViewController!
    
    /// The button in the titlebar for hiding/showing the sidebar
    @IBOutlet var titlebarToggleSidebarButton: NSButton!
    
    /// When we push titlebarToggleSidebarButton...
    @IBAction func titlebarToggleSidebarButtonPressed(sender: AnyObject) {
        // Toggle if the sidebar is collapsed
        contentSplitViewController.splitViewItems[0].animator().collapsed = !contentSplitViewController.splitViewItems[0].collapsed;
        
        // Update the sidebar toggle button
        updateSidebarToggleButton();
    }
    
    /// Updates titlebarToggleSidebarButton to match if the sidebar is collapsed
    func updateSidebarToggleButton() {
        // Set the sidebar toggle buttons state based on if the sidebar is collapsed
        titlebarToggleSidebarButton.state = Int(contentSplitViewController.splitViewItems[0].collapsed);
    }
    
    /// Called when the user does CMD+T. Adds a new tab
    func newTabAction() {
        // Add a new tab
        contentPostsViewController.addNewTab();
    }
    
    /// Called when the user does CMD+W. Closes the current tab if there are more than one, and if there is only one or less closes the window
    func closeAction() {
        // If there is more than one tab open...
        if(contentPostsViewController.tabs.count > 1) {
            // Close the selected tab
            contentPostsViewController.closeCurrentTab();
        }
        // If there is only one tab or less open...
        else {
            // Close the window
            window.close();
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        // Style the window
        styleWindow();
    }
    
    func windowWillEnterFullScreen(notification: NSNotification) {
        // Hide the toolbar
        window.toolbar?.visible = false;
        
        // Set the window's appearance to vibrant dark so the fullscreen toolbar is dark
        window.appearance = NSAppearance(named: NSAppearanceNameVibrantDark);
    }
    
    func windowDidExitFullScreen(notification: NSNotification) {
        // Show the toolbar
        window.toolbar?.visible = true;
        
        // Set back the window's appearance
        window.appearance = NSAppearance(named: NSAppearanceNameAqua);
    }
    
    /// Styles the window
    func styleWindow() {
        // Get the window
        window = NSApplication.sharedApplication().windows.last!;
        
        // Set the window's delegate
        window.delegate = self;
        
        // Style the visual effect views
        titlebarVisualEffectView.material = .Titlebar;
        backgroundVisualEffectView.material = .Dark;
        
        // Style the window's titlebar
        window.titleVisibility = .Hidden;
        window.styleMask |= NSFullSizeContentViewWindowMask;
        window.titlebarAppearsTransparent = true;
    }
    
    /// Called when the collapsed state of the sidebar for this browser window's content changes
    func sidebarCollapsedStateChanged() {
        // Update the sidebar toggle button
        updateSidebarToggleButton();
    }
    
    func windowDidBecomeKey(notification: NSNotification) {
        // Set all the menu item targets
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender);
        
        // If this is the segue for the content view container....
        if(segue.identifier == "contentSplitViewControllerSegue") {
            // Set contentSplitViewController
            contentSplitViewController = segue.destinationController as! KJBrowserWindowSplitViewController;
            
            // Get contentSidebarViewController and contentPostsViewController
            contentSidebarViewController = contentSplitViewController.splitViewItems[0].viewController as! KJBrowserWindowSidebarViewController;
            contentPostsViewController = contentSplitViewController.splitViewItems[1].viewController as! KJBrowserWindowPostsViewController;
            
            // Set contentSplitViewController's sidebar collapsed state changed target and action
            contentSplitViewController.sidebarCollapseStateChangedTarget = self;
            contentSplitViewController.sidebarCollapseStateChangedAction = Selector("sidebarCollapsedStateChanged");
        }
    }
}