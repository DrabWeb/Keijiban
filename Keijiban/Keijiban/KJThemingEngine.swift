//
//  KJThemingEngine.swift
//  Keijiban
//
//  Created by Seth on 2016-05-30.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class KJThemingEngine {
    var quoteColor : NSColor = NSColor(hexString: "#799C00")!;
    
    /// Returns the default theming engine
    func defaultEngine() -> KJThemingEngine {
        return KJThemingEngineStruct.defaultEngine;
    }
}

struct KJThemingEngineStruct {
    /// The default theming engine for Keijiban
    static var defaultEngine : KJThemingEngine = KJThemingEngine();
}