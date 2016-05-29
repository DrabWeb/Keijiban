//
//  KJPostViewerCatalogCollectionViewItem.swift
//  Keijiban
//
//  Created by Seth on 2016-05-29.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa
import Alamofire

class KJPostViewerCatalogCollectionViewItem: NSCollectionViewItem {

    /// The object to perform clickedAction
    var clickedTarget : AnyObject? = nil;
    
    /// The selector to call when the user clicks this thread(Passed the KJ4COPPost that was clicked)
    var clickedAction : Selector = Selector("");
    
    override func mouseDown(theEvent: NSEvent) {
        super.mouseDown(theEvent);
        
        /// The post that was clicked
        let clickedPost : KJ4COPPost = (self.representedObject as! KJ4COPPost);
        
        // Call the clicked action
        clickedTarget?.performSelector(clickedAction, withObject: clickedPost);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
}
