//
//  KJColoredView.swift
//  Keijiban
//
//  Created by Seth on 2016-05-26.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class KJColoredView: NSView {
    /// The background color of the view
    @IBInspectable var backgroundColor : NSColor = NSColor.clearColor();
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        // Drawing code here.
        // Make sure we get a layer
        self.wantsLayer = true;
        
        // Set the layer's background color
        self.layer?.backgroundColor = backgroundColor.CGColor;
    }
}
