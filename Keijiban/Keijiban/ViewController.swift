//
//  ViewController.swift
//  Keijiban
//
//  Created by Seth on 2016-05-26.
//

import Cocoa
import Alamofire

class ViewController: NSViewController, NSWindowDelegate {
    
    /// The main window of this view controller
    var window : NSWindow = NSWindow();
    
    /// The visual effect view for the background of the window
    @IBOutlet var backgroundVisualEffectView: NSVisualEffectView!
    
    /// The visual effect view for the titlebar of the window
    @IBOutlet var titlebarVisualEffectView: NSVisualEffectView!
    
    /// The top constraint for titlebarVisualEffectView
    @IBOutlet var titlebarVisualEffectViewTopConstraint: NSLayoutConstraint!
    
    /// The split view controller for the content of this window(Sidebar and posts)
    var contentSplitViewController: KJBrowserWindowSplitViewController!
    
    /// The sidebar view controller for this window
    var contentSidebarViewController: KJBrowserWindowSidebarViewController!
    
    /// The posts view controller for this window
    var contentPostsViewController: KJBrowserWindowPostsViewController!
    
    /// The button in the titlebar for hiding/showing the sidebar
    @IBOutlet var titlebarToggleSidebarButton: NSButton!
    
    /// When we push titlebarToggleSidebarButton...
    @IBAction func titlebarToggleSidebarButtonPressed(sender: AnyObject) {
        // Toggle the sidebar
        toggleSidebar();
    }
    
    /// The popup button in the titlebar for choosing the board
    @IBOutlet var titlebarBoardChooserPoupButton: NSPopUpButton!
    
    /// The left side constraint for titlebarBoardChooserPoupButton
    @IBOutlet var titlebarBoardChooserPoupButtonLeftConstraint: NSLayoutConstraint!
    
    /// When the user selects an item in titlebarBoardChooserPoupButton...
    @IBAction func titlebarBoardChooserPoupButtonInteracted(sender: NSPopUpButton) {
        // Change the current board to the selected board
        currentBoard = chanUtilities.boards[sender.selectedItem!.tag];
        
        print("Changing to board \(currentBoard)");
    }
    
    /// The 4chan utilities for this view controller
    let chanUtilities : KJ4CUtilities = KJ4CUtilities();
    
    /// The current board the user has selected
    var currentBoard : KJ4CBoard = KJ4CBoard();
    
    /// Updates titlebarToggleSidebarButton to match if the sidebar is collapsed
    func updateSidebarToggleButton() {
        // Set the sidebar toggle buttons state based on if the sidebar is collapsed
        titlebarToggleSidebarButton.state = Int(contentSplitViewController.splitViewItems[0].collapsed);
    }
    
    /// Toggles if the sidebar is open
    func toggleSidebar() {
        // Toggle if the sidebar is collapsed
        contentSplitViewController.splitViewItems[0].animator().collapsed = !contentSplitViewController.splitViewItems[0].collapsed;
        
        // Update the sidebar toggle button
        updateSidebarToggleButton();
    }
    
    /// Is the titlebar visible?
    var titlebarVisible : Bool = true;
    
    /// Toggles the visibility of the titlebar
    func toggleTitlebar() {
        // Toggle titlebarVisible
        titlebarVisible = !titlebarVisible;
        
        // If the titlebar is now visible...
        if(titlebarVisible) {
            // Show the titlebar
            showTitlebar();
        }
        // If the titlebar is now hidden...
        else {
            // Hide the titlebar
            hideTitlebar();
        }
    }
    
    /// Hides the titlebar
    func hideTitlebar() {
        // Change the animation speed
        NSAnimationContext.currentContext().duration = 0.1;
        
        // Animate up the titlebar
        titlebarVisualEffectViewTopConstraint.animator().constant = -37;
        
        // Fade out the window buttons
        window.standardWindowButton(.CloseButton)?.superview?.superview?.animator().alphaValue = 0;
    }
    
    /// Shows the titlebar
    func showTitlebar() {
        // Change the animation speed
        NSAnimationContext.currentContext().duration = 0.1;
        
        // Animate down the titlebar
        titlebarVisualEffectViewTopConstraint.animator().constant = 0;
        
        // Fade in the window buttons
        window.standardWindowButton(.CloseButton)?.superview?.superview?.animator().alphaValue = 1;
    }
    
    /// Called when the user does CMD+T. Adds a new tab
    func newTabAction() {
        // Add a new tab
        contentPostsViewController.openNewDefaultTab(currentBoard, completionHandler: nil);
    }
    
    /// Called when the user does CMD+W. Closes the current tab if there are more than one, and if there is only one or less closes the window
    func closeAction() {
        // If there is more than one tab open...
        if(contentPostsViewController.tabs.count > 1) {
            // Close the selected tab
            contentPostsViewController.closeCurrentTab();
        }
        // If there is only one tab or less open...
        else {
            // Close the window
            window.close();
        }
    }
    
    /// Called when the user does CMD+SHIFT+L. Calls toggleSidebar
    func toggleSidebarAction() {
        // Toggle the sidebar
        toggleSidebar();
    }
    
    /// Called when the user pressed CMD+ALT+T. Toggles the titlebar
    func actionToggleTitlebar() {
        // Toggle the titlebar
        toggleTitlebar();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        // Style the window
        styleWindow();
        
        // Setup the 4chan utilities
        setupChanUtilities();
    }

    /// Sets up the 4chan utilities for this view controller
    func setupChanUtilities() {
        // Setup the 4chan utilities
        chanUtilities.getAllBoards(boardsLoaded);
    }
    
