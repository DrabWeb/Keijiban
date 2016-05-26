//
//  LITabControl.m
//  LITabControl
//
//  Created by Mark Onyschuk on 11/12/2013.
//  Copyright (c) 2013 Mark Onyschuk. All rights reserved.
//

#import "LITabControl.h"
#import "LITabCell.h"

#import <QuartzCore/QuartzCore.h>

@interface LITabControl() <NSTextFieldDelegate>

@property(nonatomic, strong) NSArray        *items;

@property(nonatomic, strong) NSScrollView   *scrollView;
@property(nonatomic, strong) NSButton       *addButton, *scrollLeftButton, *scrollRightButton, *draggingTab;

@property(nonatomic, strong) NSTextField    *editingField;

@end

@implementation LITabControl

+ (Class)cellClass {
    return [LITabCell class];
}

#pragma mark -
#pragma mark Lifecycle

- (id)initWithFrame:(NSRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self configureSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        self = [super initWithFrame:self.frame];
        [self configureSubviews];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureSubviews];
}

- (void)configureSubviews {
    if (_scrollView == nil) {
        [self setWantsLayer:YES];
        
        LITabCell *cell     = self.cell;
        
        cell.title          = @"";
        cell.borderMask     = LIBorderMaskBottom;
        
        _scrollView         = [self viewWithClass:[NSScrollView class]];
        
        [_scrollView setDrawsBackground:NO];
        [_scrollView setBackgroundColor:[NSColor redColor]];
        [_scrollView setVerticalScrollElasticity:NSScrollElasticityNone];
        _addButton          = [self buttonWithImageNamed:@"NSAddTemplate" target:self action:@selector(add:)];
        _addButton.image.template = true;
        _addButton.focusRingType = NSFocusRingTypeNone;
        
        [_addButton setMenu:nil];
        NSDictionary *views = NSDictionaryOfVariableBindings(_scrollView, _addButton);
        
        [self setSubviews:@[_scrollView, _addButton]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scrollView]-(-1)-[_addButton]|" options:0 metrics:nil views:views]];
        
        for (NSView *view in views.allValues) {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": view}]];
        }
        
        [_addButton addConstraint:
         [NSLayoutConstraint constraintWithItem:_addButton attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                     multiplier:1 constant:24]];
        
        [_addButton.cell setBorderMask:[_addButton.cell borderMask] | LIBorderMaskRight|LIBorderMaskBottom|LIBorderMaskTop];
        
        [self startObservingScrollView];
        [self updateButtons];
    }
}

- (void)dealloc {
    [self stopObservingScrollView];
}

- (void)updateButtons {
    
}

- (NSButton *)buttonWithImageNamed:(NSString *)name target:(id)target action:(SEL)action {
    NSButton *button = [self viewWithClass:[NSButton class]];
    
    [button setCell:[[self cell] copy]];

    [button setTarget:target];
    [button setAction:action];
    
    [button setEnabled:action != NULL];
    
    [button setImagePosition:NSImageOnly];
    NSImage* image =[NSImage imageNamed:name];
    [image setTemplate:YES];
    [button setImage:image];
    [button setBezelStyle:NSShadowlessSquareBezelStyle];
    [button setBordered: YES];
    
    return button;
}

- (id)viewWithClass:(Class)clss {
    id view = [[clss alloc] initWithFrame:NSZeroRect];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    return view;
}

#pragma mark -
#pragma mark ScrollView Observation

static char LIScrollViewObservationContext;

- (void)startObservingScrollView {
    [self.scrollView addObserver:self forKeyPath:@"frame" options:0 context:&LIScrollViewObservationContext];
    [self.scrollView addObserver:self forKeyPath:@"documentView.frame" options:0 context:&LIScrollViewObservationContext];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewDidScroll:) name:NSViewBoundsDidChangeNotification object:self.scrollView.contentView];
}
- (void)stopObservingScrollView {
    [self.scrollView removeObserver:self forKeyPath:@"frame" context:&LIScrollViewObservationContext];
    [self.scrollView removeObserver:self forKeyPath:@"documentView.frame" context:&LIScrollViewObservationContext];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSViewBoundsDidChangeNotification object:self.scrollView.contentView];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == &LIScrollViewObservationContext) {
        [self updateButtons];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)scrollViewDidScroll:(NSNotification *)notification {
    [self updateButtons];
    [self invalidateRestorableState];
}

