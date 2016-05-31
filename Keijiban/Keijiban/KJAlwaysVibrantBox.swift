//
//  KJAlwaysVibrantBox.swift
//  Keijiban
//
//  Created by Seth on 2016-05-31.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class KJAlwaysVibrantBox: NSBox {
    
    override var allowsVibrancy : Bool {
        return true;
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
}
