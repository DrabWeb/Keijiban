//
//  KJFileView.swift
//  Keijiban
//
//  Created by Seth on 2016-06-08.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

/// The view for displaying a posts file(Like an NSImageView, but also supports other file formats uploadable to 4chan)
class KJFileView: NSView {
    /// The image view for this file view to display image files
    let imageView : KJRasterizedAsyncImageView = KJRasterizedAsyncImageView();
    
    /// The post that we are currently displaying the file of
    var currentDisplayingPost : KJ4CPost? = nil;
    
    /// Displays the file from the given post in this file view
    func displayFileFromPost(post : KJ4CPost) {
        // Cancel any current requests on imageView
        imageView.cancelDownload();
        
        // if the post has a file...
        if(post.hasFile) {
            // Set currentDisplayingPost
            currentDisplayingPost = post;
            
            // If the file is an image...
            if(post.fileExtension == ".jpg" || post.fileExtension == ".png" || post.fileExtension == ".gif") {
                // If the image isnt already downloaded...
                if(post.fileData == nil) {
                    // Download and display the image
                    imageView.downloadImageFromURL(post.fileUrl, placeHolderImage: post.thumbnailImage, errorImage: nil, usesSpinningWheel: true, downloadCompletionHandler: postImageDownloadFinished);
                }
                // If the image is already downloaded...
                else {
                    // Display the image
                    imageView.image = NSImage(data: post.fileData!);
                }
            }
            // If the file is a WEBM...
            else if(post.fileExtension == ".webm") {
                
            }
            // If the file isnt any of the above types...
            else {
                // Print that the file type is unsupported
                Swift.print("KJFileView: Error displaying file for post \(post), invalid file extension \"\(post.fileExtension)\"");
            }
        }
        // If the post doesnt have a file...
        else {
            // Print that we cant display this post
            Swift.print("KJFileView: Cant display post \(post) because it has no file");
            
            // Set currentDisplayingPost to nil
            currentDisplayingPost = nil;
        }
    }
    
    /// Called when a download to imageView finishes
    func postImageDownloadFinished(downloadedImage : NSImage?) {
        // Store the downloaded image's data in the current displaying post
        currentDisplayingPost!.fileData = downloadedImage!.dataForFileType(KJImageUtilities().fileTypeFromExtension(currentDisplayingPost!.fileExtension.substringFromIndex(currentDisplayingPost!.fileExtension.startIndex.advancedBy(1)))!);
    }
    
    /// Creates everything needed for the view and initializes it
    func initializeView() {
        // Move all the views into this view
        addViewsAsSubviews();
        
        // Theme the views
        themeViews();
        
        // Create the constraints
        createConstraints();
    }
    
    /// Moves all the views needed for this view into this view as a subview
    func addViewsAsSubviews() {
        // Add the subviews
        self.addSubview(imageView);
    }
    
    /// Themes all the views
    func themeViews() {
        // Set the appearance to aqua so nothing is vibrant
        self.appearance = NSAppearance(named: NSAppearanceNameAqua);
        
        // Theme the image view
        imageView.imageScaling = NSImageScaling.ScaleProportionallyDown;
        imageView.image = NSImage(named: "NSCaution");
    }
    
    /// Creates the constraints for the view
    func createConstraints() {
        // Disable all the autoresizing mask to constraint translation
        self.translatesAutoresizingMaskIntoConstraints = false;
        imageView.translatesAutoresizingMaskIntoConstraints = false;
        
        // Add the constraints to the image view
        // Add the outer constraints to imageView
        imageView.addOuterConstraints(0);
        
        // Set the hugging/content compression resistance values
        imageView.setContentHuggingPriority(250, forOrientation: .Horizontal);
        imageView.setContentHuggingPriority(250, forOrientation: .Vertical);
        
        imageView.setContentCompressionResistancePriority(250, forOrientation: .Horizontal);
        imageView.setContentCompressionResistancePriority(250, forOrientation: .Vertical);
    }
    
    /// Was this file view inited from init(As apposed to awakeFromNib)?
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