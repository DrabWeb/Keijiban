//
//  KJ4CPost.swift
//  Keijiban
//
//  Created by Seth on 2016-05-28.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

/// Represents a post on 4chan
class KJ4CPost: NSObject {
    /// The board this post is on
    var board : KJ4CBoard? = nil;
    
    /// The name the poster used for this post
    var name : String = "Anonymous";
    
    /// The trip code the poster used for this post
    var tripcode : String = "";
    
    /// The post number for this post
    var postNumber : Int = -1;
    
    /// The thread this post is in(0 if OP)
    var inThread : Int = -1;
    
    /// The time this post was made(In UNIX epoch time)
    var postTime : Int = -1;
    
    /// Does this post have a file?
    var hasFile : Bool = false;
    
    /// Was this post's file deleted?
    var fileDeleted : Bool = false;
    
    /// Is this post's file spoilered?
    var fileSpoilered : Bool = false;
    
    /// The image of this post(If any)
    var image : NSImage? = nil;
    
    /// The thumbnail image of this post(If any)
    var thumbnailImage : NSImage? = nil;
    
    /// The extension of this post's image(If any)(With a dot in front)
    var imageExtension : String = "";
    
    /// The pixel size of this post's image(If any)
    var imageSize : NSSize = NSSize.zero;
    
    /// The integer part of this post's image file name(If any) on 4cdn
    var imageCdnFilename : Int = -1;
    
    /// The original name of the image file(If any) for this post
    var imageFilename : String = "";
    
    /// Returns the URL to this posts thumbnail URL
    var imageThumbnailUrl : String {
        return "https://i.4cdn.org/\(board!.code)/\(imageCdnFilename)s.jpg"
    }
    
    /// Returns the URL to this posts image URL
    var imageUrl : String {
        return "https://i.4cdn.org/\(board!.code)/\(imageCdnFilename)\(imageExtension)"
    }
    
    /// The text of this post
    var comment : String = "";
    
    /// Returns comment as an attributed string
    var attributedComment : NSAttributedString {
        let attributedString : NSAttributedString = NSAttributedString(string: comment);
        
        var ranges : [NSRange] = [];
        
        do {
            // Create the regular expression.
            let regex = try NSRegularExpression(pattern: "<span class=\"quote\">", options: []);
            
            // Use the regular expression to get an array of NSTextCheckingResult.
            // Use map to extract the range from each result.
            ranges = regex.matchesInString(comment, options: [], range: NSMakeRange(0, comment.characters.count)).map {$0.range}
        }
        catch {
            // There was a problem creating the regular expression
            ranges = [];
        }
        
        return attributedString;
    }
    
    // Override the print output to be useful
    override var description : String {
        if(board != nil) {
            return "<Keijiban.KJ4CPost: /\(board!.code)/thread/\(inThread)#\(postNumber) by \(name)>";
        }
        else {
            return "<Keijiban.KJ4CPost: /nilboard/ #\(postNumber) by \(name)>";
        }
    }
    
    /// Get a KJ4CPost from the given JSON and the given board
    init(json : JSON, board : KJ4CBoard) {
        // Set board to the passed board
        self.board = board;
        
        // Load the values from the JSON
        self.name = json["name"].stringValue;
        
        if(json["trip"].exists()) {
            self.tripcode = json["trip"].stringValue;
        }
        
        self.postNumber = json["no"].intValue;
        
        self.inThread = json["resto"].intValue;
        
        self.postTime = json["time"].intValue;
        
        hasFile = json["filename"].exists();
        
        if(json["filedeleted"].exists()) {
            fileDeleted = Bool(json["filedeleted"].intValue);
        }
        
        if(json["spoiler"].exists()) {
            self.fileSpoilered = Bool(json["spoiler"].intValue);
        }
        
        if(hasFile) {
            self.imageExtension = json["ext"].stringValue;
            self.imageSize = NSSize(width: json["w"].intValue, height: json["h"].intValue);
            self.imageCdnFilename = json["tim"].intValue
            self.imageFilename = json["filename"].stringValue;
        }
        
        self.comment = json["com"].stringValue;
        
        // Format the comment
        self.comment = self.comment.stringByReplacingOccurrencesOfString("<br>", withString: "\n");
        
        // What is the of &#X; called? Maybe there is a way to remove it already made. All I know is what some of them stand for
        self.comment = self.comment.stringByReplacingOccurrencesOfString("&#039;", withString: "'");
        self.comment = self.comment.stringByReplacingOccurrencesOfString("&gt;", withString: ">");
        self.comment = self.comment.stringByReplacingOccurrencesOfString("&quot;", withString: "\"");
    }
}

/// Represents an OP post on 4chan(Like a post but has things like image count, post count, ETC.)
class KJ4COPPost: KJ4CPost {
    /// The subject of this thread
    var subject : String = "";
    
    /// The amount of images this thread has
    var imageCount : Int = -1;
    
    /// The amount of replies this thread has
    var replyCount : Int = -1;
    
    /// Has this thread reached the bump limit?
    var reachedBumpLimit : Bool = false;
    
    /// Has this thread reached the image limit?
    var reachedImageLimit : Bool = false;
    
    /// The recent replies to this post(Used in the index where you see the most recent posts)
    var recentReplies : [KJ4CPost] = [];
    
    /// The string to display in the catalog that shows how many images and replies the thread has
    var imageReplyDisplayString : String = "I: 00 / R: 00";
    
    /// The API URL of this thread
    var threadUrl : String {
        return "https://a.4cdn.org/\(board!.code)/thread/\(postNumber).json";
    }
    
    // Override the print output to be useful
    override var description : String {
        if(board != nil) {
            return "<Keijiban.KJ4COPPost: /\(board!.code)/thread/\(postNumber) by \(name)>";
        }
        else {
            return "<Keijiban.KJ4COPPost: /nilboard/thread/\(postNumber) by \(name)>";
        }
    }
    
    /// Get a KJ4CPost from the given JSON and the given board
    override init(json : JSON, board : KJ4CBoard) {
        super.init(json: json, board: board);
        
        if(json["sub"].exists()) {
            self.subject = json["sub"].stringValue;
        }
        
        self.imageCount = json["images"].intValue;
        self.replyCount = json["replies"].intValue;
        
        imageReplyDisplayString = "I: \(imageCount) / R: \(replyCount)";
        
        self.reachedBumpLimit = Bool(json["bumplimit"].intValue);
        self.reachedImageLimit = Bool(json["imagelimit"].intValue);
        
        for(_, currentReply) in json["last_replies"].enumerate() {
            recentReplies.append(KJ4CPost(json: currentReply.1, board: board));
        }
    }
}