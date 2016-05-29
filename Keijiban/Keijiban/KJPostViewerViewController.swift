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
    
    /// The table view for displaying posts in the list style
    @IBOutlet var postsTableView: NSTableView!
    
    /// The scroll view for postsTableView
    @IBOutlet var postsTableViewScrollView: NSScrollView!
    
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
        
        // Relod the table view
        postsTableView.reloadData();
        
        // Hide all the other views
        catalogCollectionViewScrollView.hidden = true;
        
        // Show the posts table view
        postsTableViewScrollView.hidden = false;
    }
    
    /// Displays the catalog for the given board. Only shows the amount of pages given(Minimum 0, maximum 9). Calls the given completion handler when done(If any)
    func displayCatalog(forBoard : KJ4CBoard, maxPages : Int, completionHandler: (() -> ())?) {
        // Set the current mode, board and thread
        currentMode = .Catalog;
        currentBoard = forBoard;
        currentThread = nil;
        
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
        postsTableViewScrollView.hidden = true;
        
        // Show the catalog collection view
        catalogCollectionViewScrollView.hidden = false;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        // Set the catalog collection view's item prototype
        catalogCollectionView.itemPrototype = storyboard!.instantiateControllerWithIdentifier("catalogCollectionViewItem") as? NSCollectionViewItem;
        
        // Set the minimum and maximum item sizes
        catalogCollectionView.minItemSize = NSSize(width: 150, height: 200);
        catalogCollectionView.maxItemSize = NSSize(width: 250, height: 250);
        
        // Make the request to get the catalog
        Alamofire.request(.GET, "https://a.4cdn.org/a/thread/142156412.json", encoding: .JSON).responseJSON { (responseData) -> Void in
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

extension KJPostViewerViewController: NSTableViewDataSource {
    func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
        // If currentThread isnt nil and we are in thread mode...
        if(currentThread != nil && currentMode == .Thread) {
            // Return the amount of posts in currentThread
            return 1 + currentThread!.posts.count;
        }
        
        // Return 0
        return 0;
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        /// The cell view for the cell we want to modify
        let cellView: NSTableCellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: nil) as! NSTableCellView;
        
        // If this is the posts column...
        if(tableColumn!.identifier == "Posts Column") {
            /// cellView as a KJPostViewerThreadTableCellView
            let postCellView : KJPostViewerThreadTableCellView = cellView as! KJPostViewerThreadTableCellView;
            
            /// The data for this cell
            let cellData : KJ4CPost = currentThread!.postAtIndex(row);
            
            // Display the data in the cell
            postCellView.displayInfoFromPost(cellData);
            
            // Return the modified cell view
            return postCellView as NSTableCellView;
        }
        
        // Return the unmodified cell view, we dont need to do anything
        return cellView;
    }
}

extension KJPostViewerViewController: NSTableViewDelegate {
//    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
//        
//    }
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
