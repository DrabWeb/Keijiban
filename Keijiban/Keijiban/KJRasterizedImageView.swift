//
//  KJRasterizedImageView.swift
//  Keijiban
//
//  Created by Seth on 2016-05-29.
//

import Cocoa
import DKAsyncImageView

class KJRasterizedImageView: NSImageView {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        // Drawing code here.
        // Rasterize the layer
        self.layer?.shouldRasterize = true;
    }
}

class KJRasterizedAsyncImageView: DKAsyncImageView {
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        // Drawing code here.
        // Rasterize the layer
        self.layer?.shouldRasterize = true;
    }
}
