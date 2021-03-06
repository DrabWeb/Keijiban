//
//  KJ4CPost.swift
//  Keijiban
//
//  Created by Seth on 2016-05-28.
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
    
    /// The replies to this post
    var replies : [KJ4CPost] = [];
    
    /// The posts this post replies to
    var repliesTo : [KJ4CPost] = [];
    
    /// Does this post have a file?
    var hasFile : Bool = false;
    
    /// Was this post's file deleted?
    var fileDeleted : Bool = false;
    
    /// Is this post's file spoilered?
    var fileSpoilered : Bool = false;
    
    /// The thumbnail image of this post(If any)
    var thumbnailImage : NSImage? = nil;
    
    /// The data of this post's file(If any)
    var fileData : NSData? = nil;
    
    /// The extension of this post's file(If any)(With a dot in front)
    var fileExtension : String = "";
    
    /// The pixel size of this post's file(If any)
    var filePixelSize : NSSize = NSSize.zero;
    
    /// The size of this post's file in bytes(If any)
    var fileSize : Int = -1;
    
    /// The integer part of this post's file's name(If any) on 4cdn
    var fileCdnFilename : Int = -1;
    
    /// The original name of the file(If any) for this post
    var fileFilename : String = "";
    
    /// Returns the URL to this posts thumbnail
    var fileThumbnailUrl : String {
        return "https://i.4cdn.org/\(board!.code)/\(fileCdnFilename)s.jpg"
    }
    
    /// Returns the URL to this posts file
    var fileUrl : String {
        return "https://i.4cdn.org/\(board!.code)/\(fileCdnFilename)\(fileExtension)"
    }
    
    /// Returns the file info of this post in a label, with the format "filename.extension (file size, pixel size)"
    var fileInfo : String {
        /// The file info to return
        var fileInfoString : String = fileFilename + fileExtension + " (";
        
        // Add the file size
        fileInfoString += "\(NSByteCountFormatter().stringFromByteCount(Int64(self.fileSize))), ";
        
        // Add the pixel size
        fileInfoString += "\(Int(filePixelSize.width))x\(Int(filePixelSize.height))";
        
        // Add the closing parenthesis
        fileInfoString += ")";
        
        // Return the file info string
        return fileInfoString;
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
    
    /// The comment without any of the spans or HREFs, but not attributed
    var cleanedComment : String {
        // Return attributedComment, without the attributes
        return attributedComment.string;
    }
    
    /// Returns comment as an attributed string
    var attributedComment : NSAttributedString {
        /// The NSAttributedString for comment
        let attributedComment : NSMutableAttributedString = NSMutableAttributedString(string: comment);
        
        // Set the text color
        attributedComment.addAttribute(NSForegroundColorAttributeName, value: KJThemingEngine().defaultEngine().commentTextColor, range: NSMakeRange(0, attributedComment.string.characters.count));
        
        // Color the quotes
        
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
        }
        // If there was an error...
        catch {
            // Clear quoteRanges, there was a problem
            quoteRanges = [];
        }
        
        /// Color the post quotes
        
        /// Every range of "<a href="#p*" class="quotelink">" in comment
        var postQuoteRanges : [NSRange] = [];
        
        /// All the tags for the post quotes that should be removed from the comment
        var postQuoteTags : [String] = [];
        
        do {
            /// The regex for looking for "<a href="#p*" class="quotelink">" in comment
            let postQuoteColorRegex = try NSRegularExpression(pattern: "<a href=\"#p.*\" class=\"quotelink\">", options: []);
            
            // Set quoteRanges to the every range of "<span class="quote">"
            postQuoteRanges = postQuoteColorRegex.matchesInString(comment, options: [], range: NSMakeRange(0, comment.characters.count)).map {$0.range}
            
            // For every range in postQuoteRanges...
            for(_, currentRange) in postQuoteRanges.enumerate() {
                // Color the post quote
                /// Add the beginning post quote tag for this post to postQuoteTags
                postQuoteTags.append(comment.substringWithRange(Range<String.Index>(start: comment.startIndex.advancedBy(currentRange.location), end: comment.startIndex.advancedBy(currentRange.location + currentRange.length))));
                
                /// The index for the end of the "<a href="#p*" class="quotelink">" tag
                let postQuoteTagStartIndex = comment.startIndex.advancedBy(currentRange.location + currentRange.length);
                
                /// The substring from postQuoteTagStartIndex
                let substringFromPostQuoteBegin : String = comment.substringFromIndex(postQuoteTagStartIndex);
                
                /// The range of the first </a> in substringFromPostQuoteBegin
                let postQuoteEndRange : Range = substringFromPostQuoteBegin.rangeOfString("</a>")!;
                
                /// The integer index for the beginning of this post quote in comment
                let postQuoteStartIndex : Int = comment.startIndex.distanceTo(postQuoteTagStartIndex);
                
                /// The integer index for the end of this post quote in comment
                let postQuoteEndIndex : Int = comment.startIndex.distanceTo(postQuoteTagStartIndex) + comment.startIndex.distanceTo(postQuoteEndRange.startIndex);
                
                /// The range of this post quote in comment
                let postQuoteRange : NSRange = NSMakeRange(postQuoteStartIndex, postQuoteEndIndex - postQuoteStartIndex);
                
                // Color the post quote in attributedComment
                attributedComment.addAttribute(NSForegroundColorAttributeName, value: KJThemingEngine().defaultEngine().postQuoteColor, range: postQuoteRange);
                
                // Add the link to the post quote
                attributedComment.addAttribute(NSLinkAttributeName, value: postQuoteTags.last!.hrefContent()!, range: postQuoteRange);
            }
        }
        // If there was an error...
        catch {
            // Clear postQuoteRanges, there was a problem
            postQuoteRanges = [];
        }
        
        /// Every range of "<span class="deadlink">" in comment
        var postQuoteDeadRanges : [NSRange] = [];
        
        do {
            /// The regex for looking for "<span class="deadlink">" in comment
            let postQuoteDeadColorRegex = try NSRegularExpression(pattern: "<span class=\"deadlink\">", options: []);
            
            // Set postQuoteDeadRanges to the every range of "<span class="deadlink">"
            postQuoteDeadRanges = postQuoteDeadColorRegex.matchesInString(comment, options: [], range: NSMakeRange(0, comment.characters.count)).map {$0.range}
            
            // For every range in postQuoteRanges...
            for(_, currentRange) in postQuoteDeadRanges.enumerate() {
                /// The index for the end of the "<span class="deadlink">"
                let postQuoteDeadTagStartIndex = comment.startIndex.advancedBy(currentRange.location + currentRange.length);
                
                /// The substring from postQuoteDeadTagStartIndex
                let substringFromPostQuoteDeadBegin : String = comment.substringFromIndex(postQuoteDeadTagStartIndex);
                
                /// The range of the first </span> in substringFromPostQuoteDeadBegin
                let postQuoteDeadEndRange : Range = substringFromPostQuoteDeadBegin.rangeOfString("</span>")!;
                
                /// The integer index for the beginning of this dead post quote in comment
                let postQuoteDeadStartIndex : Int = comment.startIndex.distanceTo(postQuoteDeadTagStartIndex);
                
                /// The integer index for the end of this dead post quote in comment
                let postQuoteDeadEndIndex : Int = comment.startIndex.distanceTo(postQuoteDeadTagStartIndex) + comment.startIndex.distanceTo(postQuoteDeadEndRange.startIndex);
                
                /// The range of this dead post quote in comment
                let postQuoteDeadRange : NSRange = NSMakeRange(postQuoteDeadStartIndex, postQuoteDeadEndIndex - postQuoteDeadStartIndex);
                
                // Color the dead post quote in attributedComment
                attributedComment.addAttribute(NSForegroundColorAttributeName, value: KJThemingEngine().defaultEngine().deadPostQuoteColor, range: postQuoteDeadRange);
                
                // Put a strike through the dead post quote in attributedComment
                attributedComment.addAttribute(NSStrikethroughStyleAttributeName, value: NSNumber(integer: NSUnderlineStyle.StyleSingle.rawValue), range: postQuoteDeadRange);
            }
        }
        // If there was an error...
        catch {
            // Clear postQuoteDeadRanges, there was a problem
            postQuoteDeadRanges = [];
        }
        
        // Remove all the tags in the comment that the user shouldnt see
        for(_, currentPostQuoteTag) in postQuoteTags.enumerate() {
            attributedComment.mutableString.replaceOccurrencesOfString(currentPostQuoteTag, withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, attributedComment.mutableString.length));
        }
        
        attributedComment.mutableString.replaceOccurrencesOfString("<span class=\"quote\">", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, attributedComment.mutableString.length));
        attributedComment.mutableString.replaceOccurrencesOfString("</span>", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, attributedComment.mutableString.length));
        attributedComment.mutableString.replaceOccurrencesOfString("<span class=\"deadlink\">", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, attributedComment.mutableString.length));
        attributedComment.mutableString.replaceOccurrencesOfString("</a>", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, attributedComment.mutableString.length));
        
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
            self.fileExtension = json["ext"].stringValue;
            self.fileSize = json["fsize"].intValue;
            self.filePixelSize = NSSize(width: json["w"].intValue, height: json["h"].intValue);
            self.fileCdnFilename = json["tim"].intValue
            self.fileFilename = json["filename"].stringValue.cleanedString;
        }
        
        self.comment = json["com"].stringValue;
        
        // Clean the comment
        self.comment = self.comment.cleanedString;
        
        // Clean the name
        self.name = self.name.cleanedString;
        
        // Update the comment to tag if a post is quoting OP
        self.comment = self.comment.stringByReplacingOccurrencesOfString(">>\(String(inThread))", withString: ">>\(inThread)(OP)");
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
            attributedPosterInfoString.addAttribute(NSFontAttributeName, value: NSFont.boldSystemFontOfSize(13), range: NSMakeRange(0, self.name.characters.count));
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
            
            // If the attributed comment's string length is greater than 0(For some reason its zero sometimes and crashes the app)...
            if(self.attributedComment.string.characters.count > 0) {
                // Make the subject bold
                attributedComment.addAttribute(NSFontAttributeName, value: NSFont.boldSystemFontOfSize(13), range: NSMakeRange(0, self.subject.characters.count));
                
                // Make the subject the default text color(Quotes and stuff color it)
                attributedComment.addAttribute(NSForegroundColorAttributeName, value: KJThemingEngine().defaultEngine().commentTextColor, range: NSMakeRange(0, self.subject.characters.count + 2));
            }
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
            
            // Clean the subject
            self.subject = self.subject.cleanedString;
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