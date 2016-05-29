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
    
    /// The NSArrayController for catalogCollectionView
    @IBOutlet weak var catalogCollectionViewArrayController: NSArrayController!
    
    /// The array of items in catalogCollectionViewArrayController
    var catalogCollectionViewItems : NSMutableArray = NSMutableArray();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        // Set the catalog collection view's item prototype
        catalogCollectionView.itemPrototype = storyboard!.instantiateControllerWithIdentifier("catalogCollectionViewItem") as? NSCollectionViewItem;
        
        // Set the minimum and maximum item sizes
        catalogCollectionView.minItemSize = NSSize(width: 150, height: 200);
        catalogCollectionView.maxItemSize = NSSize(width: 250, height: 250);
        
        // Make the request to get the posts
        Alamofire.request(.GET, "https://a.4cdn.org/a/catalog.json", encoding: .JSON).responseJSON { (responseData) -> Void in
            /// The string of JSON that will be returned when the GET request finishes
            let responseJsonString : NSString = NSString(data: responseData.data!, encoding: NSUTF8StringEncoding)!;
            
            // If the the response data isnt nil...
            if let dataFromResponseJsonString = responseJsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                /// The JSON from the response string
                let responseJson = JSON(data: dataFromResponseJsonString);
                
                for currentIndex in 0...1 {
                    for(_, currentThread) in responseJson[currentIndex]["threads"].enumerate() {
                        let newItem : KJ4COPPost = KJ4COPPost(json: currentThread.1, board: KJ4CBoard(code: "a", name: "Anime & Manga"));
                        newItem.thumbnailImage = NSImage(contentsOfURL: NSURL(string: newItem.imageThumbnailUrl)!);
                        self.catalogCollectionViewArrayController.addObject(newItem);
                    }
                }
            }
        }
    }
}
