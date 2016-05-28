//
//  KJ4CUtilities.swift
//  Keijiban
//
//  Created by Seth on 2016-05-28.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa
import Alamofire

/// Utilities for getting info from 4chan
class KJ4CUtilities {
    /// The base URL of the 4chan API(With a trailing slash)
    let apiBaseUrl : String = "https://a.4cdn.org/";
    
    /// All the boards on 4chan currently
    var boards : [KJ4CBoard] = [];
    
    /// Gets all the boards from 4chan and loads them into boards. Also calls the given completion handler when its done(If its not nil)
    func getAllBoards(completionHandler: (() -> ())?) {
        // Print what URL we are using to get the board list
        print("KJ4CUtilities: Using URL \(apiBaseUrl + "boards.json") to get board list");
        
        // Clear boards
        boards.removeAll();
        
        // Make the request to get the boards
        Alamofire.request(.GET, apiBaseUrl + "boards.json", encoding: .JSON).responseJSON { (responseData) -> Void in
            /// The string of JSON that will be returned when the GET request finishes
            let responseJsonString : NSString = NSString(data: responseData.data!, encoding: NSUTF8StringEncoding)!;
            
            // If the the response data isnt nil...
            if let dataFromResponseJsonString = responseJsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                /// The JSON from the response string
                let responseJson = JSON(data: dataFromResponseJsonString);
                
                // For every board in boards in the response JSON...
                for(_, currentBoard) in responseJson["boards"].enumerate() {
                    // Add the current board to boards
                    self.boards.append(KJ4CBoard(code: currentBoard.1["board"].stringValue, name: currentBoard.1["title"].stringValue));
                }
                
                // Call the completion handler
                completionHandler?();
            }
        }
    }
}