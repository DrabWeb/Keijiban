//
//  KJColoredTitleButton.swift
//  Keijiban
//
//  Created by Seth on 2016-06-06.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class KJColoredTitleButton: NSButton {
    /// The color for this button's title
    var titleColor : NSColor = NSColor.blackColor() {
        didSet {
            // Update the title color
            updateTitleColor();
        }
    };
    
    override var title : String {
        didSet {
            // Update the title color
            updateTitleColor();
        }
    }
    
    /// Updates the title color for this button
    func updateTitleColor() {
        /// The paragraph style for the buttons title
        let titleParagraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle();
        
        // Set the title alignment to the button's title alignment
        titleParagraphStyle.alignment = self.alignment;
        
        /// The attributes dictionary for the title attributed string
        let titleAttributesDictionary : [String:AnyObject]? = [NSForegroundColorAttributeName:self.titleColor, NSFontAttributeName:self.font!, NSParagraphStyleAttributeName:titleParagraphStyle];
        
        /// The attributed string for the title
        let titleAttributedString : NSAttributedString = NSAttributedString(string: self.title, attributes: titleAttributesDictionary);
        
        // Set the title to the created attributed string
        self.attributedTitle = titleAttributedString;
    }
}