#pragma mark -
#pragma mark Properties

- (void)setBorderWidth:(CGFloat)borderWidth {
    [self.cell setBorderWidth:borderWidth];
    for (id subview in self.subviews) {
        if ([subview respondsToSelector:@selector(cell)]) {
            id cell = [subview cell];
            if ([cell respondsToSelector:@selector(setBorderWidth:)]) {
                [cell setBorderWidth:borderWidth];
            }
        }
    }
}

- (void)setBorderColor:(NSColor *)borderColor {
    [self.cell setBorderColor:borderColor];
    for (id subview in self.subviews) {
        if ([subview respondsToSelector:@selector(cell)]) {
            id cell = [subview cell];
            if ([cell respondsToSelector:@selector(setBorderColor:)]) {
                [cell setBorderColor:borderColor];
            }
        }
    }
}
- (void)setBackgroundColor:(NSColor *)backgroundColor {
    [self.cell setBackgroundColor:backgroundColor];
    for (id subview in self.subviews) {
        if ([subview respondsToSelector:@selector(cell)]) {
            id cell = [subview cell];
            if ([cell respondsToSelector:@selector(setBackgroundColor:)]) {
                [cell setBackgroundColor:backgroundColor];
            }
        }
    }
}
- (void)setTitleColor:(NSColor *)titleColor {
    [self.cell setTitleColor:titleColor];
    for (id subview in self.subviews) {
        if ([subview respondsToSelector:@selector(cell)]) {
            id cell = [subview cell];
            if ([cell respondsToSelector:@selector(setTitleColor:)]) {
                [cell setTitleColor:titleColor];
            }
        }
    }
}
- (void)setTitleHighlightColor:(NSColor *)titleHighlightColor {
    [self.cell setTitleHighlightColor:titleHighlightColor];
    for (id subview in self.subviews) {
        if ([subview respondsToSelector:@selector(cell)]) {
            id cell = [subview cell];
            if ([cell respondsToSelector:@selector(setTitleHighlightColor:)]) {
                [cell setTitleHighlightColor:titleHighlightColor];
            }
        }
    }
}

#pragma mark -
#pragma mark Actions

- (void)setAddAction:(SEL)addAction {
    if (_addAction != addAction) {
        _addAction = addAction;
        
        [self updateButtons];
    }
}

- (void)add:(id)sender {
    [[NSApplication sharedApplication] sendAction:self.addAction to:self.addTarget from:self];
    
    [self invalidateRestorableState];
}

- (void)goLeft:(id)sender {
    NSButton *tab = [self firstTabLeftOutsideVisibleRect];
    
    if (tab != nil) {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            [context setAllowsImplicitAnimation:YES];
            [tab scrollRectToVisible:[tab bounds]];
        } completionHandler:nil];
    }
}

- (NSButton *)firstTabLeftOutsideVisibleRect {
    NSView *tabView = self.scrollView.documentView;
    NSRect  visibleRect = tabView.visibleRect;
    
    for (NSButton *button in tabView.subviews) {
        if (NSMinX(button.frame) < NSMinX(visibleRect)) {
            return button;
        }
    }
    return nil;
}

- (void)goRight:(id)sender {
    NSButton *tab = [self firstTabRightOutsideVisibleRect];
    
    if (tab != nil) {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            [context setAllowsImplicitAnimation:YES];
            [tab scrollRectToVisible:[tab bounds]];
        } completionHandler:nil];
    }
}

- (NSButton *)firstTabRightOutsideVisibleRect {
    NSView *tabView = self.scrollView.documentView;
    NSRect  visibleRect = tabView.visibleRect;
    
    for (NSUInteger index = [[tabView subviews] count]; index > 0; index--) {
        NSButton *button = [[tabView subviews] objectAtIndex:index - 1];
        
        if (NSMaxX(button.frame) > NSMaxX(visibleRect)) {
            return button;
        }
    }
    return nil;
}

