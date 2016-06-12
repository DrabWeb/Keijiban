//
//  KJCommentTextView.swift
//  Keijiban
//
//  Created by Seth on 2016-06-11.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class KJCommentTextView: NSTextView, NSTextViewDelegate {
    
    override var intrinsicContentSize : NSSize {
        // Make this text view size to it's content
        // Ensure the layout for this text view's text container
        self.layoutManager!.ensureLayoutForTextContainer(self.textContainer!);
        
        // Return the text container's size
        return self.layoutManager!.usedRectForTextContainer(self.textContainer!).size;
    }
    
    override func viewWillDraw() {
        super.viewWillDraw();
        
        // Re-calculate the intrinsic content size
        self.invalidateIntrinsicContentSize();
    }
    
    override func clickedOnLink(link: AnyObject, atIndex charIndex: Int) {
        Swift.print("Clicked on link \"\(link)\"");
    }
}