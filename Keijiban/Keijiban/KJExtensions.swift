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