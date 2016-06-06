//
//  KJFloatAtTopClipView.swift
//  Keijiban
//
//  Created by Seth on 2016-06-06.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class KJFloatAtTopClipView: NSClipView {
    override func constrainBoundsRect(proposedBounds: NSRect) -> NSRect {
        /// The value that is returned from the superclasses' constrainBoundsRect
        var superConstrainedBoundsRect = super.constrainBoundsRect(proposedBounds);
        
        // If the document view isnt nil...
        if let containerView = self.documentView as? NSView {
            // If superConstrainedBoundsRect's height is greater than the height of the container view...
            if(superConstrainedBoundsRect.size.height > containerView.frame.size.height) {
                // Set the rect's Y origin to the container view's height minus superConstrainedBoundsRect's height(Putting it at the top)
                superConstrainedBoundsRect.origin.y = (containerView.frame.height - superConstrainedBoundsRect.height);
            }
        }
        
        // Return superConstrainedBoundsRect
        return superConstrainedBoundsRect;
    }
}
