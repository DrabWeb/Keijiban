//
//  KJBrowserWindowPostViewerViewController.swift
//  Keijiban
//
//  Created by Seth on 2016-05-27.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa
import Alamofire

/// The view controller for the posts viewer view(Can show catalog, index or a thread)
class KJPostViewerViewController: NSViewController {

    /// The collection view for this post viewer for if it is in the catalog
    @IBOutlet var catalogCollectionView: NSCollectionView!
    
    /// The scroll view for catalogCollectionView
    @IBOutlet var catalogCollectionViewScrollView: NSScrollView!
    
    /// The NSArrayController for catalogCollectionView
    @IBOutlet weak var catalogCollectionViewArrayController: NSArrayController!
    
    /// The array of items in catalogCollectionViewArrayController
    var catalogCollectionViewItems : NSMutableArray = NSMutableArray();
    
    /// The stack view for showing the posts in the posts viewer stack view
    @IBOutlet var postsViewerStackView: NSStackView!
    
    /// The scroll view for postsViewerStackView
    @IBOutlet var postsViewerStackViewScrollView: NSScrollView!
    
    /// The current mode that this post viewer is in
    var currentMode : KJPostViewerMode = KJPostViewerMode.None;
    
    /// The current board this post viewer is showing something for
    var currentBoard : KJ4CBoard? = nil;
    
    /// The current thread we are displaying(If any)
    var currentThread : KJ4CThread? = nil;
    
    /// The last requests for downloading thumbnails in this view
    var lastThumbnailDownloadRequests : [Request] = [];
    
    /// Displays the given thread in the posts stack view. Returns the title that should be used in tabs
    func displayThread(thread : KJ4CThread, completionHandler: (() -> ())?) -> String {
        // Set the current mode, board and thread
        currentMode = .Thread;
        currentBoard = thread.board!;
        currentThread = thread;
        
        // Print what thread we are displaying
        print("KJPostViewerViewController: Displaying thread /\(currentBoard!.code)/\(currentThread!.opPost!.postNumber) - \(currentThread!.displayTitle!)");
        
        // Remove all the current post items
        clearPostsViewerStackView();
        
        // For every post in the given thread...
        for(_, currentThreadPost) in currentThread!.allPosts.enumerate() {
            // Add the current post to postsViewerStackView
            addPostToPostsViewerStackView(currentThreadPost, displayImage: true);
        }
        
        // Scroll to the top of postsViewerStackViewScrollView
        scrollToTopOfPostsViewerStackViewScrollView();
        
        // Hide all the other views
        catalogCollectionViewScrollView.hidden = true;
        
        // Show the posts view
        postsViewerStackViewScrollView.hidden = false;
        
        // Return the title
        return "/\(currentBoard!.code)/ - \(currentThread!.displayTitle!)";
    }
    
