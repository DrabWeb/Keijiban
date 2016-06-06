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
    
    /// Processes the given posts and sets their replies and replies to values
    func processPostReplies(posts : [KJ4CPost]) {
        // For every post in the given posts...
        for(_, currentPost) in posts.enumerate() {
            // Clear the current post's replies to and replies
            currentPost.repliesTo.removeAll();
            currentPost.replies.removeAll();
            
            /// Every range of "<a href="#p*" class="quotelink">" in comment
            var postQuoteRanges : [NSRange] = [];
            
            do {
                /// The regex for looking for "<a href="#p*" class="quotelink">" in the current post's comment
                let postQuoteRegex = try NSRegularExpression(pattern: "<a href=\"#p.*\" class=\"quotelink\">", options: []);
                
                // Set postQuoteRanges to the every range of "<a href="#p*" class="quotelink">"
                postQuoteRanges = postQuoteRegex.matchesInString(currentPost.comment, options: [], range: NSMakeRange(0, currentPost.comment.characters.count)).map {$0.range}
                
                // For every range in postQuoteRanges...
                for(_, currentRange) in postQuoteRanges.enumerate() {
                    /// The start index for the href content of the current quote tag
                    let startIndex : String.Index = currentPost.comment.startIndex.advancedBy(currentRange.location + 9);
                    
                    /// The end index for the href content of the current quote tag
                    let endIndex : String.Index = currentPost.comment.startIndex.advancedBy(currentRange.location + currentRange.length);
                    
                    /// The content of the current tag's href, with the ending of the quote tag
                    let hrefContentWithEnd : String = currentPost.comment.substringWithRange(Range<String.Index>(start: startIndex, end: endIndex));
                    
                    /// The current quote tag's href content
                    let hrefContent : String = hrefContentWithEnd.substringWithRange(Range<String.Index>(start: hrefContentWithEnd.startIndex, end: hrefContentWithEnd.rangeOfString("\"")!.startIndex));
                    
                    // If the hrefContent starts with a "#p"(Meaning the post is in this thread)...
                    if(hrefContent.hasPrefix("#p")) {
                        /// The post that was quoted in the href content
                        let quotedPost : KJ4CPost = posts.findPostByNumber(NSString(string: hrefContent.stringByReplacingOccurrencesOfString("#p", withString: "")).integerValue)!;
                        
                        // If the current post's replies to doesnt already have quoteodPost...
                        if(!currentPost.repliesTo.contains(quotedPost)) {
                            // Add the quoted post to the current post's repliesTo
                            currentPost.repliesTo.append(quotedPost);
                            
                            // If the current post's replies doesnt already have currentPost...
                            if(!currentPost.repliesTo.last!.replies.contains(currentPost)) {
                                // Add the current post as a reply to the quoted post
                                currentPost.repliesTo.last!.replies.append(currentPost);
                            }
                        }
                    }
                }
            }
            // If there was an error...
            catch {
                // Clear postQuoteRanges, there was a problem
                postQuoteRanges = [];
            }
        }
    }
}