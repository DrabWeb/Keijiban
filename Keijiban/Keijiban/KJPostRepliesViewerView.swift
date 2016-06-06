//
//  KJPostRepliesViewerView.swift
//  Keijiban
//
//  Created by Seth on 2016-06-06.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class KJPostRepliesViewerView: NSView {
    
    /// The container for the post view that shows viewingRepliesForPost
    @IBOutlet var viewingRepliesForPostViewContainer: NSView!
    
    /// The container that holds the scroll view and stack view for the replies to viewingRepliesForPost
    @IBOutlet var repliesContainer : NSView!
    
    /// When the user presses behind this replies viewer view...
    @IBAction func dismissButtonPressed(sender : NSButton) {
        // Close the view
        close();
    }
    
    /// The post that this view is currently displaying replies for
    var viewingRepliesForPost : KJ4CPost? = nil;

    /// Displays the replies from the given post in the replies viewer view. Darkens the background of the view if darkenBackgroud is true
    func displayRepliesFromPost(post : KJ4CPost, darkenBackground : Bool) {
        // Print what we are displaying
        Swift.print("KJPostRepliesViewerView: Displaying replies for \(post.description)");
        
        // Set the radius of the corners of the post view containers
        viewingRepliesForPostViewContainer.layer?.cornerRadius = 5;
        repliesContainer.layer?.cornerRadius = 5;
        
        // Set viewingRepliesForPost
        viewingRepliesForPost = post;
        
        // Set the alpha value of the view to 0
        self.alphaValue = 0;
        
        // If darkenBackground is true...
        if(darkenBackground) {
            // Set the background color of this view to 50% opaque black
            self.layer?.backgroundColor = NSColor(calibratedWhite: 0, alpha: 0.5).CGColor;
        }
        
        /// The new post view item for the stack view
        let newPostView : KJPostViewerThreadPostView = (NSStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateControllerWithIdentifier("postsViewerPostViewControllerTemplate") as! NSViewController).view.subviews[0] as! KJPostViewerThreadPostView;
        
        // Set the post view's replies viewer view container
        newPostView.repliesViewerViewContainer = self;
        
        // Display the post's info in the new post view
        newPostView.displayInfoFromPost(post, displayImage: true);
        
        // Add the post view to viewingRepliesForPostViewContainer
        viewingRepliesForPostViewContainer.addSubview(newPostView);
        
        // Hide the separator on the post view
        newPostView.bottomSeparator.hidden = true;
        
        // Hide the replies button on the post view
        newPostView.repliesButtonWidthConstraint.constant = 0;
        
        // Add the outer constraints to newPostView
        addOuterConstraintsToView(newPostView);
        
        /// The KJPostViewerViewController for showing the replies to viewingRepliesForPost
        let repliesPostViewerViewController : KJPostViewerViewController = (NSStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateControllerWithIdentifier("postViewerViewController")) as! KJPostViewerViewController;
        
        // For every reply in the given post's replies...
        for(_, currentReply) in post.replies.enumerate() {
            // Add the current reply to the postsViewerStackView of repliesPostViewerViewController
            repliesPostViewerViewController.addPostToPostsViewerStackView(currentReply, displayImage: true);
            (repliesPostViewerViewController.postsViewerStackView.subviews.last! as! KJPostViewerThreadPostView).repliesViewerViewContainer = self;
        }
        
        // Unhide postsViewerStackViewScrollView
        repliesPostViewerViewController.postsViewerStackViewScrollView.hidden = false;
        
        // Add the posts viewer view to repliesContainer and add the outer constraints
        repliesContainer.addSubview(repliesPostViewerViewController.postsViewerStackViewScrollView);
        addOuterConstraintsToView(repliesContainer.subviews[0]);
        
        // Scroll to the top of postsViewerStackViewScrollView
        repliesPostViewerViewController.scrollToTopOfPostsViewerStackViewScrollView();
        
        // Fade in the view
        self.animator().alphaValue = 1;
    }
    
    /// Closes this replies viewer
    func close() {
        // Remove the local key monitor
        NSEvent.removeMonitor(keyDownMonitor!);
        
        // Fade out the view
        self.animator().alphaValue = 0;
        
        // Start the timer to destroy the view
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(NSAnimationContext.currentContext().duration), target: self, selector: Selector("destroyView"), userInfo: nil, repeats: false);
    }
    
    /// Removes this replies viewer from it's super view
    func destroyView() {
        // Remove this view from it's superview
        self.removeFromSuperview();
    }
    
    /// The local key down monitor
    var keyDownMonitor : AnyObject?;
    
    override func awakeFromNib() {
        // Subscribe to any local key presses
        keyDownMonitor = NSEvent.addLocalMonitorForEventsMatchingMask(NSEventMask.KeyDownMask, handler: localKeyPressed);
    }
    
    /// Called when the user prese
    func localKeyPressed(event : NSEvent) -> NSEvent {
        // If we pressed escape...
        if(event.keyCode == 53) {
            // Close the view
            close();
        }
        
        // Return the event
        return event;
    }
    
    /// Adds constraints for the top, bottom, leading and trailing edges for this view(All with a constant of 0)
    func addOuterConstraints() {
        // Add the constraints
        addOuterConstraintsToView(self);
    }
    
    /// Adds constraints for the top, bottom, leading and trailing edges for the given view(All with a constant of 0)
    private func addOuterConstraintsToView(view : NSView) {
        /// The constraint for the bottom edge
        let bottomConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view.superview!, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0);
        
        // Add the constraint
        view.superview!.addConstraint(bottomConstraint);
        
        /// The constraint for the top edge
        let topConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view.superview!, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0);
        
        // Add the constraint
        view.superview!.addConstraint(topConstraint);
        
        /// The constraint for the trailing edge
        let trailingConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: view.superview!, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0);
        
        // Add the constraint
        view.superview!.addConstraint(trailingConstraint);
        
        /// The constraint for the leading edge
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: view.superview!, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0);
        
        // Add the constraint
        view.superview!.addConstraint(leadingConstraint);
    }
}