    /// Displays the catalog for the given board. Only shows the amount of pages given(Minimum 0, maximum 9). Calls the given completion handler when done(If any). Returns the title that should be used in tabs
    func displayCatalog(forBoard : KJ4CBoard, maxPages : Int, completionHandler: (() -> ())?) -> String {
        // Set the current mode, board and thread
        currentMode = .Catalog;
        currentBoard = forBoard;
        currentThread = nil;
        
        // Print what catalog we are displaying
        print("KJPostViewerViewController: Displaying \(maxPages + 1) catalog pages for /\(currentBoard!.code)/");
        
        // Clear all the current items
        catalogCollectionViewArrayController.removeObjects(catalogCollectionViewArrayController.arrangedObjects as! [AnyObject]);
        
        // Make the request to get the catalog
        Alamofire.request(.GET, "https://a.4cdn.org/\(currentBoard!.code)/catalog.json", encoding: .JSON).responseJSON { (responseData) -> Void in
            /// The string of JSON that will be returned when the GET request finishes
            let responseJsonString : NSString = NSString(data: responseData.data!, encoding: NSUTF8StringEncoding)!;
            
            // If the the response data isnt nil...
            if let dataFromResponseJsonString = responseJsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                /// The JSON from the response string
                let responseJson = JSON(data: dataFromResponseJsonString);
                
                // For every page up till the given page limit...
                for currentPageIndex in 0...maxPages {
                    // For every thread in the current page...
                    for(_, currentThread) in responseJson[currentPageIndex]["threads"].enumerate() {
                        /// The new OP post to add to the catalog collection view
                        let newOpPost : KJ4COPPost = KJ4COPPost(json: currentThread.1, board: self.currentBoard!);
                        
                        // Load the thumbnail image
                        self.lastThumbnailDownloadRequests.append(Alamofire.request(.GET, newOpPost.fileThumbnailUrl).response { (request, response, data, error) in
                            // If data isnt nil...
                            if(data != nil) {
                                /// The downloaded image
                                let image : NSImage? = NSImage(data: data!);
                                
                                // If image isnt nil...
                                if(image != nil) {
                                    // If there are any items in catalogCollectionViewArrayController...
                                    if((self.catalogCollectionViewArrayController.arrangedObjects as! [AnyObject]).count > 0) {
                                        // For ever item in the catalog collection view...
                                        for currentIndex in 0...(self.catalogCollectionViewArrayController.arrangedObjects as! [AnyObject]).count - 1 {
                                            // If the current item's represented object is equal to the item we downloaded the thumbnail for...
                                            if(((self.catalogCollectionView.itemAtIndex(currentIndex)! as! KJPostViewerCatalogCollectionViewItem).representedObject as! KJ4COPPost) == newOpPost) {
                                                // Update the image view of the item
                                                self.catalogCollectionView.itemAtIndex(currentIndex)!.imageView?.image = image!;
                                                
                                                // Set the item's model's thumbnail image
                                                ((self.catalogCollectionView.itemAtIndex(currentIndex)! as! KJPostViewerCatalogCollectionViewItem).representedObject as! KJ4COPPost).thumbnailImage = image!;
                                            }
                                        }
                                    }
                                }
                            }
                            });
                        
                        // Add the OP post to the catalog collection view
                        self.catalogCollectionViewArrayController.addObject(newOpPost);
                    }
                }
                
                // Call the completion handler
                completionHandler?();
            }
        }
        
        // Hide all the other views
        postsViewerStackViewScrollView.hidden = true;
        
        // Show the catalog collection view
        catalogCollectionViewScrollView.hidden = false;
        
