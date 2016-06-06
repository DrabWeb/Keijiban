//
//  KJExtensions.swift
//  Keijiban
//
//  Created by Seth on 2016-06-04.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

extension String {
    /// Returns this string without any special HTML characters
    var cleanedString : String {
        /// This string, cleaned
        var cleanedString : String = self;
        
        // Replace the special characters
        cleanedString = cleanedString.stringByReplacingOccurrencesOfString("&#039;", withString: "'");
        cleanedString = cleanedString.stringByReplacingOccurrencesOfString("&gt;", withString: ">");
        cleanedString = cleanedString.stringByReplacingOccurrencesOfString("&lt;", withString: "<");
        cleanedString = cleanedString.stringByReplacingOccurrencesOfString("&quot;", withString: "\"");
        cleanedString = cleanedString.stringByReplacingOccurrencesOfString("&amp;", withString: "&");
        cleanedString = cleanedString.stringByReplacingOccurrencesOfString("&quot;", withString: "\"");
        cleanedString = cleanedString.stringByReplacingOccurrencesOfString("<br>", withString: "\n");
        
        // Return the cleaned string
        return cleanedString;
    }
}

extension NSImage {
    /// Returns this image overlayed with the given color
    func withColorOverlay(overlayColor : NSColor) -> NSImage {
        /// This image with the color overlay
        let coloredImage : NSImage = self.copy() as! NSImage;
        
        /// The pixel size of this image
        let imageSize : NSSize = self.pixelSize;
        
        // Lock drawing focus on coloredImage
        coloredImage.lockFocus();
        
        // Draw the image
        coloredImage.drawInRect(NSRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height), fromRect: NSRect.zero, operation: NSCompositingOperation.CompositeSourceOver, fraction: 1);
        
        // Set the overlay color
        overlayColor.set();
        
        // Fill the image with the overlay color
        NSRectFillUsingOperation(NSRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height), NSCompositingOperation.CompositeSourceAtop);
        
        // Unlock drawing focus on coloredImage
        coloredImage.unlockFocus();
        
        // Return the new image
        return coloredImage;
    }
    
    /// The pixel size of this image
    var pixelSize : NSSize {
        /// The NSBitmapImageRep to the image
        let imageRep : NSBitmapImageRep = (NSBitmapImageRep(data: self.TIFFRepresentation!))!;
        
        /// The size of the iamge
        let imageSize : NSSize = NSSize(width: imageRep.pixelsWide, height: imageRep.pixelsHigh);
        
        // Return the image size
        return imageSize;
    }
}

extension Array where Element:KJ4CPost {
    /// Returns the KJ4CPost with the given post number in this array(If there is none it returns nil)
    func findPostByNumber(postNumber : Int) -> KJ4CPost? {
        /// The post that was possibly found in this array
        var foundPost : KJ4CPost? = nil;
        
        // For every post in this array...
        for(_, currentPost) in self.enumerate() {
            // If the current post's post number is equal to the given post number...
            if(currentPost.postNumber == postNumber) {
                // Set foundPost to this post
                foundPost = currentPost;
            }
        }
        
        // Return the post
        return foundPost;
    }
}