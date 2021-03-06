//
//  KJImageUtilities.swift
//  Keijiban
//
//  Created by Seth on 2016-06-09.
//

import Cocoa

class KJImageUtilities {
    /// Returns the NSBitmapImageFileType from the given extension
    func fileTypeFromExtension(fileExtension : String) -> NSBitmapImageFileType? {
        /// The file type to return
        var fileType : NSBitmapImageFileType? = nil;
        
        // If the extension is PNG...
        if(fileExtension.lowercaseString == "png") {
            // Set fileType to PNG
            fileType = NSBitmapImageFileType.NSPNGFileType;
        }
            // If the extension is GIF...
        else if(fileExtension.lowercaseString == "gif") {
            // Set fileType to GIF
            fileType = NSBitmapImageFileType.NSGIFFileType;
        }
            // If the extension is TIFF...
        else if(fileExtension.lowercaseString == "tiff") {
            // Set fileType to GIF
            fileType = NSBitmapImageFileType.NSGIFFileType;
        }
            // If the extension is JPG or JPEG...
        else if(fileExtension.lowercaseString == "jpg" || fileExtension.lowercaseString == "jpeg") {
            // Set fileType to GIF
            fileType = NSBitmapImageFileType.NSJPEGFileType;
        }
        
        // Return the file type
        return fileType;
    }
}
