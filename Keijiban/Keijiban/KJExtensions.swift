//
//  KJExtensions.swift
//  Keijiban
//
//  Created by Seth on 2016-06-04.
//

import Cocoa

extension String {
    /// Returns this string without any special HTML characters/tags that arent needed for parsing
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
        cleanedString = cleanedString.stringByReplacingOccurrencesOfString("<wbr>", withString: "");
        
        // Return the cleaned string
        return cleanedString;
    }
    
    /// Return the content inside the href tag(If any) of this string
    func hrefContent() -> String? {
        /// The href content of this string
        var hrefContent : String? = nil;
        
        // If this string contains a "href=""...
        if(self.containsString("href=\"")) {
            /// The start index of the href tag
            let hrefStartIndex : String.Index = self.rangeOfString("href=\"")!.last!.advancedBy(1);
            
            /// The string after "href=""
            let hrefContentWithEnd : String = self.substringFromIndex(hrefStartIndex);
            
            // Set hrefContent
            hrefContent = hrefContentWithEnd.substringToIndex(hrefContentWithEnd.rangeOfString("\"")!.last!);
        }
        
        // Return the href content
        return hrefContent;
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
    
    /// Saves this image to the given path with the given file type
    func saveTo(filePath : String, fileType : NSBitmapImageFileType) {
        // Save the image data to the given path
        self.dataForFileType(fileType)?.writeToFile(filePath, atomically: false);
    }
    
    /// Returns the NSData for this image with the given NSBitmapImageFileType
    func dataForFileType(fileType : NSBitmapImageFileType) -> NSData? {
        // If the bitmap representation isnt nil...
        if let imageRepresentation = self.representations[0] as? NSBitmapImageRep {
            // If the data using the given file type isnt nil...
            if let data = imageRepresentation.representationUsingType(fileType, properties: [:]) {
               // Return the data
                return data;
            }
        }
        
        // Return nil
        return nil;
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

extension NSView {
    /// Adds constraints for the top, bottom, leading and trailing edges of this view with the given constant
    func addOuterConstraints(constant : CGFloat) {
        /// The constraint for the bottom edge
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.superview!, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: constant);
        
        // Add the constraint
        self.superview!.addConstraint(bottomConstraint);
        
        /// The constraint for the top edge
        let topConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.superview!, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: constant);
        
        // Add the constraint
        self.superview!.addConstraint(topConstraint);
        
        /// The constraint for the trailing edge
        let trailingConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.superview!, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: constant);
        
        // Add the constraint
        self.superview!.addConstraint(trailingConstraint);
        
        /// The constraint for the leading edge
        let leadingConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.superview!, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: constant);
        
        // Add the constraint
        self.superview!.addConstraint(leadingConstraint);
    }
}