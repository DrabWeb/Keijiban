//
//  KJPostView.swift
//  Keijiban
//
//  Created by Seth on 2016-06-07.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class KJPostView: NSView {
    
    /// The container for KJPostRepliesViewerViews that are created by this post view and it's children
    var repliesViewerViewContainer : NSView? = nil;
    
    /// The image view for displaying the post's possible thumbnail image
    var imageView : KJThumbnailImageView? = nil;
    
    /// The width constraint for imageView
    var imageViewWidthConstraint : NSLayoutConstraint? = nil;
    
    /// The height constraint for imageView
    var imageViewHeightConstraint : NSLayoutConstraint? = nil;
    
    /// The leading constraint for imageView
    var imageViewLeadingConstraint : NSLayoutConstraint? = nil;
    
    /// The text field for showing the poster info
    var posterInfoTextField : NSTextField? = nil;
    
    /// The button for letting the user see how many replies a post has and see the replies when pressed
    var repliesButton : KJColoredTitleButton? = nil;
    
    /// The width constraint for repliesButton
    var repliesButtonWidthConstraint : NSLayoutConstraint? = nil;
    
    /// Called when repliesButton is pressed
    func repliesButtonPressed() {
        let newRepliesViewerView : KJPostRepliesViewerView = KJPostRepliesViewerView();
        
        repliesViewerViewContainer!.addSubview(newRepliesViewerView);
        
        newRepliesViewerView.addOuterConstraints();
        
        newRepliesViewerView.displayRepliesFromPost(representedPost!, darkenBackground: true);
    }
    
    /// The button for letting the user press and reply to this post
    var replyButton : NSButton? = nil;
    
    /// Called when replyButton is pressed
    func replyButtonPressed() {
        
    }
    
    /// The text field for showing the post's possible file's info
    var fileInfoTextField : NSTextField? = nil;

    /// The height constraint for fileInfoTextField
    var fileInfoTextFieldHeightConstraint : NSLayoutConstraint? = nil;
    
    /// The top constraint for fileInfoTextField
    var fileInfoTextFieldTopConstraint : NSLayoutConstraint? = nil;
    
    /// The text field for showing the post's comment
    var commentTextField : NSTextField? = nil;
    
    /// The separator for the bottom of this view
    var bottomSeparator : NSView? = nil;
    
    /// The post this view is displaying
    var representedPost : KJ4CPost? = nil;
    
    /// Should the image be displayed?
    private var displayImage : Bool = true;
    
    /// Displays the given post in this view. If there is an image and displayImage is false, it will not display it
    func displayPost(post : KJ4CPost, displayImage : Bool) {
        // Set representedPost
        representedPost = post;
        
        // Set displayImage
        self.displayImage = displayImage;
        
        // Display the content
        
        // Display the thumbnail image
        // If we said to display the image...
        if(displayImage) {
            // If the post has a file...
            if(post.hasFile) {
                // If the post's thumbnail image is already loaded...
                if(post.thumbnailImage != nil) {
                    // Display the thumbnail image in the thumbnail image view
                    imageView!.image = post.thumbnailImage!;
                }
                // If the post has a thumbnail and it's not loaded...
                else if(post.thumbnailImage == nil) {
                    // Download the image and display it in the thumbnail image view
                    imageView!.downloadImageFromURL(post.fileThumbnailUrl, placeHolderImage: nil, errorImage: nil, usesSpinningWheel: true, downloadCompletionHandler: thumbnailDownloadCompleted);
                }
                
                // Update the file info text field
                fileInfoTextField!.stringValue = post.fileInfo;
            }
        }
        
        // Set the poster info text field's string value
        posterInfoTextField!.attributedStringValue = post.attributedPosterInfo;
        
        // Set the replies button's title
        repliesButton!.title = String(post.replies.count);
        
        // Set the comment text field's string value
        commentTextField!.attributedStringValue = post.attributedComment;
        
        // Update the tooltips
        posterInfoTextField!.toolTip = posterInfoTextField!.stringValue;
        fileInfoTextField!.toolTip = fileInfoTextField!.stringValue;
        
        // Update the constraints
        adjustConstraints();
    }
    
    /// The object to perform thumbnailClickedAction
    var thumbnailClickedTarget : AnyObject? = nil;
    
    /// The selector to call when the user presses the thumbnail image for this post. Passed the pressed KJ4CPost
    var thumbnailClickedAction : Selector = Selector("");
    
    /// Called when the user clicks imageView
    func thumbnailClicked() {
        // Perform the thumbnail clicked action
        thumbnailClickedTarget?.performSelector(thumbnailClickedAction, withObject: self.representedPost!);
    }
    
    /// Creates everything needed for the view and initializes it
    func initializeView() {
        // Create the views
        createViews();
        
        // Theme the views
        themeViews();
        
        // Create the constraints
        createConstraints();
    }
    
    /// Creates the views needed for displaying post info
    func createViews() {
        // Create the image view
        imageView = KJThumbnailImageView();
        
        // Set the scaling
        imageView!.imageScaling = .ScaleProportionallyUpOrDown;
        
        // Set the clicked target and action
        imageView!.clickTarget = self;
        imageView!.clickAction = Selector("thumbnailClicked");
        
        // Create the poster info text field
        posterInfoTextField = NSTextField();
        
        // Create the replies button
        repliesButton = KJColoredTitleButton();
        
        // Set it's tooltip
        repliesButton!.toolTip = "View replies";
        
        // Set it's target and action
        repliesButton!.target = self;
        repliesButton!.action = Selector("repliesButtonPressed");
        
        // Create the reply button
        replyButton = NSButton();
        
        // Set it's tooltip
        replyButton!.toolTip = "Reply to post";
        
        // Set it's target and action
        replyButton!.target = self;
        replyButton!.action = Selector("replyButtonPressed");
        
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
        fileInfoTextField!.lineBreakMode = NSLineBreakMode.ByTruncatingMiddle;
        
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
        // Create the width constraint for the image view
        imageViewWidthConstraint = NSLayoutConstraint(item: imageView!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 100);
        
        // Add the constraint
        imageView!.addConstraint(imageViewWidthConstraint!);
        
        // Create the height constraint for the image view
        imageViewHeightConstraint = NSLayoutConstraint(item: imageView!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 100);
        
        // Add the constraint
        imageView!.addConstraint(imageViewHeightConstraint!);
        
        // Create the leading constraint for the image view
        imageViewLeadingConstraint = NSLayoutConstraint(item: imageView!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 10);
        
        // Add the constraint
        self.addConstraint(imageViewLeadingConstraint!);
        
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
        // Create the constraint for the width of the replies button
        repliesButtonWidthConstraint = NSLayoutConstraint(item: repliesButton!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 42);
        
        // Add the constraint
        repliesButton!.addConstraint(repliesButtonWidthConstraint!);
        
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
        
        // Create the constraint for the top edge of the file info text field
        fileInfoTextFieldTopConstraint = NSLayoutConstraint(item: posterInfoTextField!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: fileInfoTextField, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: -2);
        
        // Add the constraint
        self.addConstraint(fileInfoTextFieldTopConstraint!);
        
        // Create the constraint for the height of the file info text field
        fileInfoTextFieldHeightConstraint = NSLayoutConstraint(item: fileInfoTextField!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 15);
        
        // Add the constraint
        fileInfoTextField!.addConstraint(fileInfoTextFieldHeightConstraint!);
        
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
        let commentTextFieldBottomConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: commentTextField!, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 10);
        
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
    
    /// Updates the constraints to match the content in representedPost(If it isnt nil)
    func adjustConstraints() {
        // If representedPost isnt nil...
        if(representedPost != nil) {
            // Update the constraints
            // If this post has a file...
            if(representedPost!.hasFile) {
                // Update the image view leading constraint
                imageViewLeadingConstraint!.constant = 10;
                
                // Update the file info text field constraints
                fileInfoTextFieldHeightConstraint!.constant = 14;
                
                // Show the image view
                imageView!.hidden = false;
                
                // Show the file info text field
                fileInfoTextField!.hidden = false;
                
                // If the represented post is an OP post...
                if((representedPost! as? KJ4COPPost) != nil) {
                    // Update the image view size
                    imageViewWidthConstraint!.constant = 150;
                    imageViewHeightConstraint!.constant = 150;
                }
                    // If the represented post isnt an OP post...
                else {
                    // Update the image view size
                    imageViewWidthConstraint!.constant = 100;
                    imageViewHeightConstraint!.constant = 100;
                }
            }
            // If this post doesnt have a file...
            else {
                // Update the image view constraints
                imageViewWidthConstraint!.constant = 0;
                imageViewHeightConstraint!.constant = 0;
                imageViewLeadingConstraint!.constant = -2;
                
                // Hide the image view
                imageView!.hidden = true;
                
                // Hide the file info text field
                fileInfoTextField!.hidden = false;
                
                // Update the file info text field constraints
                fileInfoTextFieldHeightConstraint!.constant = 0;
            }
            
            // If this post has at least one reply...
            if(representedPost!.replies.count > 0) {
                // Show the replies button
                repliesButton!.hidden = false;
                
                // Update the replies button constraints
                // Yes I know im cheating with constant values, but content hugging priroities on buttons are wierd
                // Each value has two extra pixels for spacing
                // One character - 32
                // Two characters - 49
                // Three characters - 47
                // Four characters - 55
                
                switch(String(representedPost!.replies.count).characters.count) {
                    case 1:
                        repliesButtonWidthConstraint!.constant = 32;
                        break;
                    case 2:
                        repliesButtonWidthConstraint!.constant = 39;
                        break;
                    case 3:
                        repliesButtonWidthConstraint!.constant = 47;
                        break;
                    case 4:
                        repliesButtonWidthConstraint!.constant = 55;
                        break;
                    default:
                        break;
                }
            }
            // If this post doesnt have any replies...
            else {
                // Hide the replies button
                repliesButton!.hidden = true;
                
                // Update the replies button constraints
                repliesButtonWidthConstraint!.constant = 0;
            }
        }
    }
    
    /// Called when a thumbnail download request from displayPost is finished
    func thumbnailDownloadCompleted(downloadedImage : NSImage?) {
        // Store the download image in the represented post's thumbnailImage variable
        representedPost?.thumbnailImage = downloadedImage;
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect);
        
        // Set the background color
        self.layer?.backgroundColor = KJThemingEngine().defaultEngine().backgroundColor.CGColor;
        
        // Set the separator's color
        bottomSeparator?.layer?.backgroundColor = KJThemingEngine().defaultEngine().postSeparatorColor.CGColor;
    }
    
    /// Was this post view inited from init(As apposed to awakeFromNib)?
    private var initedFromInit : Bool = false;
    
    override func awakeFromNib() {
        super.awakeFromNib();
        
        // If we didnt init from init...
        if(!initedFromInit) {
            // Initialize the view
            initializeView();
        }
    }
    
    // Blank init
    init() {
        super.init(frame: NSRect.zero);
        
        // Set initedFromInit to true
        initedFromInit = true;
        
        // Initialize the view
        initializeView();
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
}
