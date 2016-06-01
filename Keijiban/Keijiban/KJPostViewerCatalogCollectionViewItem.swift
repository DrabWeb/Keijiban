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
    
    /// The text field that shows the amount of images and replies in this thread
    @IBOutlet var imageReplyCountTextField: NSTextField!
    
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
        // Theme the view
        self.textField?.textColor = KJThemingEngine().defaultEngine().textColor;
        imageReplyCountTextField.textColor = KJThemingEngine().defaultEngine().catalogItemImageReplyCountTextColor;
    }
}
