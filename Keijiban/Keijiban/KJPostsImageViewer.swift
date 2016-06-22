//
//  KJPostsImageViewer.swift
//  Keijiban
//
//  Created by Seth on 2016-06-07.
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
        // Display the next post
        nextPost();
    }
    
    /// The button in the toolbar for going to the previous image(Instead of using the keybind)
    var previousButton : NSButton? = nil;
    
    /// Called when the user presses previousButton
    func previousButtonPressed() {
        // Display the previous post
        previousPost();
    }
    
    /// The post that this image browser is currently displaying
    var currentBrowsingPosts : [KJ4CPost] = [];
    
    /// The current post we are viewing the file of
    var currentBrowsingPost : KJ4CPost? = nil;
    
    /// The index of currentBrowsingPost
    var currentBrowsingPostIndex : Int {
        get {
            if(currentBrowsingPost == nil) {
                return -1;
            }
            else {
                if(currentBrowsingPost != nil) {
                    return NSMutableArray(array: currentBrowsingPosts).indexOfObject(currentBrowsingPost!);
                }
                else {
                    return -1;
                }
            }
        }
    }
    
    /// Shows this image browser with the images of the given posts. If displayFirstPost it automatically displays the first post in posts
    func showImagesForPosts(posts : [KJ4CPost], displayFirstPost : Bool) {
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
            
            // If we said to display the first post...
            if(displayFirstPost) {
                // Display the first post
                displayPostAtIndex(0);
            }
        }
        // If currentBrowsingPosts is empty...
        else {
            // Print that we cant open the browser because there are no posts to display
            Swift.print("KJPostsImageViewer: Cant display browser for \(posts) because none of the posts have files");
        }
    }
    
    /// Displays the given post in this browser
    func displayPost(post : KJ4CPost) {
        // If the post has a file...
        if(post.hasFile) {
            // Set currentBrowsingPost
            currentBrowsingPost = post;
            
            // Show the post's file in the file view
            postFileViewer!.displayFileFromPost(post);
            
            // Display the post's file info in the toolbar
            displayPostFileInfoInToolbar(post);
        }
        // If the post doesnt have a file...
        else {
            // Print that we cant view this post
            Swift.print("KJPostsImageViewer: Cant display \(post) because it doesnt have a file");
        }
    }
    
    /// Displays the post at the given index in currentBrowsingPosts in this browser. Also rounds off(If less than 0, displays first image. If greater than currentBrowsingPosts's item count displays last)
    func displayPostAtIndex(index : Int) {
        // If the index is greater than 0 and less than currentBrowsingPosts's item count...
        if(index >= 0 && index < currentBrowsingPosts.count) {
            // Display the post at the given index
            displayPost(currentBrowsingPosts[index]);
        }
        // If the index is less than 0...
        else if(index <= 0) {
            // Display the first item in currentBrowsingPosts
            displayPost(currentBrowsingPosts[0]);
        }
        // If the index is greater than currentBrowsingPosts's item count...
        else if(index >= currentBrowsingPosts.count) {
            // Display the last item in currentBrowsingPosts
            displayPost(currentBrowsingPosts[currentBrowsingPosts.count - 1]);
        }
    }
    
    /// Displays the next post in this browser
    func nextPost() {
        // Print that we are showing the next post
        Swift.print("KJPostsImageViewer: Showing next post");
        
        // If we add one to currentBrowsingPostIndex and its less than currentBrowsingPostIndex's item count...
        if(currentBrowsingPostIndex + 1 < currentBrowsingPosts.count) {
            // Display the next post
            displayPostAtIndex(currentBrowsingPostIndex + 1);
        }
        // If we add one to currentBrowsingPostIndex and its greater than currentBrowsingPostIndex's item count...
        else {
            // Display the first post
            displayPostAtIndex(0);
        }
    }
    
    /// Displays the previous post in this browser
    func previousPost() {
        // Print that we are showing the previous post
        Swift.print("KJPostsImageViewer: Showing previous post");
        
        // If we subtract one from currentBrowsingPostIndex and its greater than -1...
        if(currentBrowsingPostIndex - 1 >= 0) {
            // Display the previous post
            displayPostAtIndex(currentBrowsingPostIndex - 1);
        }
        // If we subtract one from currentBrowsingPostIndex and its less than 0...
        else {
            // Display the last post
            displayPostAtIndex(currentBrowsingPosts.count - 1);
        }
    }
    
    /// Displays the info for the given post's file in the toolbar
    func displayPostFileInfoInToolbar(post : KJ4CPost) {
        // If the post has a file...
        if(post.hasFile) {
            // Update the toolbar
            // Set the file info text field's string value
            fileInfoTextField!.stringValue = post.fileInfo + " \(currentBrowsingPostIndex + 1)/\(currentBrowsingPosts.count)";
            
            // Update the tooltip for the file info text field
            fileInfoTextField!.toolTip = post.fileInfo;
        }
        // If the post doesnt have a file...
        else {
            // Print that we cant display info for a post that doesnt have a file
            Swift.print("KJPostsImageViewer: Cant display file info for \(post) in the toolbar because it doesnt have a file");
        }
    }
    
    /// Closes this browser
    func close() {
        // Destroy this view
        self.removeFromSuperview();
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
    
    override func performKeyEquivalent(theEvent: NSEvent) -> Bool {
        // If we pressed the left arrow...
        if(theEvent.keyCode == 123) {
            // Display the the previous post
            previousPost();
            
            return true;
        }
        // If we pressed the right arrow...
        else if(theEvent.keyCode == 124) {
            // Display the the next post
            nextPost();
            
            return true;
        }
        // If we pressed escape...
        else if(theEvent.keyCode == 53) {
            // Close the view
            close();
            
            return true;
        }
        
        return false;
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
