//
//  KJChangeCursorOnHoverView.swift
//  Keijiban
//
//  Created by Seth on 2016-06-10.
//

import Cocoa

class KJChangeCursorOnHoverView: NSView {
    /// The cursor to change to when hovering this view
    var hoverCursor : NSCursor = NSCursor.pointingHandCursor();
    
    override func mouseEntered(theEvent: NSEvent) {
        super.mouseEntered(theEvent);
        
        // Change the cursor
        hoverCursor.set();
    }
    
    override func mouseExited(theEvent: NSEvent) {
        super.mouseExited(theEvent);
        
        // Change the cursor back to the default cursor
        NSCursor.arrowCursor().set();
    }
    
    deinit {
        // Change the cursor back to the default cursor
        NSCursor.arrowCursor().set();
    }
    
    /// The tracking area for this view
    private var trackingArea : NSTrackingArea? = nil;
    
    override func viewWillDraw() {
        // Update the tracking areas
        self.updateTrackingAreas();
    }
    
    override func updateTrackingAreas() {
        // Remove the tracking are we added before
        if(trackingArea != nil) {
            self.removeTrackingArea(trackingArea!);
        }
        
        /// The same as the original tracking area, but updated to match the frame of this view
        trackingArea = NSTrackingArea(rect: frame, options: [NSTrackingAreaOptions.MouseEnteredAndExited, NSTrackingAreaOptions.ActiveInKeyWindow], owner: self, userInfo: nil);
        
        // Add the tracking area
        self.addTrackingArea(trackingArea!);
    }
    
    override func awakeFromNib() {
        /// The tracking are we will use for getting mouse entered and exited events
        trackingArea = NSTrackingArea(rect: frame, options: [NSTrackingAreaOptions.MouseEnteredAndExited, NSTrackingAreaOptions.ActiveInKeyWindow], owner: self, userInfo: nil);
        
        // Add the tracking area
        self.addTrackingArea(trackingArea!);
    }
}
