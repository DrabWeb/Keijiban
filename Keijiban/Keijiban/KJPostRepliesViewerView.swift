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
    var viewingRepliesForPostViewContainer : NSView? = nil;
    
    /// The container that holds the scroll view and stack view for the replies to viewingRepliesForPost
    var repliesContainer : NSView? = nil;
    
    /// The button behind the entire view that captures clicks outside of this view
    var dismissButton : NSButton? = nil;
    
    /// Called when the user presses dismissButton
    func dismissButtonPressed() {
        // Close the view
        close();
    }
    
    /// The post that this view is currently displaying replies for
    var viewingRepliesForPost : KJ4CPost? = nil;

    /// Displays the replies from the given post in the replies viewer view. Darkens the background of the view if darkenBackgroud is true
    func displayRepliesFromPost(post : KJ4CPost, darkenBackground : Bool) {
        // Print what we are displaying
        Swift.print("KJPostRepliesViewerView: Displaying replies for \(post.description)");
        
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
        let newPostView : KJPostView = KJPostView();
        
        // Set the post view's replies viewer view container
        newPostView.repliesViewerViewContainer = self;
        
        // Display the post's info in the new post view
        newPostView.displayPost(post, displayImage: true);
        
        // Add the post view to viewingRepliesForPostViewContainer
        viewingRepliesForPostViewContainer!.addSubview(newPostView);
        
        // Hide the separator on the post view
        newPostView.bottomSeparator!.hidden = true;
        
        // Hide the replies button on the post view
        newPostView.repliesButtonWidthConstraint!.constant = 0;
        
        // Add the outer constraints to newPostView
        addOuterConstraintsToView(newPostView);
        
        /// The KJPostViewerViewController for showing the replies to viewingRepliesForPost
        let repliesPostViewerViewController : KJPostViewerViewController = (NSStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateControllerWithIdentifier("postViewerViewController")) as! KJPostViewerViewController;
        
        // For every reply in the given post's replies...
        for(_, currentReply) in post.replies.enumerate() {
            // Add the current reply to the postsViewerStackView of repliesPostViewerViewController
            repliesPostViewerViewController.addPostToPostsViewerStackView(currentReply, displayImage: true);
            (repliesPostViewerViewController.postsViewerStackView.subviews.last! as! KJPostView).repliesViewerViewContainer = self;
        }
        
        // Unhide postsViewerStackViewScrollView
        repliesPostViewerViewController.postsViewerStackViewScrollView.hidden = false;
        
        // Add the posts viewer view to repliesContainer and add the outer constraints
        repliesContainer!.addSubview(repliesPostViewerViewController.postsViewerStackViewScrollView);
        addOuterConstraintsToView(repliesContainer!.subviews[0]);
        
        // Scroll to the top of postsViewerStackViewScrollView
        repliesPostViewerViewController.scrollToTopOfPostsViewerStackViewScrollView();
        
        // Fade in the view
        self.animator().alphaValue = 1;
    }
    
    /// Closes this replies viewer
    func close() {
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
    
    override func performKeyEquivalent(theEvent: NSEvent) -> Bool {
        super.performKeyEquivalent(theEvent);
        
        // If we pressed escape...
        if(theEvent.keyCode == 53) {
            // Close the view
            close();
        }
        
        return true;
    }
    
    /// Creates everything needed for the view and initializes it
    func initializeView() {
        // Create the views
        createViews();
        
        // Create the constraints
        createConstraints();
    }
    
    /// Creates the views needed for displaying replies
    func createViews() {
        // Create viewingRepliesForPostViewContainer
        viewingRepliesForPostViewContainer = NSView();
        
        // Create repliesContainer
        repliesContainer = NSView();
        
        // Create dismissButton
        dismissButton = NSButton();
        
        // Style dismissButton
        dismissButton!.bordered = false;
        (dismissButton!.cell as! NSButtonCell).setButtonType(NSButtonType.MomentaryPushInButton);
        
        // Set dismissButton's target and action
        dismissButton!.target = self;
        dismissButton!.action = Selector("dismissButtonPressed");
        
        // Move everything into this view
        self.addSubview(dismissButton!);
        self.addSubview(viewingRepliesForPostViewContainer!);
        self.addSubview(repliesContainer!);
    }
    
    /// Creates the constraints for the view
    func createConstraints() {
        // Disable all the autoresizing mask to constraint translation
        self.translatesAutoresizingMaskIntoConstraints = false;
        dismissButton?.translatesAutoresizingMaskIntoConstraints = false;
        viewingRepliesForPostViewContainer?.translatesAutoresizingMaskIntoConstraints = false;
        repliesContainer?.translatesAutoresizingMaskIntoConstraints = false;
        
        // Create the constraints for the viewing replies for post view
        /// The constraint for the leading edge of the viewing replies for post view
        let viewingRepliesForPostViewContainerLeadingConstraint = NSLayoutConstraint(item: viewingRepliesForPostViewContainer!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 20);
        
        // Add the constraint
        self.addConstraint(viewingRepliesForPostViewContainerLeadingConstraint);
        
        /// The constraint for the trailing edge of the viewing replies for post view
        let viewingRepliesForPostViewContainerTrailingConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: viewingRepliesForPostViewContainer!, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 20);
        
        // Add the constraint
        self.addConstraint(viewingRepliesForPostViewContainerTrailingConstraint);
        
        /// The constraint for the top edge of the viewing replies for post view
        let viewingRepliesForPostViewContainerTopConstraint = NSLayoutConstraint(item: viewingRepliesForPostViewContainer!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 20);
        
        // Add the constraint
        self.addConstraint(viewingRepliesForPostViewContainerTopConstraint);
        
        // Set the content compression priorities
        viewingRepliesForPostViewContainer!.setContentCompressionResistancePriority(750, forOrientation: .Vertical);
        
        // Create the constraints for the replies container view
        /// The constraint for the leading edge of the replies container view
        let repliesContainerLeadingConstraint = NSLayoutConstraint(item: repliesContainer!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 20);
        
        // Add the constraint
        self.addConstraint(repliesContainerLeadingConstraint);
        
        /// The constraint for the trailing edge of the replies container view
        let repliesContainerTrailingConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: repliesContainer!, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 20);
        
        // Add the constraint
        self.addConstraint(repliesContainerTrailingConstraint);
        
        /// The constraint for the top edge of the replies container view
        let repliesContainerTopConstraint = NSLayoutConstraint(item: viewingRepliesForPostViewContainer!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: repliesContainer!, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: -10);
        
        // Add the constraint
        self.addConstraint(repliesContainerTopConstraint);
        
        /// The constraint for the bottom edge of the replies container view
        let repliesContainerBottomConstraint = NSLayoutConstraint(item: repliesContainer!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -20);
        
        // Add the constraint
        self.addConstraint(repliesContainerBottomConstraint);
        
        // Set the hugging priority
        dismissButton!.setContentHuggingPriority(250, forOrientation: .Horizontal);
        dismissButton!.setContentHuggingPriority(250, forOrientation: .Vertical);
        
        // Add the constraints for dismissButonn
        addOuterConstraintsToView(dismissButton!);
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect);
        
        // Set the radius of the corners of the post view containers
        viewingRepliesForPostViewContainer?.layer?.cornerRadius = 5;
        repliesContainer?.layer?.cornerRadius = 5;
    }
    
    // Blank init
    init() {
        super.init(frame: NSRect.zero);
        
        // Initialize the view
        initializeView();
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
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