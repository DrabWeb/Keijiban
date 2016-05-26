//
//  KJBrowserWindowPostsTabItem.swift
//  Keijiban
//
//  Created by Seth on 2016-05-26.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

/// The class for tab items in a browser window's posts view
class KJBrowserWindowPostsTabItem {
    /// The title for this tab
    var title : String = "Title Not Set";
    
    // Init with a title
    init(title : String) {
        self.title = title;
    }
    
    // Blank init
    init() {
        self.title = "Title Not Set";
    }
}
