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
    
    /// The text field that shows the amount of images and replies in this thread
    @IBOutlet var imageReplyCountTextField: NSTextField!
    
    override func mouseDown(theEvent: NSEvent) {
        super.mouseDown(theEvent);
        
        /// The post that was clicked
        let clickedPost : KJ4COPPost = (self.representedObject as! KJ4COPPost);
        
        // Open the clicked post in a new tab
        (self.collectionView.window!.contentViewController as! Keijiban.ViewController).contentPostsViewController.downloadThreadAndOpenNewTab(clickedPost, downloadCompletionHandler: nil, displayCompletionHandler: nil);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        // Theme the view
        self.textField?.textColor = KJThemingEngine().defaultEngine().commentTextColor;
        imageReplyCountTextField.textColor = KJThemingEngine().defaultEngine().catalogItemImageReplyCountTextColor;
    }
}
