//
//  KJPostViewerThreadPostView.swift
//  Keijiban
//
//  Created by Seth on 2016-05-29.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class KJPostViewerThreadPostView: NSView {

    /// The image view for the post's thumbnail image
    @IBOutlet var thumbnailImageView: KJRasterizedImageView!
    
    /// The text field that shows info about the poster like there name they posted with, the date and time they posted and the post number
    @IBOutlet var posterInfoTextField: NSTextField!
    
    /// The constraint for the left side of posterInfoTextField
    @IBOutlet var posterInfoTextFieldLeftConstraint: NSLayoutConstraint!
    
    /// The text field for the post's comment
    @IBOutlet var commentTextField: NSTextField!
    
    /// The constraint for the left side of commentTextField
    @IBOutlet var commentTextFieldLeftConstraint: NSLayoutConstraint!
    
    /// The NSBox for the separator on the bottom of the cell
    @IBOutlet var bottomSeparator: NSBox!
    
    /// The post this cell rerpesents
    var representedPost : KJ4CPost? = nil;
    
    /// Displays the info from the given post in this view
    func displayInfoFromPost(post : KJ4CPost) {
        // Set representedPost
        representedPost = post;
        
        // Display the info
        /// The string to display in the poster info text field
        var posterInfoString : String = "";
        
        // Display the thumbnail image
        // If this is an OP post...
        if((post as? KJ4COPPost) != nil) {
            // Set the thumbnail image's width and height constraints to 150, so the user can easily see it's the OP post
            thumbnailImageView.constraints[0].constant = 150;
            thumbnailImageView.constraints[1].constant = 150;
            
            // Update the comment and poster info left margins
            commentTextFieldLeftConstraint.constant = 170;
            posterInfoTextFieldLeftConstraint.constant = 170;
            
            // If the post's subject isnt blank...
            if((post as! KJ4COPPost).subject != "") {
                // Add the subject to posterInfoString
                posterInfoString += (post as! KJ4COPPost).subject + " - ";
            }
        }
        
        // If the post's thumbnail image is already loaded...
        if(post.thumbnailImage != nil) {
            // Display the thumbnail image in the thumbnail image view
            thumbnailImageView.image = post.thumbnailImage!;
        }
            // If the post has a thumbnail and it's not loaded...
        else if(post.hasFile && post.thumbnailImage == nil) {
            // Download the image and display it in the thumbnail image view
            thumbnailImageView.image = NSImage(contentsOfURL: NSURL(string: post.imageThumbnailUrl)!);
        }
        // If the post doesnt have a thumbnail image...
        else {
            // Hide the thumbnail image view
            thumbnailImageView.hidden = true;
            
            // Update the constraints
            // Update the thumbnail image view's constant height
            thumbnailImageView.constraints[0].constant = 0;
            
            // Update the comment and poster info text field left margins
            commentTextFieldLeftConstraint.constant = 10;
            posterInfoTextFieldLeftConstraint.constant = 10;
        }
        
        /// Add the poster's name to posterInfoString
        posterInfoString += post.name;
        
        // If the poster has a tripcode...
        if(post.tripcode != "") {
            // Add the tripcode the poster info string
            posterInfoString += " \(post.tripcode)";
        }
        
        /// The date this post was made
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(post.postTime));
        
        /// The date formatter for displaying date
        let dateFormatter = NSDateFormatter();
        
        // Set the date formatter's locale and format
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US");
        dateFormatter.dateFormat = "MM/dd/YY(E)HH:mm:ss";
        
        // Add the date to the poster info string
        posterInfoString += " \(dateFormatter.stringFromDate(date))";
        
        // Add the post number to the poster info string
        posterInfoString += " #\(post.postNumber)";
        
        // Display the poster info string in the poster info text field
        posterInfoTextField.stringValue = posterInfoString;
        
        // Display the comment in the comment text field
        commentTextField.attributedStringValue = post.attributedComment;
    }
}
