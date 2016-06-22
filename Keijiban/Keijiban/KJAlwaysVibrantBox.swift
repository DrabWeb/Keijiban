//
//  KJAlwaysVibrantBox.swift
//  Keijiban
//
//  Created by Seth on 2016-05-31.
//

import Cocoa

class KJAlwaysVibrantBox: NSBox {
    
    override var allowsVibrancy : Bool {
        return self.appearance != NSAppearance(named: NSAppearanceNameAqua);
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
}
