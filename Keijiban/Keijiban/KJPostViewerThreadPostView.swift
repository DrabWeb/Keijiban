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
    
    /// The text field that shows the info for the file(Name, pixel size, size)(If there is one)
    @IBOutlet var fileInfoTextField: NSTextField!
    
    /// The text field that shows info about the poster like there name they posted with, the date and time they posted and the post number
    @IBOutlet var posterInfoTextField: NSTextField!
    
    /// The constraint for the left side of posterInfoTextField
    @IBOutlet var posterInfoTextFieldLeftConstraint: NSLayoutConstraint!
    
    /// The text field for the post's comment
    @IBOutlet var commentTextField: NSTextField!
    
    /// The constraint for the top of commentTextField
    @IBOutlet var commentTextFieldTopConstraint: NSLayoutConstraint!
    
    /// The constraint for the left side of commentTextField
    @IBOutlet var commentTextFieldLeftConstraint: NSLayoutConstraint!
    
    /// The NSBox for the separator on the bottom of the cell
    @IBOutlet var bottomSeparator: NSBox!
    
    /// The post this cell rerpesents
    var representedPost : KJ4CPost? = nil;
    
    /// Displays the info from the given post in this view. If displayImage is false it wont load or display the image for this cell
    func displayInfoFromPost(post : KJ4CPost, displayImage : Bool) {
        // Set representedPost
        representedPost = post;
        
        // Display the info
        
        // Display the thumbnail image
        // If this is an OP post...
        if((post as? KJ4COPPost) != nil) {
            // Set the thumbnail image's width and height constraints to 150, so the user can easily see it's the OP post
            thumbnailImageView.constraints[0].constant = 150;
            thumbnailImageView.constraints[1].constant = 150;
            
            // Update the comment and poster info left margins
            commentTextFieldLeftConstraint.constant = 170;
            posterInfoTextFieldLeftConstraint.constant = 170;
        }
        
        // If we said to display the thumbnail image...
        if(displayImage) {
            // If the post has a file...
            if(post.hasFile) {
                // If the post's thumbnail image is already loaded...
                if(post.thumbnailImage != nil) {
                    // Display the thumbnail image in the thumbnail image view
                    thumbnailImageView.image = post.thumbnailImage!;
                }
                // If the post has a thumbnail and it's not loaded...
                else if(post.thumbnailImage == nil) {
                    // Download the image and display it in the thumbnail image view
                    thumbnailImageView.image = NSImage(contentsOfURL: NSURL(string: post.imageThumbnailUrl)!);
                }
                
                // Update the file info text field
                fileInfoTextField.stringValue = post.fileInfo;
            }
            // If the post doesnt have a file...
            else {
                // Hide the thumbnail image view
                thumbnailImageView.hidden = true;
                
                // Hide the file info text field
                fileInfoTextField.hidden = true;
                
                // Update the constraints
                // Update the thumbnail image view's constant height
                thumbnailImageView.constraints[0].constant = 0;
                
                // Update the poster info and comment text field constraints
                posterInfoTextFieldLeftConstraint.constant = 10;
                
                commentTextFieldTopConstraint.constant = 3;
                commentTextFieldLeftConstraint.constant = 10;
            }
        }
        // If we said not to display the thumbnail image...
        else {
            // Hide the thumbnail image view
            thumbnailImageView.hidden = true;
            
            // Hide the file info text field
            fileInfoTextField.hidden = true;
            
            // Update the constraints
            // Update the thumbnail image view's constant height
            thumbnailImageView.constraints[0].constant = 0;
            
            // Update the poster info and comment text field constraints
            posterInfoTextFieldLeftConstraint.constant = 10;
            
            commentTextFieldTopConstraint.constant = 3;
            commentTextFieldLeftConstraint.constant = 10;
        }
        
        // Display the poster info in the poster info text field
        posterInfoTextField.attributedStringValue = post.attributedPosterInfo;
        
        // Display the comment in the comment text field
        commentTextField.attributedStringValue = post.attributedComment;
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect);
        
        // Thme everything
        self.layer?.backgroundColor = KJThemingEngine().defaultEngine().backgroundColor.CGColor;
        self.fileInfoTextField.textColor = KJThemingEngine().defaultEngine().fileInfoTextColor;
        self.commentTextField.textColor = KJThemingEngine().defaultEngine().textColor;
        self.posterInfoTextField.textColor = KJThemingEngine().defaultEngine().textColor;
        self.bottomSeparator.layer?.backgroundColor = KJThemingEngine().defaultEngine().postSeparatorColor.CGColor;
    }
}