    /// Called when the boards for chanUtilities load
    private func boardsLoaded() {
        // Remove all the menu items from titlebarBoardChooserPoupButton
        titlebarBoardChooserPoupButton.removeAllItems();
        
        // For every board...
        for(currentIndex, currentBoard) in chanUtilities.boards.enumerate() {
            // If the user added this board to their board list...
            if((NSApplication.sharedApplication().delegate as! AppDelegate).preferences.boards.contains(currentBoard.code)) {
                // Add the current board to titlebarBoardChooserPoupButton
                titlebarBoardChooserPoupButton.addItemWithTitle(currentBoard.name);
                
                // Set the item's tag to it's board's index in boards
                titlebarBoardChooserPoupButton.itemArray.last!.tag = currentIndex;
            }
        }
        
        // Update the current board
        currentBoard = chanUtilities.boards[titlebarBoardChooserPoupButton.selectedItem!.tag];
        
        // Open a new tab on the catalog
        contentPostsViewController.openNewDefaultTab(currentBoard, completionHandler: nil);
    }
    
    override func viewWillAppear() {
        // Set the tabs control's add action and target
        contentPostsViewController.tabsControl.addTarget = self;
        contentPostsViewController.tabsControl.addAction = Selector("newTabAction");
    }
    
    func windowWillEnterFullScreen(notification: NSNotification) {
        // Hide the toolbar
        window.toolbar?.visible = false;
        
        // Set the window's appearance to vibrant dark so the fullscreen toolbar is dark
        window.appearance = NSAppearance(named: NSAppearanceNameVibrantDark);
        
        // Update the constraints
        titlebarBoardChooserPoupButtonLeftConstraint.constant = 2;
    }
    
    func windowDidExitFullScreen(notification: NSNotification) {
        // Show the toolbar
        window.toolbar?.visible = true;
        
        // Set back the window's appearance
        window.appearance = NSAppearance(named: NSAppearanceNameAqua);
        
        // Update the constraints
        titlebarBoardChooserPoupButtonLeftConstraint.constant = 67;
    }
    
    /// Styles the window
    func styleWindow() {
        // Get the window
        window = NSApplication.sharedApplication().windows.last!;
        
        // Set the window's delegate
        window.delegate = self;
        
        // Style the visual effect views
        titlebarVisualEffectView.material = .Titlebar;
        backgroundVisualEffectView.material = .Dark;
        
        // Style the window's titlebar
        window.titleVisibility = .Hidden;
        window.styleMask |= NSFullSizeContentViewWindowMask;
        window.titlebarAppearsTransparent = true;
    }
    
    /// Called when the collapsed state of the sidebar for this browser window's content changes
    func sidebarCollapsedStateChanged() {
        // Update the sidebar toggle button
        updateSidebarToggleButton();
    }
    
    /// Called when the user presses CMD+1. Tries to jump to tab 1
    func actionJumpToTabOne() {
        // Jump to the tab
        contentPostsViewController.tryToJumpToTab(0);
    }
    
    /// Called when the user presses CMD+2. Tries to jump to tab 2
    func actionJumpToTabTwo() {
        // Jump to the tab
        contentPostsViewController.tryToJumpToTab(1);
    }
    
    /// Called when the user presses CMD+3. Tries to jump to tab 3
    func actionJumpToTabThree() {
        // Jump to the tab
        contentPostsViewController.tryToJumpToTab(2);
    }
    
    /// Called when the user presses CMD+4. Tries to jump to tab 4
    func actionJumpToTabFour() {
        // Jump to the tab
        contentPostsViewController.tryToJumpToTab(3);
    }
    
    /// Called when the user presses CMD+5. Tries to jump to tab 5
    func actionJumpToTabFive() {
        // Jump to the tab
        contentPostsViewController.tryToJumpToTab(4);
    }
    
    /// Called when the user presses CMD+6. Tries to jump to tab 6
    func actionJumpToTabSix() {
        // Jump to the tab
        contentPostsViewController.tryToJumpToTab(5);
    }
    
    /// Called when the user presses CMD+7. Tries to jump to tab 7
    func actionJumpToTabSeven() {
        // Jump to the tab
        contentPostsViewController.tryToJumpToTab(6);
    }
    
    /// Called when the user presses CMD+8. Tries to jump to tab 8
    func actionJumpToTabEight() {
        // Jump to the tab
        contentPostsViewController.tryToJumpToTab(7);
    }
    
    /// Called when the user presses CMD+9. Tries to jump to tab 9
    func actionJumpToTabNine() {
        // Jump to the tab
        contentPostsViewController.tryToJumpToTab(8);
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender);
        
        // If this is the segue for the content view container....
        if(segue.identifier == "contentSplitViewControllerSegue") {
            // Set contentSplitViewController
            contentSplitViewController = segue.destinationController as! KJBrowserWindowSplitViewController;
            
            // Get contentSidebarViewController and contentPostsViewController
            contentSidebarViewController = contentSplitViewController.splitViewItems[0].viewController as! KJBrowserWindowSidebarViewController;
            contentPostsViewController = contentSplitViewController.splitViewItems[1].viewController as! KJBrowserWindowPostsViewController;
            
            // Set contentSplitViewController's sidebar collapsed state changed target and action
            contentSplitViewController.sidebarCollapseStateChangedTarget = self;
            contentSplitViewController.sidebarCollapseStateChangedAction = Selector("sidebarCollapsedStateChanged");
        }
    }
}