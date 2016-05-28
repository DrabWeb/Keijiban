//
//  KJSidebarViewController.swift
//  Keijiban
//
//  Created by Seth on 2016-05-26.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

/// The view controller for the sidebar of browsing windows
class KJBrowserWindowSidebarViewController: NSViewController {

    /// The visual effect view for the background of the sidebar
    @IBOutlet var backgroundVisualEffectView: NSVisualEffectView!
    
    /// The source list for this sidebar
    @IBOutlet weak var sidebarSourceList: PXSourceList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        // Style the view
        styleView();
    }
    
    /// Styles this view
    func styleView() {
        // Style the visual effect views
        backgroundVisualEffectView.material = .Titlebar;
    }
}
