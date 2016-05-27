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

    /// File/New Tab (⌘T)
    @IBOutlet weak var menuItemNewTab: NSMenuItem!
    
    /// File/Close (⌘W)
    @IBOutlet weak var menuItemClose: NSMenuItem!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        // Setup the menu item actions
        setupMenuItemActions();
    }
    
    /// Sets up the actions for the menu items that are dependant on the frontmost window
    func setupMenuItemActions() {
        // Set the actions
        menuItemNewTab.action = Selector("newTabAction");
        menuItemClose.action = Selector("closeAction");
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
}

