//
//  KJThemingEngine.swift
//  Keijiban
//
//  Created by Seth on 2016-05-30.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class KJThemingEngine {
    /// The color for the background of a post view
    var backgroundColor : NSColor = NSColor(hexString: "#1D1F21")!;
    
    /// The text color for comments
    var commentTextColor : NSColor = NSColor(hexString: "#C5C8C6")!;
    
    /// The text color for the poster info labels
    var posterInfoTextColor : NSColor = NSColor(hexString: "#C5C8C6")!;
    
    /// The color for the reply button on post views
    var replyButtonColor : NSColor = NSColor(hexString: "#757777")!;
    
    /// The color for the replies button and its text on post views
    var repliesButtonColor : NSColor = NSColor(hexString: "#757777")!;
    
    /// The text color for the file info text field in post views
    var fileInfoTextColor : NSColor = NSColor(hexString: "#757777")!;
    
    /// The text color for the image/reply count text field on catalog items
    var catalogItemImageReplyCountTextColor : NSColor = NSColor(hexString: "#C5C8C6")!;
    
    /// The color for a post info's subject(If there is one)
    var postSubjectColor : NSColor = NSColor(hexString: "#B294BB")!;
    
    /// The color for quotes(The >text ones)
    var quoteColor : NSColor = NSColor(hexString: "#B5BD68")!;
    
    /// The color for post quotes(The >>######### ones)
    var postQuoteColor : NSColor = NSColor(hexString: "#81A2BE")!;
    
    /// The color for dead post quotes(The >>######### ones)
    var deadPostQuoteColor : NSColor = NSColor(hexString: "#81A2BE")!;
    
    /// The color for post separators
    var postSeparatorColor : NSColor = NSColor(hexString: "#282A2E")!;
    
    /// The toolbar color for image browsers
    var imageBrowserToolbarColor : NSColor = NSColor(hexString: "#141414")!;
    
    /// The height of the toolbar in any image browser
    var imageBrowserToolbarHeight : CGFloat = 37;
    
    /// The color for the file info text field in the toolbar in an image browser
    var imageBrowserToolbarFileInfoTextFieldColor : NSColor = NSColor(hexString: "#C5C8C6")!;
    
    // The color for the download button in the toolbar in an image browser
    var imageBrowserToolbarDownloadButtonColor : NSColor = NSColor(hexString: "#C5C8C6")!;
    
    /// The color for the next image button in the toolbar in an image browser
    var imageBrowserToolbarNextButtonColor : NSColor = NSColor(hexString: "#C5C8C6")!;
    
    /// The color for the previous image button in the toolbar in an image browser
    var imageBrowserToolbarPreviousButtonColor : NSColor = NSColor(hexString: "#C5C8C6")!;
    
    /// The color for the gallery button in the toolbar in an image browser
    var imageBrowserToolbarGalleryButtonColor : NSColor = NSColor(hexString: "#C5C8C6")!;
    
    /// Returns the default theming engine
    func defaultEngine() -> KJThemingEngine {
        return KJThemingEngineStruct.defaultEngine;
    }
}

struct KJThemingEngineStruct {
    /// The default theming engine for Keijiban
    static var defaultEngine : KJThemingEngine = KJThemingEngine();
}