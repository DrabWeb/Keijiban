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
    
    /// Displays the given thread in the posts table view. Calls the given completion handler when done(If any)
    func displayThread(thread : KJ4CThread, completionHandler: (() -> ())?) {
        // Set the current mode, board and thread
        currentMode = .Thread;
        currentBoard = thread.board!;
        currentThread = thread;
        
        // Print what thread we are displaying
        if(currentThread!.opPost!.subject != "") {
            print("KJPostViewerViewController: Displaying thread /\(currentBoard!.code)/\(currentThread!.opPost!.postNumber) - \(currentThread!.opPost!.subject)");
        }
        else {
            print("KJPostViewerViewController: Displaying thread /\(currentBoard!.code)/\(currentThread!.opPost!.postNumber) - \(currentThread!.opPost!.comment.stringByReplacingOccurrencesOfString("\n", withString: " "))");
        }
        
        // Remove all the current post items
        clearPostsViewerStackView();
        
        // For every post in the given thread...
        for(_, currentThreadPost) in currentThread!.allPosts.enumerate() {
            // Add the current post to postsViewerStackView
            addPostToPostsViewerStackView(currentThreadPost);
        }
        
        // Scroll to the top of postsViewerStackViewScrollView
        // TODO: Make it so postsViewerStackViewScrollView scrolls to the top here
        
        // Hide all the other views
        catalogCollectionViewScrollView.hidden = true;
        
        // Show the posts view
        postsViewerStackViewScrollView.hidden = false;
    }
    
    /// Clears all the items in postsViewerStackView
    func clearPostsViewerStackView() {
        // Remove all the subviews from postsViewerStackView
        postsViewerStackView.subviews.removeAll();
    }
    
    /// Adds the given post to postsViewerStackView
    func addPostToPostsViewerStackView(post : KJ4CPost) {
        /// The new post view item for the stack view
        let newPostView : KJPostViewerThreadPostView = (storyboard!.instantiateControllerWithIdentifier("postsViewerPostViewControllerTemplate") as! NSViewController).view.subviews[0] as! KJPostViewerThreadPostView;
        
        // Display the post's info in the new post view
        newPostView.displayInfoFromPost(post);
        
        // Add the post view to postsViewerStackView
        postsViewerStackView.addView(newPostView, inGravity: .Top);
        
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
    
    /// Displays the catalog for the given board. Only shows the amount of pages given(Minimum 0, maximum 9). Calls the given completion handler when done(If any)
    func displayCatalog(forBoard : KJ4CBoard, maxPages : Int, completionHandler: (() -> ())?) {
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
                        newOpPost.thumbnailImage = NSImage(contentsOfURL: NSURL(string: newOpPost.imageThumbnailUrl)!);
                        
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
        
        // Make the request to get a thread from /a/ and display it
        Alamofire.request(.GET, "https://a.4cdn.org/a/thread/142234895.json", encoding: .JSON).responseJSON { (responseData) -> Void in
            /// The string of JSON that will be returned when the GET request finishes
            let responseJsonString : NSString = NSString(data: responseData.data!, encoding: NSUTF8StringEncoding)!;
            
            // If the the response data isnt nil...
            if let dataFromResponseJsonString = responseJsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                /// The JSON from the response string
                let responseJson = JSON(data: dataFromResponseJsonString);
                
                self.displayThread(KJ4CThread(json: responseJson, board: KJ4CBoard(code: "a", name: "Anime & Manga")), completionHandler: nil);
            }
        }
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