- (void)selectTab:(id)sender {
    NSButton *selectedButton = sender;
    
    for (NSButton *button in [self.scrollView.documentView subviews]) {
        [button setState:(button == selectedButton) ? 1 : 0];
    }
    
    [[NSApplication sharedApplication] sendAction:self.action to:self.target from:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:LITabControlSelectionDidChangeNotification object:self];
    
    NSEvent *currentEvent = [NSApp currentEvent];
    
    if (currentEvent.clickCount > 1) {
        // edit on double click...
        [self editItem:[[sender cell] representedObject]];
        
    } else if ([self.dataSource tabControl:self canReorderItem:[[sender cell] representedObject]]) {
        // watch for a drag event and initiate dragging if a drag is found...
        if ([self.window nextEventMatchingMask:NSLeftMouseUpMask|NSLeftMouseDraggedMask untilDate:[NSDate distantFuture] inMode:NSEventTrackingRunLoopMode dequeue:NO].type == NSLeftMouseDragged) {
            [self reorderTab:sender withEvent:currentEvent];
            return; // no autoscroll
        }
    }
    
    // scroll to visible if either editing or selecting...
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [context setAllowsImplicitAnimation:YES];
        [selectedButton.superview scrollRectToVisible:selectedButton.frame];
    } completionHandler:nil];
    
    [self invalidateRestorableState];
}

#pragma mark -
#pragma mark Reordering

- (void)reorderTab:(NSButton *)tab withEvent:(NSEvent *)event {
    // note existing tabs which will be reordered over
    // the course of our drag; while the dragging tab maintains
    // its position over the course of the dragging operation
    
    NSView          *tabView        = self.scrollView.documentView;
    NSMutableArray  *orderedTabs    = [[NSMutableArray alloc] initWithArray:tabView.subviews.reverseObjectEnumerator.allObjects];
    
    // create a dragging tab used to represent our drag,
    // and constraint its position and its size; the first
    // constraint sets position - we'll be varying this one
    // during our drag...
    
    CGFloat   tabX                  = NSMinX(tab.frame);
    NSPoint   dragPoint             = [tabView convertPoint:event.locationInWindow fromView:nil];
    
    
    NSButton *draggingTab           = [self tabWithItem:[tab.cell representedObject]];
    
    NSArray  *draggingConstraints   = @[[NSLayoutConstraint constraintWithItem:draggingTab attribute:NSLayoutAttributeLeading
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:tabView attribute:NSLayoutAttributeLeading
                                                                    multiplier:1 constant:tabX],                                // VARIABLE
                                        
                                        [NSLayoutConstraint constraintWithItem:draggingTab attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:tabView attribute:NSLayoutAttributeTop
                                                                    multiplier:1 constant:0],                                   // CONSTANT
                                        [NSLayoutConstraint constraintWithItem:draggingTab attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:tabView attribute:NSLayoutAttributeBottom
                                                                    multiplier:1 constant:0]];                                  // CONSTANT
    
    
    draggingTab.cell = [tab.cell copy];
    
    // cell subclasses may alter drawing based on represented object
    [draggingTab.cell setRepresentedObject:[tab.cell representedObject]];
    
    // the presence of a menu affects the vertical offset of our title
    if ([tab.cell menu] != nil) [draggingTab.cell setMenu:[[NSMenu alloc] init]];
    
    
    [tabView addSubview:draggingTab];
    [tabView addConstraints:draggingConstraints];
    
    [tab setHidden:YES];
    
    CGPoint prevPoint = dragPoint;
    BOOL    dragged = NO, reordered = NO;
    
    while (1) {
        event = [self.window nextEventMatchingMask:NSLeftMouseDraggedMask|NSLeftMouseUpMask];
        
        if (event.type == NSLeftMouseUp) break;
        
        // ensure the dragged tab shows borders on both of its sides when dragging
        if (dragged == NO && event.type == NSLeftMouseDragged) {
            dragged = YES;
            
            LITabCell *cell = draggingTab.cell;
            cell.borderMask = cell.borderMask | LIBorderMaskLeft | LIBorderMaskRight;
        }
        
        // move the dragged tab
        NSPoint nextPoint = [tabView convertPoint:event.locationInWindow fromView:nil];
        
        CGFloat nextX = tabX + (nextPoint.x - dragPoint.x);
        
        BOOL    movingLeft = (nextPoint.x < prevPoint.x);
        BOOL    movingRight = (nextPoint.x > prevPoint.x);
        
        prevPoint = nextPoint;
        
        [draggingConstraints[0] setConstant:nextX];
        
        // test for reordering...
        if (movingLeft && NSMidX(draggingTab.frame) < NSMinX(tab.frame) && tab != orderedTabs.firstObject) {
            // shift left
            NSUInteger index = [orderedTabs indexOfObject:tab];
            [orderedTabs exchangeObjectAtIndex:index withObjectAtIndex:index - 1];
            
            [self layoutTabs:orderedTabs inView:tabView];
            [tabView addConstraints:draggingConstraints];
            
            if (self.notifiesOnPartialReorder) {
                [self.dataSource tabControlDidReorderItems:self orderedItems:[orderedTabs valueForKeyPath:@"cell.representedObject"]];
            }
            
            reordered = YES;
            
        } else if (movingRight && NSMidX(draggingTab.frame) > NSMaxX(tab.frame) && tab != orderedTabs.lastObject) {
            // shift right
            NSUInteger index = [orderedTabs indexOfObject:tab];
            [orderedTabs exchangeObjectAtIndex:index+1 withObjectAtIndex:index];
            
            [self layoutTabs:orderedTabs inView:tabView];
            [tabView addConstraints:draggingConstraints];
            
            if (self.notifiesOnPartialReorder) {
                [self.dataSource tabControlDidReorderItems:self orderedItems:[orderedTabs valueForKeyPath:@"cell.representedObject"]];
            }
            
            reordered = YES;
        }
        
        [tabView layoutSubtreeIfNeeded];
    }
    
    [draggingTab removeFromSuperview];
    draggingTab = nil;
    
    [tabView removeConstraints:draggingConstraints];
    
    [tab setHidden:NO];
    [tab.cell setControlView:tab];
    
    if (reordered) {
        if (!self.notifiesOnPartialReorder) {
            [self.dataSource tabControlDidReorderItems:self orderedItems:[orderedTabs valueForKeyPath:@"cell.representedObject"]];
        }
        
        [self reloadData];
        
        [self setSelectedItem:[tab.cell representedObject]];
    }
}

