//
//  KJCommentTextView.swift
//  Keijiban
//
//  Created by Seth on 2016-06-11.
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
    
    func textView(textView: NSTextView, willChangeSelectionFromCharacterRange oldSelectedCharRange: NSRange, toCharacterRange newSelectedCharRange: NSRange) -> NSRange {
        // Disable selecting text
        return NSMakeRange(0, 0);
    }
    
    override func setSelectedRanges(ranges: [NSValue], affinity: NSSelectionAffinity, stillSelecting stillSelectingFlag: Bool) {
        // Disable selecting text
    }
    
    override func mouseMoved(theEvent: NSEvent) {
        super.mouseMoved(theEvent);
        
        NSCursor.arrowCursor().set();
    }
    
    override func mouseEntered(theEvent: NSEvent) {
        super.mouseEntered(theEvent);
        
        NSCursor.arrowCursor().set();
    }
    
    override func clickedOnLink(link: AnyObject, atIndex charIndex: Int) {
        Swift.print("Clicked on link \"\(link)\"");
    }
}