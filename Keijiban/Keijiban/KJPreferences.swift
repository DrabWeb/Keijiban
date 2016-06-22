//
//  KJPreferences.swift
//  Keijiban
//
//  Created by Seth on 2016-05-29.
//

import Cocoa

class KJPreferences: NSObject {
    /// The boards that the user wants to show
    var boards : [String] = ["a", "c", "cm", "g", "jp", "w"];
    
    /// The default page to open when the user opens a new tab
    var defaultNewTabPage : KJNewTabPage = KJNewTabPage.Catalog;
}

/// The different types of pages you can open by default when opening a new tab
enum KJNewTabPage {
    /// The catalog collection view
    case Catalog
    
    /// The indx posts viewer
    case Index
}