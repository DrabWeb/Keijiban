//
//  KJRasterizedImageView.swift
//  Keijiban
//
//  Created by Seth on 2016-05-29.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class KJRasterizedImageView: NSImageView {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        // Drawing code here.
        // Rasterize the layer
        self.layer?.shouldRasterize = true;
    }
}