#pragma mark -
#pragma mark Selection

- (id)selectedItem {
    for (NSButton *button in [self.scrollView.documentView subviews]) {
        if ([button state] == 1) {
            return [[button cell] representedObject];
        }
    }
    return nil;
}
- (void)setSelectedItem:(id)selectedItem {
    for (NSButton *button in [self.scrollView.documentView subviews]) {
        if ([[[button cell] representedObject] isEqual:selectedItem]) {
            [button setState:1];
            
            [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                [context setAllowsImplicitAnimation:YES];
                [button scrollRectToVisible:[button bounds]];
            } completionHandler:nil];
            
        } else {
            [button setState:0];
        }
    }
    
    [self invalidateRestorableState];
}

#pragma mark -
#pragma mark Data Source

- (void)setDataSource:(id<LITabDataSource>)dataSource {
    if (_dataSource != dataSource) {
        
        if (_dataSource && [_dataSource respondsToSelector:@selector(tabControlDidChangeSelection:)])
            [[NSNotificationCenter defaultCenter] removeObserver:_dataSource name:LITabControlSelectionDidChangeNotification object:self];
        
        _dataSource = dataSource;
        
        if (_dataSource && [_dataSource respondsToSelector:@selector(tabControlDidChangeSelection:)])
            [[NSNotificationCenter defaultCenter] addObserver:_dataSource selector:@selector(tabControlDidChangeSelection:) name:LITabControlSelectionDidChangeNotification object:self];
        
        [self reloadData];
    }
}

