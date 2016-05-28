//
//  AppDelegate.swift
//  Keijiban
//
//  Created by Seth on 2016-05-26.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    /// File/New Browser (⌘N)
    @IBOutlet weak var menuItemNewBrowser: NSMenuItem!
    
    /// File/New Tab (⌘T)
    @IBOutlet weak var menuItemNewTab: NSMenuItem!
    
    /// When the user activates menuItemNewTab...
    @IBAction func menuItemNewTabInteracted(sender: NSMenuItem) {
        // If the frontmost view controller is a browser window view controller...
        if((NSApp.mainWindow?.contentViewController as? ViewController) != nil) {
            // Open a new tab in the frontmost browser window
            (NSApp.mainWindow!.contentViewController as! ViewController).performSelector(Selector("newTabAction"));
        }
        // If the frontmost view controller isnt a browser window view controller...
        else {
            // Open a new browser window
            menuItemNewBrowser.target?.performSelector(menuItemNewBrowser.action);
        }
    }
    
    /// File/Close (⌘W)
    @IBOutlet weak var menuItemClose: NSMenuItem!

    /// View/Toggle Sidebar (⇧⌘L)
    @IBOutlet weak var menuItemToggleSidebar: NSMenuItem!
    
    /// View/Tabs/Tab 1 (⌘1)
    @IBOutlet weak var menuItemTabsTabOne: NSMenuItem!
    
    /// View/Tabs/Tab 2 (⌘2)
    @IBOutlet weak var menuItemTabsTabTwo: NSMenuItem!
    
    /// View/Tabs/Tab 3 (⌘3)
    @IBOutlet weak var menuItemTabsTabThree: NSMenuItem!
    
    /// View/Tabs/Tab 4 (⌘4)
    @IBOutlet weak var menuItemTabsTabFour: NSMenuItem!
    
    /// View/Tabs/Tab 5 (⌘5)
    @IBOutlet weak var menuItemTabsTabFive: NSMenuItem!
    
    /// View/Tabs/Tab 6 (⌘6)
    @IBOutlet weak var menuItemTabsTabSix: NSMenuItem!
    
    /// View/Tabs/Tab 7 (⌘7)
    @IBOutlet weak var menuItemTabsTabSeven: NSMenuItem!
    
    /// View/Tabs/Tab 8 (⌘8)
    @IBOutlet weak var menuItemTabsTabEight: NSMenuItem!
    
    /// View/Tabs/Tab 9 (⌘9)
    @IBOutlet weak var menuItemTabsTabNine: NSMenuItem!
    
    /// The main 4chan utilities for the app
    let chanUtilities : KJ4CUtilities = KJ4CUtilities();
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        // Make the application folders
        makeApplicationFolders();
        
        // Setup the menu item actions
        setupMenuItemActions();
    }
    
    /// Makes the folders needed for the application(Application Support, ETC.)
    func makeApplicationFolders() {
        do {
            // Make the application support folder
            try NSFileManager.defaultManager().createDirectoryAtPath(KJConstants.applicationSupportDirectory, withIntermediateDirectories: false, attributes: nil);
        }
        catch _ as NSError {
            // Do nothing, pretty much the only possible error is that it already exists
        }
    }
    
    /// Sets up the actions for the menu items that are dependant on the frontmost window
    func setupMenuItemActions() {
        // Set the actions
        menuItemClose.action = Selector("closeAction");
        menuItemToggleSidebar.action = Selector("toggleSidebarAction");
        
        menuItemTabsTabOne.action = Selector("actionJumpToTabOne");
        menuItemTabsTabTwo.action = Selector("actionJumpToTabTwo");
        menuItemTabsTabThree.action = Selector("actionJumpToTabThree");
        menuItemTabsTabFour.action = Selector("actionJumpToTabFour");
        menuItemTabsTabFive.action = Selector("actionJumpToTabFive");
        menuItemTabsTabSix.action = Selector("actionJumpToTabSix");
        menuItemTabsTabSeven.action = Selector("actionJumpToTabSeven");
        menuItemTabsTabEight.action = Selector("actionJumpToTabEight");
        menuItemTabsTabNine.action = Selector("actionJumpToTabNine");
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
}

