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
    
    /// Returns the poster info for displaying in an attributed string
    var attributedPosterInfo : NSAttributedString {
        /// The string for the poster info
        var posterInfoString : String = "";
        
        /// Add the poster's name to posterInfoString
        posterInfoString += self.name;
        
        // If the poster has a tripcode...
        if(self.tripcode != "") {
            // Add the tripcode the poster info string
            posterInfoString += " \(self.tripcode)";
        }
        
        /// The date this post was made
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(self.postTime));
        
        /// The date formatter for displaying date
        let dateFormatter = NSDateFormatter();
        
        // Set the date formatter's locale and format
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US");
        dateFormatter.dateFormat = "MM/dd/YY(E)HH:mm:ss";
        
        // Add the date to the poster info string
        posterInfoString += " \(dateFormatter.stringFromDate(date))";
        
        // Add the post number to the poster info string
        posterInfoString += " #\(self.postNumber)";
        
        /// This post's poster info as an attributed string
        let attributedPosterInfoString : NSMutableAttributedString = NSMutableAttributedString(string: posterInfoString);
        
        // Make the name bold
        attributedPosterInfoString.addAttribute(NSFontAttributeName, value: NSFont.boldSystemFontOfSize(13), range: NSMakeRange(0, self.name.characters.count));
        
        // Return the attributed poster string
        return attributedPosterInfoString;
    }
    
    /// The text of this post
    var comment : String = "";
    
    /// Returns comment as an attributed string
    var attributedComment : NSAttributedString {
        /// The NSAttributedString for comment
        let attributedComment : NSMutableAttributedString = NSMutableAttributedString(string: comment);
        
        // Color the quotes(Green text)
        
        /// Every range of "<span class="quote">" in comment
        var quoteRanges : [NSRange] = [];
        
        do {
            /// The regex for looking for "<span class="quote">" in comment
            let commentQuoteColorRegex = try NSRegularExpression(pattern: "<span class=\"quote\">", options: []);
            
            // Set quoteRanges to the every range of "<span class="quote">"
            quoteRanges = commentQuoteColorRegex.matchesInString(comment, options: [], range: NSMakeRange(0, comment.characters.count)).map {$0.range}
            
            // For every range in quoteRanges...
            for(_, currentRange) in quoteRanges.enumerate() {
                /// The index for the end of the "<span class="quote">" tag
                let quoteTagStartIndex = comment.startIndex.advancedBy(currentRange.location + currentRange.length);
                
                /// The substring from quoteStartIndex
                let substringFromQuoteBegin : String = comment.substringFromIndex(quoteTagStartIndex);
                
                /// The range of the first </span> in substringFromQuoteBegin
                let quoteEndRange : Range = substringFromQuoteBegin.rangeOfString("</span>")!;
                
                /// The integer index for the beginning of this quote in comment
                let quoteStartIndex : Int = comment.startIndex.distanceTo(quoteTagStartIndex);
                
                /// The integer index for the end of this quote in comment
                let quoteEndIndex : Int = comment.startIndex.distanceTo(quoteTagStartIndex) + comment.startIndex.distanceTo(quoteEndRange.startIndex);
                
                /// The range of this quote in comment
                let quoteRange : NSRange = NSMakeRange(quoteStartIndex, quoteEndIndex - quoteStartIndex);
                
                // Color the quote in attributedComment
                attributedComment.addAttribute(NSForegroundColorAttributeName, value: KJThemingEngine().defaultEngine().quoteColor, range: quoteRange);
            }
            
            // Remove all the tags in the comment that the user shouldnt see
            attributedComment.mutableString.replaceOccurrencesOfString("<span class=\"quote\">", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, attributedComment.mutableString.length));
            attributedComment.mutableString.replaceOccurrencesOfString("</span>", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, attributedComment.mutableString.length));
        }
        // If there was an error...
        catch {
            // Clear quoteRanges, there was a problem
            quoteRanges = [];
        }
        
        // Return attributedComment
        return attributedComment;
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
    var imageReplyDisplayString : String {
        return "I: \(imageCount) / R: \(replyCount)";
    }
    
    /// The API URL of this thread
    var threadUrl : String {
        return "https://a.4cdn.org/\(board!.code)/thread/\(postNumber).json";
    }
    
    /// Returns the poster info for displaying in an attributed string
    override var attributedPosterInfo : NSAttributedString {
        /// The string for the poster info
        var posterInfoString : String = "";
        
        // If there is a subject...
        if(self.subject != "") {
            // Add the subject to the front
            posterInfoString += self.subject + " ";
        }
        
        /// Add the poster's name to posterInfoString
        posterInfoString += self.name;
        
        // If the poster has a tripcode...
        if(self.tripcode != "") {
            // Add the tripcode the poster info string
            posterInfoString += " \(self.tripcode)";
        }
        
        /// The date this post was made
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(self.postTime));
        
        /// The date formatter for displaying date
        let dateFormatter = NSDateFormatter();
        
        // Set the date formatter's locale and format
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US");
        dateFormatter.dateFormat = "MM/dd/YY(E)HH:mm:ss";
        
        // Add the date to the poster info string
        posterInfoString += " \(dateFormatter.stringFromDate(date))";
        
        // Add the post number to the poster info string
        posterInfoString += " #\(self.postNumber)";
        
        /// This post's poster info as an attributed string
        let attributedPosterInfoString : NSMutableAttributedString = NSMutableAttributedString(string: posterInfoString);
        
        // If there is a subject...
        if(self.subject != "") {
            // Make the name and subject bold
            attributedPosterInfoString.addAttribute(NSFontAttributeName, value: NSFont.boldSystemFontOfSize(13), range: NSMakeRange(0, self.subject.characters.count + 1 + self.name.characters.count));
            
            // Color the subject
            attributedPosterInfoString.addAttribute(NSForegroundColorAttributeName, value: KJThemingEngine().defaultEngine().postSubjectColor, range: NSMakeRange(0, self.subject.characters.count));
        }
        // If there isnt a subject...
        else {
            // Make the name bold
            attributedPosterInfoString.addAttribute(NSFontAttributeName, value: NSFont.boldSystemFontOfSize(13), range: NSMakeRange(2, self.name.characters.count));
        }
        
        // Return the attributed poster string
        return attributedPosterInfoString;
    }
    
    /// The attributed string for the image/reply count label
    var attributedImageReplyCountString : NSAttributedString {
        /// The attributed string for the image reply count label
        let attributedImageReplyCountString : NSMutableAttributedString = NSMutableAttributedString(string: imageReplyDisplayString);
        
        // Align the text to the center
        /// The paragraph style for attributedImageReplyCountString
        let attributedImageReplyCountStringParagraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle();
        
        // Set attributedImageReplyCountString to align to the center
        attributedImageReplyCountStringParagraphStyle.alignment = .Center;
        
        // Add attributedImageReplyCountStringParagraphStyle to attributedImageReplyCountString
        attributedImageReplyCountString.addAttribute(NSParagraphStyleAttributeName, value: attributedImageReplyCountStringParagraphStyle, range: NSMakeRange(0, imageReplyDisplayString.characters.count));
        
        // Return the attributed string
        return attributedImageReplyCountString;
    }
    
    /// The attributed string for the comment to display in the catalog view
    var attributedCatalogComment : NSAttributedString {
        /// This post's comment, attributed
        let attributedComment : NSMutableAttributedString = super.attributedComment as! NSMutableAttributedString;
        
        // If there is a subject...
        if(self.subject != "") {
            // Add the subject in front of attributedComment(This is done as a replace because you cant directly set the string of an attributed string)
            attributedComment.mutableString.replaceOccurrencesOfString(attributedComment.string, withString: self.subject + ": " + attributedComment.string, options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, attributedComment.mutableString.length));
            
            // Make the subject bold
            attributedComment.addAttribute(NSFontAttributeName, value: NSFont.boldSystemFontOfSize(13), range: NSMakeRange(0, self.subject.characters.count));
            
            // Make the subject the default text color(Quotes and stuff color it)
            attributedComment.addAttribute(NSForegroundColorAttributeName, value: KJThemingEngine().defaultEngine().textColor, range: NSMakeRange(0, self.subject.characters.count + 2));
        }
        
        // Align the text to the center
        /// The paragraph style for attributedComment
        let attributedCommentParagraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle();
        
        // Set aattrbibutedCommentParagraphStyle to align to the center
        attributedCommentParagraphStyle.alignment = .Center;
        
        // Add attributedCommentParagraphStyle to attributedComment
        attributedComment.addAttribute(NSParagraphStyleAttributeName, value: attributedCommentParagraphStyle, range: NSMakeRange(0, attributedComment.string.characters.count));
        
        // Return attributedComment
        return attributedComment;
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
            
            // Format the subject
            self.subject = self.subject.stringByReplacingOccurrencesOfString("<br>", withString: "\n");
            self.subject = self.subject.stringByReplacingOccurrencesOfString("&#039;", withString: "'");
            self.subject = self.subject.stringByReplacingOccurrencesOfString("&gt;", withString: ">");
            self.subject = self.subject.stringByReplacingOccurrencesOfString("&quot;", withString: "\"");
        }
        
        self.imageCount = json["images"].intValue;
        self.replyCount = json["replies"].intValue;
        
        self.reachedBumpLimit = Bool(json["bumplimit"].intValue);
        self.reachedImageLimit = Bool(json["imagelimit"].intValue);
        
        for(_, currentReply) in json["last_replies"].enumerate() {
            recentReplies.append(KJ4CPost(json: currentReply.1, board: board));
        }
    }
}