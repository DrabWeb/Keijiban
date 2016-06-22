//
//  KJNoDividerSplitView.swift
//  Keijiban
//
//  Created by Seth on 2016-05-26.
//

import Cocoa

class KJNoDividerSplitView: NSSplitView {

    // Return 0 for the divider thickness so there is no divider
    override var dividerThickness : CGFloat {
        return 0;
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
}