- (void)reloadData {
    NSView *tabView = [self viewWithClass:[NSView class]];
    NSMutableArray *newItems = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = 0, count = [self.dataSource tabControlNumberOfTabs:self]; i < count; i++) {
        [newItems addObject:[self.dataSource tabControl:self itemAtIndex:i]];
    }
    
    NSMutableArray *newTabs = [[NSMutableArray alloc] init];
    
    for (id item in newItems) {
        NSButton  *button     = [self tabWithItem:item];
        LITabCell *buttonCell = [button cell];
        
        // NOTE: menus are dynamic, but we indicate their presence by associating a menu
        // with the button cell...
        
        NSMenu *menu = [self.dataSource tabControl:self menuForItem:item];
        if (menu != nil) {
            [buttonCell setMenu:[[NSMenu alloc] init]];
            [button addTrackingArea:[[NSTrackingArea alloc] initWithRect:_scrollView.bounds
                                                                 options:NSTrackingMouseEnteredAndExited|NSTrackingActiveInActiveApp|NSTrackingInVisibleRect
                                                                   owner:self
                                                                userInfo:@{@"item" : item}]];
        }
        
        [newTabs addObject:button];
    }
    
    [tabView setSubviews:newTabs.reverseObjectEnumerator.allObjects];
    [self layoutTabs:newTabs inView:tabView];
    
    self.items = newItems;
    self.scrollView.documentView = (self.items.count) ? tabView : nil;
    [self.scrollView.layer setBorderWidth:0];
    [self.scrollView.layer setBorderColor:[NSColor colorWithCalibratedWhite:0.75f alpha:0.0f].CGColor];
    
    if (self.scrollView.documentView) {
        NSClipView *clipView = self.scrollView.contentView;
        NSView *documentView = self.scrollView.documentView;
        [documentView.layer setBorderWidth:0];
        [documentView.layer setBorderColor:[NSColor colorWithCalibratedWhite:0.75f alpha:0.0f].CGColor];
        // document content is as tall as our scrolling area, and at least as wide...
        
        [clipView addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[documentView]|"
                                                 options:0
                                                 metrics:nil
                                                   views:@{@"documentView": documentView}]];
        
        [clipView addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[documentView]"
                                                 options:0
                                                 metrics:nil
                                                   views:@{@"documentView": documentView}]];
        
        // here's the 'at least as wide' constraint...
        
        [clipView addConstraint:
         [NSLayoutConstraint constraintWithItem:documentView attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationGreaterThanOrEqual
                                         toItem:clipView attribute:NSLayoutAttributeRight
                                     multiplier:1 constant:0]];
    }
    
    [self updateButtons];
    
    [self invalidateRestorableState];
}

- (void)layoutTabs:(NSArray *)tabs inView:(NSView *)tabView {
    // remove old constraints, if any...
    [tabView removeConstraints:tabView.constraints];
    
    // constrain passed tabs into a horizontal list...
    NSButton *prev = nil;
    for (NSButton *button in tabs) {
        [tabView addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button]|" options:0 metrics:nil views:@{@"button":button}]];
        
        [tabView addConstraint:
         [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeading
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:(prev != nil ? prev : tabView)
                                      attribute:(prev != nil ? NSLayoutAttributeTrailing : NSLayoutAttributeLeading)
                                     multiplier:1 constant:prev!=nil ? -1 : -.5]];
        prev = button;
    }
    
    if (prev) {
        NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:prev attribute:NSLayoutAttributeTrailing
                                                                              relatedBy:NSLayoutRelationLessThanOrEqual
                                                                                 toItem:tabView attribute:NSLayoutAttributeTrailing
                                                                             multiplier:1 constant:0];
        [trailingConstraint setPriority:NSLayoutPriorityWindowSizeStayPut];
        [tabView addConstraint:trailingConstraint];
    }
    
    [tabView layoutSubtreeIfNeeded];
}

