//
//  KJPostsImageViewer.swift
//  Keijiban
//
//  Created by Seth on 2016-06-07.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class KJPostsImageViewer: NSView {
    
    /// The file view for displaying the full size image
    var postFileViewer : KJFileView? = nil;
    
    /// The view at the top of the image viewer that holds the download button, next/previous buttons and the file info label
    var toolbar : KJColoredView? = nil;
    
    /// The bottom constraint for toolbar
    var toolbarBottomConstraint : NSLayoutConstraint? = nil;
    
    /// The button in the toolbar that lets the user see a grid with all the images in the posts
    var galleryButton : NSButton? = nil;
    
    /// Called when the user presses galleryButton
    func galleryButtonPressed() {
        
    }
    
    /// The text field in the toolbar that shows the current file's info(Name, size and file size)
    var fileInfoTextField : NSTextField? = nil;
    
    /// The button in the toolbar for dowloading the current image(Instead of using the keybind)
    var downloadButton : NSButton? = nil;
    
    /// Called when the user presses downloadButton
    func downloadButtonPressed() {
        
    }
    
    /// The button in the toolbar for going to the next image(Instead of using the keybind)
    var nextButton : NSButton? = nil;
    
    /// Called when the user presses nextButton
    func nextButtonPressed() {
        
    }
    
    /// The button in the toolbar for going to the previous image(Instead of using the keybind)
    var previousButton : NSButton? = nil;
    
    /// Called when the user presses previousButton
    func previousButtonPressed() {
        
    }
    
    /// The post that this image browser is currently displaying
    var currentBrowsingPosts : [KJ4CPost] = [];
    
    /// Shows this image browser with the images of the given posts
    func showImagesForPosts(posts : [KJ4CPost]) {
        // Clear currentBrowsingPosts
        currentBrowsingPosts.removeAll();
        
        // Set currentBrowsingPosts
        // For every post in posts...
        for(_, currentPost) in posts.enumerate() {
            // If the current post has a file...
            if(currentPost.hasFile) {
                // Add the current post to currentBrowsingPosts
                currentBrowsingPosts.append(currentPost);
            }
        }
        
        // If currentBrowsingPosts isnt empty...
        if(currentBrowsingPosts != []) {
            // Show the view
            self.hidden = false;
            
            displayPost(currentBrowsingPosts[0]);
        }
        // If currentBrowsingPosts is empty...
        else {
            // Print that we cant open the browser because there are no posts to display
            Swift.print("KJPostsImageViewer: Cant display browser for \(posts) because none of the posts have files");
        }
    }
    
    /// Displays the given post in this browser
    func displayPost(post : KJ4CPost) {
        // Show the post's file in the file view
        postFileViewer!.displayFileFromPost(post);
        
        // Display the post's file info in the toolbar
        displayPostFileInfoInToolbar(post);
    }
    
    /// Displays the info for the given post's file in the toolbar
    func displayPostFileInfoInToolbar(post : KJ4CPost) {
        // If the post has a file...
        if(post.hasFile) {
            // Update the toolbar
            // Set the file info text field's string value
            fileInfoTextField!.stringValue = post.fileInfo;
            
            // Update the tooltip for the file info text field
            fileInfoTextField!.toolTip = post.fileInfo;
        }
        // If the post doesnt have a file...
        else {
            // Print that we cant display info for a post that doesnt have a file
            Swift.print("KJPostsImageViewer: Cant display file info for \(post) in the toolbar because it doesnt have a file");
        }
    }

    /// Creates everything needed for the view and initializes it
    func initializeView() {
        // Create the views
        createViews();
        
        // Theme the views
        themeViews();
        
        // Create the constraints
        createConstraints();
        
        // Fill in some sample content
        fileInfoTextField!.stringValue = "filename.extension(size, widthxheight)";
    }
    
    /// Creates the views needed for displaying the image browser
    func createViews() {
        // Create postFileViewer
        
        // Create the file viewer
        postFileViewer = KJFileView();
        
        // Create the toolbar
        toolbar = KJColoredView();
        
        // Create the gallery button
        galleryButton = NSButton();
        
        // Set the target and action
        galleryButton!.target = self;
        galleryButton!.action = Selector("galleryButtonPressed");
        
        // Create the file info text field
        fileInfoTextField = NSTextField();
        
        // Create the download button
        downloadButton = NSButton();
        
        // Set the target and action
        downloadButton!.target = self;
        downloadButton!.action = Selector("downloadButtonPressed");
        
        // Create the next and previous buttons
        nextButton = NSButton();
        previousButton = NSButton();
        
        // Set the targets and actions
        nextButton!.target = self;
        nextButton!.action = Selector("nextButtonPressed");
        
        previousButton!.target = self;
        previousButton!.action = Selector("previousButtonPressed");
        
        // Move everything into this view
        self.addSubview(postFileViewer!);
        self.addSubview(toolbar!);
        toolbar!.addSubview(galleryButton!);
        toolbar!.addSubview(fileInfoTextField!);
        toolbar!.addSubview(previousButton!);
        toolbar!.addSubview(nextButton!);
        toolbar!.addSubview(downloadButton!);
    }
    
    /// Themes all the views
    func themeViews() {
        // Hide the view
        self.hidden = true;
        
        // Set the appearance to aqua so nothing is vibrant
        self.appearance = NSAppearance(named: NSAppearanceNameAqua);
        
        // Set the toolbar's color
        toolbar!.backgroundColor = KJThemingEngine().defaultEngine().imageBrowserToolbarColor;
        
        // Theme the gallery button
        galleryButton!.bordered = false;
        (galleryButton!.cell as! NSButtonCell).setButtonType(NSButtonType.MomentaryChangeButton);
        (galleryButton!.cell as! NSButtonCell).imageScaling = NSImageScaling.ScaleProportionallyUpOrDown;
        galleryButton!.image = NSImage(named: "KJGalleryGridIcon");
        galleryButton!.image = galleryButton!.image!.withColorOverlay(KJThemingEngine().defaultEngine().imageBrowserToolbarGalleryButtonColor);
        
        // Theme the file info text field
        fileInfoTextField!.bordered = false;
        fileInfoTextField!.selectable = false;
        fileInfoTextField!.editable = false;
        fileInfoTextField!.backgroundColor = NSColor.clearColor();
        fileInfoTextField!.textColor = KJThemingEngine().defaultEngine().imageBrowserToolbarFileInfoTextFieldColor;
        fileInfoTextField!.font = NSFont.systemFontOfSize(13);
        fileInfoTextField!.lineBreakMode = NSLineBreakMode.ByTruncatingMiddle;
        
        // Theme the download button
        downloadButton!.bordered = false;
        (downloadButton!.cell as! NSButtonCell).setButtonType(NSButtonType.MomentaryChangeButton);
        (downloadButton!.cell as! NSButtonCell).imageScaling = NSImageScaling.ScaleProportionallyUpOrDown;
        downloadButton!.image = NSImage(named: "KJDownloadIcon");
        downloadButton!.image = downloadButton!.image!.withColorOverlay(KJThemingEngine().defaultEngine().imageBrowserToolbarDownloadButtonColor);
        
        // Theme the next button
        nextButton!.bordered = false;
        (nextButton!.cell as! NSButtonCell).setButtonType(NSButtonType.MomentaryChangeButton);
        (nextButton!.cell as! NSButtonCell).imageScaling = NSImageScaling.ScaleProportionallyUpOrDown;
        nextButton!.image = NSImage(named: "KJNextIcon");
        nextButton!.image = nextButton!.image!.withColorOverlay(KJThemingEngine().defaultEngine().imageBrowserToolbarNextButtonColor);
        
        // Theme the previous button
        previousButton!.bordered = false;
        (previousButton!.cell as! NSButtonCell).setButtonType(NSButtonType.MomentaryChangeButton);
        (previousButton!.cell as! NSButtonCell).imageScaling = NSImageScaling.ScaleProportionallyUpOrDown;
        previousButton!.image = NSImage(named: "KJPreviousIcon");
        previousButton!.image = previousButton!.image!.withColorOverlay(KJThemingEngine().defaultEngine().imageBrowserToolbarPreviousButtonColor);
    }
    
    /// Creates the constraints for the view
    func createConstraints() {
        // Disable all the autoresizing mask to constraint translation
        self.translatesAutoresizingMaskIntoConstraints = false;
        postFileViewer?.translatesAutoresizingMaskIntoConstraints = false;
        toolbar?.translatesAutoresizingMaskIntoConstraints = false;
        galleryButton?.translatesAutoresizingMaskIntoConstraints = false;
        fileInfoTextField?.translatesAutoresizingMaskIntoConstraints = false;
        downloadButton?.translatesAutoresizingMaskIntoConstraints = false;
        nextButton?.translatesAutoresizingMaskIntoConstraints = false;
        previousButton?.translatesAutoresizingMaskIntoConstraints = false;
        
        // Create the constraints for the file viewer
        /// The constraint for the leading edge of the file viewer
        let postFileViewerLeadingConstraint = NSLayoutConstraint(item: postFileViewer!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0);
        
        // Add the constraint
        self.addConstraint(postFileViewerLeadingConstraint);
        
        /// The constraint for the trailing edge of the file viewer
        let postFileViewerTrailingConstraint = NSLayoutConstraint(item: postFileViewer!, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0);
        
        // Add the constraint
        self.addConstraint(postFileViewerTrailingConstraint);
        
        /// The constraint for the top of the file viewier
        let postFileViewerTopConstraint = NSLayoutConstraint(item: postFileViewer!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0);
        
        // Add the constraint
        self.addConstraint(postFileViewerTopConstraint);
        
        /// The constraint for the bottom of the file viewer
        let postFileViewerBottomConstraint = NSLayoutConstraint(item: postFileViewer!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: toolbar!, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0);
        
        // Add the constraint
        self.addConstraint(postFileViewerBottomConstraint);
        
        // Create the constraints for the toolbar
        /// The constraint for the leading edge of the toolbar
        let toolbarLeadingConstraint = NSLayoutConstraint(item: toolbar!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0);
        
        // Add the constraint
        self.addConstraint(toolbarLeadingConstraint);
        
        /// The constraint for the trailing edge of the toolbar
        let toolbarTrailingConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: toolbar!, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0);
        
        // Add the constraint
        self.addConstraint(toolbarTrailingConstraint);
        
        /// The constraint for the bottom edge of the toolbar
        toolbarBottomConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: toolbar!, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0);
        
        // Add the constraint
        self.addConstraint(toolbarBottomConstraint!);
        
        // Create the height constraint for the toolbar
        let toolbarHeightConstraint = NSLayoutConstraint(item: toolbar!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: KJThemingEngine().defaultEngine().imageBrowserToolbarHeight);
        
        // Add the constraint
        toolbar!.addConstraint(toolbarHeightConstraint);
        
        // Add the constraints to the gallery button
        /// The constraint for the leading edge of the gallery button
        let galleryButtonLeadingConstraint = NSLayoutConstraint(item: galleryButton!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: toolbar!, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 10);
        
        // Add the constraint
        self.addConstraint(galleryButtonLeadingConstraint);
        
        // Create the width constraint for the gallery button
        let galleryButtonWidthConstraint = NSLayoutConstraint(item: galleryButton!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 17);
        
        // Add the constraint
        galleryButton!.addConstraint(galleryButtonWidthConstraint);
        
        // Create the height constraint for the gallery button
        let galleryButtonHeightConstraint = NSLayoutConstraint(item: galleryButton!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 17);
        
        // Add the constraint
        galleryButton!.addConstraint(galleryButtonHeightConstraint);
        
        /// The constraint for the Y centering of the gallery button
        let galleryButtonCenterYConstraint = NSLayoutConstraint(item: galleryButton!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: toolbar!, attribute: NSLayoutAttribute.CenterY
            , multiplier: 1, constant: 0);
        
        // Add the constraint
        toolbar!.addConstraint(galleryButtonCenterYConstraint);
        
        // Add the constraints to the file info text field
        /// The constraint for the leading edge of the file info text field
        let fileInfoTextFieldLeadingConstraint = NSLayoutConstraint(item: fileInfoTextField!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: galleryButton!, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 5);
        
        // Add the constraint
        toolbar!.addConstraint(fileInfoTextFieldLeadingConstraint);
        
        /// The constraint for the height of the file info text field
        let fileInfoTextFieldHeightConstraint = NSLayoutConstraint(item: fileInfoTextField!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 17);
        
        // Add the constraint
        fileInfoTextField!.addConstraint(fileInfoTextFieldHeightConstraint);
        
        /// The constraint for the Y centering of the file info text field
        let fileInfoTextFieldCenterYConstraint = NSLayoutConstraint(item: fileInfoTextField!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: toolbar!, attribute: NSLayoutAttribute.CenterY
            , multiplier: 1, constant: 0);
        
        // Add the constraint
        toolbar!.addConstraint(fileInfoTextFieldCenterYConstraint);
        
        // Set the content compression priorities
        fileInfoTextField!.setContentCompressionResistancePriority(250, forOrientation: .Horizontal);
        fileInfoTextField!.setContentCompressionResistancePriority(250, forOrientation: .Vertical);
        
        // Add the constraints to the previous button
        /// The constraint for the leading edge of the previous button
        let previousButtonLeadingConstraint = NSLayoutConstraint(item: previousButton!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: fileInfoTextField!, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 10);
        
        // Add the constraint
        self.addConstraint(previousButtonLeadingConstraint);
        
        // Create the width constraint for the previous button
        let previousButtonWidthConstraint = NSLayoutConstraint(item: previousButton!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 17);
        
        // Add the constraint
        previousButton!.addConstraint(previousButtonWidthConstraint);
        
        // Create the height constraint for the previous button
        let previousButtonHeightConstraint = NSLayoutConstraint(item: previousButton!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 17);
        
        // Add the constraint
        previousButton!.addConstraint(previousButtonHeightConstraint);
        
        /// The constraint for the Y centering of the previous button
        let previousButtonCenterYConstraint = NSLayoutConstraint(item: previousButton!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: toolbar!, attribute: NSLayoutAttribute.CenterY
            , multiplier: 1, constant: 0);
        
        // Add the constraint
        toolbar!.addConstraint(previousButtonCenterYConstraint);
        
        // Add the constraints to the next button
        /// The constraint for the leading edge of the next button
        let nextButtonLeadingConstraint = NSLayoutConstraint(item: nextButton!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: previousButton!, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 10);
        
        // Add the constraint
        self.addConstraint(nextButtonLeadingConstraint);
        
        // Create the width constraint for the next button
        let nextButtonWidthConstraint = NSLayoutConstraint(item: nextButton!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 17);
        
        // Add the constraint
        nextButton!.addConstraint(nextButtonWidthConstraint);
        
        // Create the height constraint for the next button
        let nextButtonHeightConstraint = NSLayoutConstraint(item: nextButton!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 17);
        
        // Add the constraint
        nextButton!.addConstraint(nextButtonHeightConstraint);
        
        /// The constraint for the Y centering of the next button
        let nextButtonCenterYConstraint = NSLayoutConstraint(item: nextButton!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: toolbar!, attribute: NSLayoutAttribute.CenterY
            , multiplier: 1, constant: 0);
        
        // Add the constraint
        toolbar!.addConstraint(nextButtonCenterYConstraint);
        
        // Add the constraints to the download button
        /// The constraint for the leading edge of the download button
        let downloadButtonLeadingConstraint = NSLayoutConstraint(item: downloadButton!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: nextButton!, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 10);
        
        // Add the constraint
        self.addConstraint(downloadButtonLeadingConstraint);
        
        /// The constraint for the trailing edge of the download button
        let downloadButtonTrailingConstraint = NSLayoutConstraint(item: downloadButton!, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: toolbar!, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: -10);
        
        // Add the constraint
        self.addConstraint(downloadButtonTrailingConstraint);
        
        // Create the width constraint for the download button
        let downloadButtonWidthConstraint = NSLayoutConstraint(item: downloadButton!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 17);
        
        // Add the constraint
        downloadButton!.addConstraint(downloadButtonWidthConstraint);
        
        // Create the height constraint for the download button
        let downloadButtonHeightConstraint = NSLayoutConstraint(item: downloadButton!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 17);
        
        // Add the constraint
        downloadButton!.addConstraint(downloadButtonHeightConstraint);
        
        /// The constraint for the Y centering of the download button
        let downloadButtonCenterYConstraint = NSLayoutConstraint(item: downloadButton!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: toolbar!, attribute: NSLayoutAttribute.CenterY
            , multiplier: 1, constant: 0);
        
        // Add the constraint
        toolbar!.addConstraint(downloadButtonCenterYConstraint);
    }
    
    /// Was this browser inited from init(As apposed to awakeFromNib)?
    private var initedFromInit : Bool = false;
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect);
        
        // Set the background color of this view to 50% opaque black
        self.layer?.backgroundColor = NSColor(calibratedWhite: 0, alpha: 0.5).CGColor;
    }
    
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
