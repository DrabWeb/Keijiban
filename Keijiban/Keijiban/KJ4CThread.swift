//
//  KJ4CThread.swift
//  Keijiban
//
//  Created by Seth on 2016-05-29.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

/// Represents a thread on 4chan
class KJ4CThread {
    /// The board this thread is on
    var board : KJ4CBoard? = nil;
    
    /// The first post of this thread
    var opPost : KJ4COPPost? = nil;
    
    /// All the posts in the thread besides the first
    var posts : [KJ4CPost] = [];
    
    /// Returns all the posts for this thread(Including the OP post)
    var allPosts : [KJ4CPost] {
        var allPostsArray : [KJ4CPost] = [opPost!];
        allPostsArray.appendContentsOf(posts);
        
        return allPostsArray;
    }
    
    /// Returns the post at the given index
    func postAtIndex(index : Int) -> KJ4CPost {
        if(index == 0) {
            return opPost!;
        }
        else {
            return posts[index - 1];
        }
    }
    
    /// Init with JSON and a board
    init(json : JSON, board : KJ4CBoard) {
        // Set board to the given board
        self.board = board;
        
        // For every thread in the given JSON...
        for(currentIndex, currentPost) in json["posts"].enumerate() {
            // If this is the first post...
            if(currentIndex == 0) {
                // Load the current post as the OP post
                opPost = KJ4COPPost(json: currentPost.1, board: self.board!);
            }
            // If this isnt the first post...
            else {
                // Load the current post into posts
                posts.append(KJ4CPost(json: currentPost.1, board: self.board!));
            }
        }
    }
}