- (LITabButton *)tabWithItem:(id)item {
    LITabCell   *tabCell    = [self.cell copy];
    
    tabCell.representedObject = item;
    
    tabCell.imagePosition   = NSNoImage;
    tabCell.borderMask      = LIBorderMaskLeft | LIBorderMaskRight|LIBorderMaskBottom;
    
    tabCell.title           = [self.dataSource tabControl:self titleForItem:item];
    
    tabCell.target          = self;
    tabCell.action          = @selector(selectTab:);
    
    [tabCell sendActionOn:NSLeftMouseDownMask];
    
    LITabButton *tab        = [self viewWithClass:[self.class tabButtonClass]];
    
    [tab setCell:tabCell];
    
    if ([self.dataSource respondsToSelector:@selector(tabControl:canSelectItem:)]) {
        [[tab cell] setSelectable:[self.dataSource tabControl:self canSelectItem:item]];
    }
    
    if ([self.dataSource respondsToSelector:@selector(tabControl:willDisplayButton:forItem:)]) {
        [self.dataSource tabControl:self willDisplayButton:tab forItem:item];
    }
    
    return tab;
}

#pragma mark -
#pragma mark Tab Buttons

+ (Class)tabButtonClass {
    return [LITabButton class];
}

- (NSArray *)tabButtons {
    NSMutableArray *buttons = @[].mutableCopy;
    
    for (NSButton *button in [self.scrollView.documentView subviews]) {
        if (button != self.draggingTab) {
            [buttons addObject:button];
        }
    }
    return buttons;
}

- (NSButton *)tabButtonWithItem:(id)item {
    for (NSButton *button in [self.scrollView.documentView subviews]) {
        if (button != self.draggingTab) {
            if ([[[button cell] representedObject] isEqual:item]) {
                return button;
            }
        }
    }
    return nil;
}

#pragma mark -
#pragma mark ScrollView Tracking

- (NSButton *)trackedButtonWithEvent:(NSEvent *)theEvent {
    id item = theEvent.trackingArea.userInfo[@"item"];
    return (item != nil) ? [self tabButtonWithItem:item] : nil;
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [[[self trackedButtonWithEvent:theEvent] cell] setShowsMenu:YES];
}
- (void)mouseExited:(NSEvent *)theEvent {
    [[[self trackedButtonWithEvent:theEvent] cell] setShowsMenu:NO];
}

#pragma mark -
#pragma mark Editing

- (void)editItem:(id)item {
    NSButton *button = [self tabButtonWithItem:item];
    
    // end existing editing, if any...
    if (self.editingField != nil) {
        [self.window makeFirstResponder:self];
    }
    
    // layout items if necessary
    [self layoutSubtreeIfNeeded];
    
    if (button != nil) {
        if ([self.dataSource respondsToSelector:@selector(tabControl:canEditItem:)] && [self.dataSource tabControl:self canEditItem:item] == NO) {
            return;
        }
        
        LITabCell *cell = button.cell;
        NSRect titleRect = [cell editingRectForBounds:button.bounds];
        
        self.editingField = [[NSTextField alloc] initWithFrame:titleRect];
        
        self.editingField.editable = YES;
        self.editingField.font = cell.font;
        self.editingField.alignment = cell.alignment;
        self.editingField.backgroundColor = cell.backgroundColor;
        self.editingField.focusRingType = NSFocusRingTypeNone;
        
        self.editingField.textColor = [[NSColor darkGrayColor] blendedColorWithFraction:0.5 ofColor:[NSColor blackColor]];
        
        NSTextFieldCell *textFieldCell = self.editingField.cell;
        
        [textFieldCell setBordered:NO];
        [textFieldCell setScrollable:YES];
        
        self.editingField.stringValue = button.title;
        
        [button addSubview:self.editingField];
        
        self.editingField.delegate = self;
        [self.editingField selectText:self];
    }
}

#pragma mark -
#pragma mark NSTextFieldDelegate

- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor {
    BOOL ret = YES;
    if ([_delegate respondsToSelector:_cmd]) {
        ret = [_delegate control:self textShouldBeginEditing:fieldEditor];
    }
    return ret;
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor {
    BOOL ret = YES;
    if ([_delegate respondsToSelector:_cmd]) {
        ret = [_delegate control:self textShouldEndEditing:fieldEditor];
    }
    return ret;
}

- (BOOL)control:(NSControl *)control didFailToFormatString:(NSString *)string errorDescription:(NSString *)error {
    BOOL ret = YES;
    if ([_delegate respondsToSelector:_cmd]) {
        ret = [_delegate control:self didFailToFormatString:string errorDescription:error];
    }
    return ret;
}

- (void)control:(NSControl *)control didFailToValidatePartialString:(NSString *)string errorDescription:(NSString *)error {
    if ([_delegate respondsToSelector:_cmd]) {
        [_delegate control:self didFailToValidatePartialString:string errorDescription:error];
    }
}

- (BOOL)control:(NSControl *)control isValidObject:(id)obj {
    BOOL ret = YES;
    if ([_delegate respondsToSelector:_cmd]) {
        ret = [_delegate control:self isValidObject:obj];
    }
    return ret;
}

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector {
    BOOL ret = NO;
    if ([_delegate respondsToSelector:_cmd]) {
        ret = [_delegate control:self textView:textView doCommandBySelector:commandSelector];
    }
    return ret;
}

- (NSArray *)control:(NSControl *)control textView:(NSTextView *)textView completions:(NSArray *)words forPartialWordRange:(NSRange)charRange indexOfSelectedItem:(NSInteger *)index {
    NSArray *ret = nil;
    if ([_delegate respondsToSelector:_cmd]) {
        
    }
    return ret;
}

- (void)controlTextDidChange:(NSNotification *)obj {
    [[NSNotificationCenter defaultCenter] postNotificationName:obj.name object:self userInfo:obj.userInfo];
}

- (void)controlTextDidBeginEditing:(NSNotification *)obj {
    [[NSNotificationCenter defaultCenter] postNotificationName:obj.name object:self userInfo:obj.userInfo];
}

- (void)controlTextDidEndEditing:(NSNotification *)obj {
    NSString *title = self.editingField.stringValue;
    NSButton *button = (id)[self.editingField superview];
    
    self.editingField.delegate = nil;
    [self.editingField removeFromSuperview];
    self.editingField = nil;
    
    if (title.length > 0) {
        [button setTitle:title];
        
        [self.dataSource tabControl:self setTitle:title forItem:[button.cell representedObject]];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:obj.name object:self userInfo:obj.userInfo];
}

#pragma mark -
#pragma mark Drawing

- (BOOL)isOpaque {
    return NO;
}
- (BOOL)isFlipped {
    return YES;
}

#pragma mark -
#pragma mark State Restoration

// NOTE: to enable state restoration, be sure to either assign an identifier to
// the LITabControl instance within IB or, if the control is created programmatically,
// prior to adding it to your window's view hierarchy.

#define kScrollXOffsetKey @"scrollOrigin"
#define kSelectedButtonIndexKey @"selectedButtonIndex"

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    
    CGFloat scrollXOffset = 0;
    NSUInteger selectedButtonIndex = NSNotFound;
    
    scrollXOffset = self.scrollView.contentView.bounds.origin.x;
    
    NSUInteger index = 0;
    for (NSButton *button in [self.scrollView.documentView subviews]) {
        if (button.state == 1) {
            selectedButtonIndex = index;
            break;
        }
        index += 1;
    }
    
    [coder encodeDouble:scrollXOffset forKey:kScrollXOffsetKey];
    [coder encodeInteger:selectedButtonIndex forKey:kSelectedButtonIndexKey];
}

- (void)restoreStateWithCoder:(NSCoder *)coder {
    [super restoreStateWithCoder:coder];
    
    CGFloat scrollXOffset = [coder decodeDoubleForKey:kScrollXOffsetKey];
    NSUInteger selectedButtonIndex = [coder decodeIntegerForKey:kSelectedButtonIndexKey];
    
    NSRect bounds = self.scrollView.contentView.bounds; bounds.origin.x = scrollXOffset;
    self.scrollView.contentView.bounds = bounds;
    
    NSUInteger index = 0;
    for (NSButton *button in [self.scrollView.documentView subviews]) {
        if (index == selectedButtonIndex) {
            [button setState:1];
        } else {
            [button setState:0];
        }
        index += 1;
    }
}

@end

NSString *LITabControlSelectionDidChangeNotification = @"LITabControlSelectionDidChangeNotification";
