//
//  KJBrowserWindowSplitViewController.swift
//  Keijiban
//
//  Created by Seth on 2016-05-26.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class KJBrowserWindowSplitViewController: NSSplitViewController {

    /// The object to perform sidebarCollapseStateChangedAction
    var sidebarCollapseStateChangedTarget : AnyObject? = nil;
    
    /// The selector to call when the collapsed state of the sidebar changes
    var sidebarCollapseStateChangedAction : Selector? = nil;
    
    override func splitViewDidResizeSubviews(notification: NSNotification) {
        // If sidebarCollapseStateChangedTarget and sidebarCollapseStateChangedAction are not nil...
        if(sidebarCollapseStateChangedTarget != nil && sidebarCollapseStateChangedAction != nil) {
            // Call the sidebar collapse state changed action, with if the sidebar is collapsed
            sidebarCollapseStateChangedTarget!.performSelector(sidebarCollapseStateChangedAction!);
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
}