        // Return the title
        return "/\(currentBoard!.code)/ - Catalog";
    }
    
    /// Displays the index for the given board. Only shows the amount of pages given(Minimum 0, maximum 9). Calls the given completion handler when done(If any). Returns the title that should be used in tabs
    func displayIndex(forBoard : KJ4CBoard, maxPages : Int, completionHandler: (() -> ())?) -> String {
        // Set the current mode, board and thread
        currentMode = .Index;
        currentBoard = forBoard;
        currentThread = nil;
        
        // Print what catalog we are displayinga
        print("KJPostViewerViewController: Displaying \(maxPages + 1) index pages for /\(currentBoard!.code)/");
        
        // Clear all the current items
        clearPostsViewerStackView();
        
        // Make the request to get the catalog
        Alamofire.request(.GET, "https://a.4cdn.org/\(currentBoard!.code)/catalog.json", encoding: .JSON).responseJSON { (responseData) -> Void in
            /// The string of JSON that will be returned when the GET request finishes
            let responseJsonString : NSString = NSString(data: responseData.data!, encoding: NSUTF8StringEncoding)!;
            
            // If the the response data isnt nil...
            if let dataFromResponseJsonString = responseJsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                /// The JSON from the response string
                let responseJson = JSON(data: dataFromResponseJsonString);
                
                // For every page up till the given page limit...
                for currentPageIndex in 0...maxPages {
                    // For every thread in the current page...
                    for(_, currentThread) in responseJson[currentPageIndex]["threads"].enumerate() {
                        /// The new OP post to add to the catalog collection view
                        let newOpPost : KJ4COPPost = KJ4COPPost(json: currentThread.1, board: self.currentBoard!);
                        
                        // Load the thumbnail image
                        newOpPost.thumbnailImage = NSImage(contentsOfURL: NSURL(string: newOpPost.fileThumbnailUrl)!);
                        
                        // Add the OP post to the posts view
                        self.addPostToPostsViewerStackView(newOpPost, displayImage: true);
                        
                        // For every reply in the OP post's recent replies...
                        for(_, currentRecentReply) in newOpPost.recentReplies.enumerate() {
                            // Add the current post to the posts view
                            self.addPostToPostsViewerStackView(currentRecentReply, displayImage: false);
                        }
                    }
                }
                
                // Call the completion handler
                completionHandler?();
            }
        }
        
        // Scroll to the top of postsViewerStackViewScrollView
        scrollToTopOfPostsViewerStackViewScrollView();
        
        // Hide all the other views
        catalogCollectionViewScrollView.hidden = true;
        
        // Show the posts view
        postsViewerStackViewScrollView.hidden = false;
        
        // Return the title
        return "/\(currentBoard!.code)/ - Index";
    }
    
    /// Scrolls to the top of postsViewerStackViewScrollView
    func scrollToTopOfPostsViewerStackViewScrollView() {
        // Scroll to the top of postsViewerStackViewScrollView
        postsViewerStackViewScrollView.contentView.scrollToPoint(NSPoint(x: 0, y: postsViewerStackView.subviews.count * 100000));
    }
    
    /// Clears all the items in postsViewerStackView
    func clearPostsViewerStackView() {
        // Remove all the subviews from postsViewerStackView
        postsViewerStackView.subviews.removeAll();
    }
    
    /// Adds the given post to postsViewerStackView. ALso only shows the thumbnail if displayImage is true
    func addPostToPostsViewerStackView(post : KJ4CPost, displayImage : Bool) {
        /// The new post view item for the stack view
        let newPostView : KJPostView = KJPostView();
        
        // Display the post's info in the new post view
        newPostView.displayPost(post, displayImage: displayImage);
        
        // Set newPostView's repliesViewerViewContainer
        newPostView.repliesViewerViewContainer = self.view;
        
        // Set newPostView's thumbnail clicked target and action
        newPostView.thumbnailClickedTarget = self;
        newPostView.thumbnailClickedAction = Selector("postThumbnailImageClicked:");
        
        // Add the post view to postsViewerStackView
        postsViewerStackView.addView(newPostView, inGravity: NSStackViewGravity.Top);
        
        // Add the leading and trailing constraints
        /// The constraint for the trailing edge of newPostView
        let newPostViewTrailingConstraint = NSLayoutConstraint(item: newPostView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: postsViewerStackViewScrollView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: -50);
        
        // Add the constraint
        postsViewerStackViewScrollView.addConstraint(newPostViewTrailingConstraint);
        
        /// The constraint for the leading edge of newPostView
        let newPostViewLeadingConstraint = NSLayoutConstraint(item: newPostView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: postsViewerStackViewScrollView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: -50);
        
        // Add the constraint
        postsViewerStackViewScrollView.addConstraint(newPostViewLeadingConstraint);
    }
    
    /// The current image browser for this posts viewer
    var currentImageBrowser : KJPostsImageViewer? = nil;
    
    /// Called when the user presses a post's thumbnail image
    func postThumbnailImageClicked(post : KJ4CPost) {
        // Print what post we are displaying the file of
        print("KJPostViewerViewController: Displaying the file for \(post)");
        
        // If the current image browser is nil...
        if(currentImageBrowser?.superview == nil) {
            // Create a new KJPostsImageViewer
            currentImageBrowser = KJPostsImageViewer();
            
            // Move it into this view
            self.view.addSubview(currentImageBrowser!);
            
            // Disable translating autoresizing masks into constraints
            currentImageBrowser!.translatesAutoresizingMaskIntoConstraints = false;
            
            // Add the outer constraints
            currentImageBrowser!.addOuterConstraints(0);
            
            // Load in the current posts
            currentImageBrowser!.showImagesForPosts(self.currentThread!.allPosts, displayFirstPost: false);
        }
        
        // Jump to the clicked image in the current image browser
        currentImageBrowser!.displayPostAtIndex(NSMutableArray(array: currentImageBrowser!.currentBrowsingPosts).indexOfObject(post));
    }
    
    override func viewWillAppear() {
        // Theme the view
        self.view.layer?.backgroundColor = KJThemingEngine().defaultEngine().backgroundColor.CGColor;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        // Set postsViewerStackViewScrollView's document view
        postsViewerStackViewScrollView.documentView = postsViewerStackView;
        
        // Set the catalog collection view's item prototype
        catalogCollectionView.itemPrototype = storyboard!.instantiateControllerWithIdentifier("catalogCollectionViewItem") as? NSCollectionViewItem;
        
        // Set the minimum and maximum item sizes
        catalogCollectionView.minItemSize = NSSize(width: 150, height: 200);
        catalogCollectionView.maxItemSize = NSSize(width: 250, height: 250);
    }
}

/// The different modes KJPostViewerViewController can be in
enum KJPostViewerMode {
    /// Not set
    case None
    
    /// The catalog collection view
    case Catalog
    
    /// The index where you see the most recent posts
    case Index
    
    /// A thread
    case Thread
}
