//
//  KJ4CBoard.swift
//  Keijiban
//
//  Created by Seth on 2016-05-28.
//

import Cocoa

/// Represents a board on 4chan
class KJ4CBoard: NSObject {
    /// The code for this board(a, g, jp, ETC.)
    var code : String = "";
    
    /// The name of this board
    var name : String = "";
    
    // Override the print output to be useful
    override var description : String {
        return "<Keijiban.KJ4CBoard: /\(code)/ - \(name)>";
    }
    
    // Init with a code and name
    init(code : String, name : String) {
        super.init();
        
        self.code = code;
        self.name = name;
    }
    
    // Blank init
    override init() {
        super.init();
        
        self.code = "";
        self.name = "";
    }
}