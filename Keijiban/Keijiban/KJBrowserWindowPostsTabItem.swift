//
//  KJBrowserWindowPostsTabItem.swift
//  Keijiban
//
//  Created by Seth on 2016-05-26.
//

import Cocoa

/// The class for tab items in a browser window's posts view
class KJBrowserWindowPostsTabItem {
    /// The title for this tab
    var title : String = "Title Not Set";
    
    /// The post viewer view controller for this tab
    var viewController : KJPostViewerViewController? = nil;
    
    // Init with a title
    init(title : String) {
        self.title = title;
    }
    
    // Blank init
    init() {
        self.title = "Title Not Set";
    }
}
