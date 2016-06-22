//
//  KJThumbnailImageView.swift
//  Keijiban
//
//  Created by Seth on 2016-06-10.
//

import Cocoa

class KJThumbnailImageView: KJRasterizedAsyncImageView {
    /// The object to perform clickAction
    var clickTarget : AnyObject? = nil;
    
    /// The selector to call when the user presses this thumbnail view
    var clickAction : Selector = Selector("");
    
    override func mouseDown(theEvent: NSEvent) {
        super.mouseDown(theEvent);
        
        // Call the click action
        clickTarget?.performSelector(clickAction);
    }
    
    /// Adds the KJChangeCursorOnHoverView to this view so we show a pointing hand cursor when hovering the thumbnail
    func addChangeCursorOnHoverView() {
        // Create the view
        /// The KJChangeCursorOnHoverView for this thumbnail view
        let changeCursorOnHoverView : KJChangeCursorOnHoverView = KJChangeCursorOnHoverView();
        
        // Move it into this view
        self.addSubview(changeCursorOnHoverView);
        
        // Disable all the autoresizing mask to constraint translation
        self.translatesAutoresizingMaskIntoConstraints = false;
        changeCursorOnHoverView.translatesAutoresizingMaskIntoConstraints = false;
        
        // Add the outer constraints
        changeCursorOnHoverView.addOuterConstraints(0);
    }
    
    /// Was this post view inited from init(As apposed to awakeFromNib)?
    private var initedFromInit : Bool = false;
    
    override func awakeFromNib() {
        super.awakeFromNib();
        
        // If we didnt init from init...
        if(!initedFromInit) {
            // Add the change cursor on hover view
            addChangeCursorOnHoverView();
        }
    }
    
    // Blank init
    init() {
        super.init(frame: NSRect.zero);
        
        // Set initedFromInit to true
        initedFromInit = true;
        
        // Add the change cursor on hover view
        addChangeCursorOnHoverView();
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
}
