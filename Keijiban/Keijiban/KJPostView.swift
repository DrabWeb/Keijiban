//
//  KJPostView.swift
//  Keijiban
//
//  Created by Seth on 2016-06-07.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class KJPostView: NSView {
    
    /// The image view for displaying the post's possible image
    var imageView : NSImageView? = nil;
    
    /// The text field for showing the poster info
    var posterInfoTextField : NSTextField? = nil;
    
    /// The button for letting the user see how many replies a post has and see the replies when pressed
    var repliesButton : KJColoredTitleButton? = nil;
    
    /// The button for letting the user press and reply to this post
    var replyButton : NSButton? = nil;
    
    /// The text field for showing the post's possible file's info
    var fileInfoTextField : NSTextField? = nil;
    
    /// The text field for showing the post's comment
    var commentTextField : NSTextField? = nil;
    
    /// The separator for the bottom of this view
    var bottomSeparator : NSView? = nil;
    
    /// Creates everything needed for the view and initializes it
    func initializeView() {
        // Create the views
        createViews();
        
        // Load in some sample content
        imageView!.image = NSImage(named: "NSCaution");
        posterInfoTextField!.stringValue = "Anonymous 00/00/00(DDD)00:00:00 #000000000";
        repliesButton!.title = "00";
        fileInfoTextField!.stringValue = "filename.extension (file size, pixel dimensions)";
        commentTextField!.stringValue = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec in porta augue. Nunc et blandit ante, ut vehicula odio. Quisque at lacinia dolor, eget iaculis dui. Vivamus suscipit ex et diam lacinia, sit amet laoreet dui scelerisque. Proin sed ex feugiat, vulputate arcu non, lacinia magna. Sed vulputate condimentum euismod. Sed at ultricies lorem. Mauris venenatis nisi non lacinia sollicitudin. Cras ullamcorper dapibus laoreet.";
        
        // Theme the views
        themeViews();
        
        // Create the constraints
        createConstraints();
    }
    
    /// Creates the views needed for displaying post info
    func createViews() {
        // Create the image view
        imageView = NSImageView();
        
        // Set the scaling
        imageView!.imageScaling = .ScaleProportionallyUpOrDown;
        
        // Create the poster info text field
        posterInfoTextField = NSTextField();
        
        // Create the replies button
        repliesButton = KJColoredTitleButton();
        
        // Create the reply button
        replyButton = NSButton();
        
        // Create the file info text field
        fileInfoTextField = NSTextField();
        
        // Create the comment text field
        commentTextField = NSTextField();
        
        // Create the bottom separator
        bottomSeparator = NSView();
        
        // Move everything into this view
        self.addSubview(imageView!);
        self.addSubview(posterInfoTextField!);
        self.addSubview(repliesButton!);
        self.addSubview(replyButton!);
        self.addSubview(fileInfoTextField!);
        self.addSubview(commentTextField!);
        self.addSubview(bottomSeparator!);
    }
    
    /// Themes all the views
    func themeViews() {
        // Set the appearance to aqua so nothing is vibrant
        self.appearance = NSAppearance(named: NSAppearanceNameAqua);
        
        // Theme the poster info text field
        posterInfoTextField!.bordered = false;
        posterInfoTextField!.selectable = false;
        posterInfoTextField!.editable = false;
        posterInfoTextField!.backgroundColor = NSColor.clearColor();
        posterInfoTextField!.textColor = KJThemingEngine().defaultEngine().posterInfoTextColor;
        posterInfoTextField!.font = NSFont.systemFontOfSize(13);
        posterInfoTextField!.lineBreakMode = NSLineBreakMode.ByTruncatingTail;
        
        // Theme the replies button
        repliesButton!.bordered = false;
        repliesButton!.state = 0;
        repliesButton!.font = NSFont.systemFontOfSize(13);
        (repliesButton!.cell as! NSButtonCell).alignment = .Left;
        (repliesButton!.cell as! NSButtonCell).setButtonType(NSButtonType.MomentaryPushInButton);
        (repliesButton!.cell as! NSButtonCell).imageScaling = NSImageScaling.ScaleProportionallyUpOrDown;
        (repliesButton!.cell as! NSButtonCell).imagePosition = NSCellImagePosition.ImageLeft;
        repliesButton!.image = NSImage(named: "KJRepliesIcon")!.withColorOverlay(KJThemingEngine().defaultEngine().repliesButtonColor);
        repliesButton!.titleColor = KJThemingEngine().defaultEngine().repliesButtonColor;
        
        // Theme the reply button
        replyButton!.bordered = false;
        (replyButton!.cell as! NSButtonCell).setButtonType(NSButtonType.MomentaryPushInButton);
        (replyButton!.cell as! NSButtonCell).imageScaling = NSImageScaling.ScaleProportionallyUpOrDown;
        replyButton!.image = NSImage(named: "KJReplyIcon");
        replyButton!.image = replyButton!.image!.withColorOverlay(KJThemingEngine().defaultEngine().replyButtonColor);
        
        // Theme the file info text field
        fileInfoTextField!.bordered = false;
        fileInfoTextField!.selectable = false;
        fileInfoTextField!.editable = false;
        fileInfoTextField!.backgroundColor = NSColor.clearColor();
        fileInfoTextField!.textColor = KJThemingEngine().defaultEngine().fileInfoTextColor;
        fileInfoTextField!.font = NSFont.systemFontOfSize(11);
        fileInfoTextField!.lineBreakMode = NSLineBreakMode.ByTruncatingTail;
        
        // Theme the comment text field
        commentTextField!.bordered = false;
        commentTextField!.selectable = false;
        commentTextField!.editable = false;
        commentTextField!.backgroundColor = NSColor.clearColor();
        commentTextField!.textColor = KJThemingEngine().defaultEngine().commentTextColor;
        commentTextField!.font = NSFont.systemFontOfSize(13);
        commentTextField!.lineBreakMode = NSLineBreakMode.ByWordWrapping;
    }
    
    /// Creates the constraints for the view
    func createConstraints() {
        // Disable all the autoresizing mask to constraint translation
        self.translatesAutoresizingMaskIntoConstraints = false;
        imageView!.translatesAutoresizingMaskIntoConstraints = false;
        posterInfoTextField!.translatesAutoresizingMaskIntoConstraints = false;
        repliesButton!.translatesAutoresizingMaskIntoConstraints = false;
        replyButton!.translatesAutoresizingMaskIntoConstraints = false;
        fileInfoTextField!.translatesAutoresizingMaskIntoConstraints = false;
        commentTextField!.translatesAutoresizingMaskIntoConstraints = false;
        bottomSeparator!.translatesAutoresizingMaskIntoConstraints = false;
        
        // Add the constraints to the image view
        /// The constraint for the width of the image view
        let imageViewWidthConstraint = NSLayoutConstraint(item: imageView!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 100);
        
        // Add the constraint
        imageView!.addConstraint(imageViewWidthConstraint);
        
        /// The constraint for the height of the image view
        let imageViewHeightConstraint = NSLayoutConstraint(item: imageView!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 100);
        
        // Add the constraint
        imageView!.addConstraint(imageViewHeightConstraint);
        
        /// The constraint for the leading edge of the image view
        let imageViewLeadingConstraint = NSLayoutConstraint(item: imageView!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 10);
        
        // Add the constraint
        self.addConstraint(imageViewLeadingConstraint);
        
        /// The constraint for the Y centering of the image view
        let imageViewCenterYConstraint = NSLayoutConstraint(item: imageView!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY
            , multiplier: 1, constant: 0);
        
        // Add the constraint
        self.addConstraint(imageViewCenterYConstraint);
        
        /// The constraint for the bottom edge of the image view
        let imageViewBottomConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: imageView!, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 10);
        
        // Add the constraint
        self.addConstraint(imageViewBottomConstraint);
        
        // Add the constraints to the poster info text field
        /// The constraint for the leading edge of the poster info text field
        let posterInfoTextFieldLeadingConstraint = NSLayoutConstraint(item: posterInfoTextField!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: imageView!, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 10);
        
        // Add the constraint
        self.addConstraint(posterInfoTextFieldLeadingConstraint);
        
        /// The constraint for the trailing edge of the poster info text field
        let posterInfoTextFieldTrailingConstraint = NSLayoutConstraint(item: repliesButton!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: posterInfoTextField!, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 5);
        
        // Add the constraint
        self.addConstraint(posterInfoTextFieldTrailingConstraint);
        
        /// The constraint for the top edge of the poster info text field
        let posterInfoTextFieldTopConstraint = NSLayoutConstraint(item: posterInfoTextField!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 5);
        
        // Add the constraint
        self.addConstraint(posterInfoTextFieldTopConstraint);
        
        /// The constraint for the height of the poster info text field
        let posterInfoTextFieldHeightConstraint = NSLayoutConstraint(item: posterInfoTextField!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 17);
        
        // Add the constraint
        posterInfoTextField!.addConstraint(posterInfoTextFieldHeightConstraint);
        
        // Set the content compression priorities
        posterInfoTextField!.setContentCompressionResistancePriority(250, forOrientation: .Horizontal);
        posterInfoTextField!.setContentCompressionResistancePriority(250, forOrientation: .Vertical);
        
        // Add the constraints to the repliess button
        /// The constraint for the width of the replies button
        let repliesButtonWidthConstraint = NSLayoutConstraint(item: repliesButton!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 42);
        
        // Add the constraint
        repliesButton!.addConstraint(repliesButtonWidthConstraint);
        
        /// The constraint for the height of the replies button
        let repliesButtonHeightConstraint = NSLayoutConstraint(item: repliesButton!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 17);
        
        // Add the constraint
        repliesButton!.addConstraint(repliesButtonHeightConstraint);
        
        /// The constraint for the trailing edge of the replies button
        let repliesButtonTrailingConstraint = NSLayoutConstraint(item: replyButton!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: repliesButton!, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0);
        
        // Add the constraint
        self.addConstraint(repliesButtonTrailingConstraint);
        
        /// The constraint for the top edge of the replies button
        let repliesButtonTopConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: repliesButton!, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: -5);
        
        // Add the constraint
        self.addConstraint(repliesButtonTopConstraint);
        
        // Add the constraints to the reply button
        /// The constraint for the width of the reply button
        let replyButtonWidthConstraint = NSLayoutConstraint(item: replyButton!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 17);
        
        // Add the constraint
        replyButton!.addConstraint(replyButtonWidthConstraint);
        
        /// The constraint for the height of the reply button
        let replyButtonHeightConstraint = NSLayoutConstraint(item: replyButton!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 17);
        
        // Add the constraint
        replyButton!.addConstraint(replyButtonHeightConstraint);
        
        /// The constraint for the trailing edge of the reply button
        let replyButtonTrailingConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: replyButton!, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 5);
        
        // Add the constraint
        self.addConstraint(replyButtonTrailingConstraint);
        
        /// The constraint for the top edge of the reply button
        let replyButtonTopConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: replyButton!, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: -5);
        
        // Add the constraint
        self.addConstraint(replyButtonTopConstraint);
        
        // Add the constraints to the file info text field
        /// The constraint for the leading edge of the file info text field
        let fileInfoTextFieldLeadingConstraint = NSLayoutConstraint(item: fileInfoTextField!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: imageView!, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 10);
        
        // Add the constraint
        self.addConstraint(fileInfoTextFieldLeadingConstraint);
        
        /// The constraint for the trailing edge of the file info text field
        let fileInfoTextFieldTrailingConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: fileInfoTextField!, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 5);
        
        // Add the constraint
        self.addConstraint(fileInfoTextFieldTrailingConstraint);
        
        /// The constraint for the top edge of the file info text field
        let fileInfoTextFieldTopConstraint = NSLayoutConstraint(item: posterInfoTextField!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: fileInfoTextField, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: -2);
        
        // Add the constraint
        self.addConstraint(fileInfoTextFieldTopConstraint);
        
        /// The constraint for the height of the file info text field
        let fileInfoTextFieldHeightConstraint = NSLayoutConstraint(item: fileInfoTextField!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 15);
        
        // Add the constraint
        fileInfoTextField!.addConstraint(fileInfoTextFieldHeightConstraint);
        
        // Set the content compression priorities
        fileInfoTextField!.setContentCompressionResistancePriority(250, forOrientation: .Horizontal);
        fileInfoTextField!.setContentCompressionResistancePriority(250, forOrientation: .Vertical);
        
        // Add the constraints to the comment text field
        /// The constraint for the leading edge of the comment text field
        let commentTextFieldLeadingConstraint = NSLayoutConstraint(item: commentTextField!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: imageView!, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 10);
        
        // Add the constraint
        self.addConstraint(commentTextFieldLeadingConstraint);
        
        /// The constraint for the trailing edge of the comment text field
        let commentTextFieldTrailingConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: commentTextField!, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 5);
        
        // Add the constraint
        self.addConstraint(commentTextFieldTrailingConstraint);
        
        /// The constraint for the top edge of the comment text field
        let commentTextFieldTopConstraint = NSLayoutConstraint(item: fileInfoTextField!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: commentTextField!, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0);
        
        // Add the constraint
        self.addConstraint(commentTextFieldTopConstraint);
        
        /// The constraint for the bottom edge of the comment text field
        let commentTextFieldBottomConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: commentTextField!, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 12);
        
        // Add the constraint
        self.addConstraint(commentTextFieldBottomConstraint);
        
        // Set the content compression and hugging priorities
        commentTextField!.setContentCompressionResistancePriority(250, forOrientation: .Horizontal);
        commentTextField!.setContentCompressionResistancePriority(1000, forOrientation: .Vertical);
        commentTextField!.setContentHuggingPriority(250, forOrientation: .Horizontal);
        commentTextField!.setContentHuggingPriority(1000, forOrientation: .Vertical);
        
        // Add the constraints to the bottom separator
        /// The constraint for the leading edge of the bottom separator
        let bottomSeparatorLeadingConstraint = NSLayoutConstraint(item: bottomSeparator!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0);
        
        // Add the constraint
        self.addConstraint(bottomSeparatorLeadingConstraint);
        
        /// The constraint for the trailing edge of the bottom separator
        let bottomSeparatorTrailingConstraint = NSLayoutConstraint(item: bottomSeparator!, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0);
        
        // Add the constraint
        self.addConstraint(bottomSeparatorTrailingConstraint);
        
        /// The constraint for the bottom edge of the bottom separator
        let bottomSeparatorBottomConstraint = NSLayoutConstraint(item: bottomSeparator!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0);
        
        // Add the constraint
        self.addConstraint(bottomSeparatorBottomConstraint);
        
        /// The constraint for the height of the bottom separator
        let bottomSeparatorHeightConstraint = NSLayoutConstraint(item: bottomSeparator!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 1);
        
        // Add the constraint
        bottomSeparator!.addConstraint(bottomSeparatorHeightConstraint);
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect);
        
        // Set the background color
        self.layer?.backgroundColor = KJThemingEngine().defaultEngine().backgroundColor.CGColor;
        
        // Set the separator's color
        bottomSeparator?.layer?.backgroundColor = KJThemingEngine().defaultEngine().postSeparatorColor.CGColor;
    }
    
    override func awakeFromNib() {
        super.awakeFromNib();
        
        // Initialize the view
        initializeView();
    }
}
