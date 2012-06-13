//
//  CCPullNavigator.m
//
//  Created by Christopher Constable on 6/8/12.
//  Copyright (c) 2012 Christopher Constable. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software 
// and associated documentation files (the "Software"), to deal in the Software without restriction, 
// including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
// and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, 
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial 
// portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT 
// NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "CCPullNavigation.h"
#import "CCDefaultLoaderViewController.h"
#import "UIView+FindUIViewController.h"

@interface CCPullNavigation ()
@property (atomic) BOOL isLoadingData;
@property (atomic) BOOL isResetting;
- (void)updatePreviousLoaderViewControllerFrame;
- (void)updateNextLoaderViewControllerFrame;
- (void)lockScrollViewForLoading;
@end

@implementation CCPullNavigation

@synthesize isLoadingData                   = _isLoadingData;
@synthesize isResetting                     = _isResetting;
@synthesize delegate                        = _delegate;
@synthesize scrollView                      = _scrollView;
@synthesize previousLoaderViewController    = _previousLoaderViewController;
@synthesize previousLoaderDirection         = _previousLoaderDirection;
@synthesize previousLoaderReadyOffset       = _previousLoaderReadyOffset;
@synthesize nextLoaderViewController        = _nextLoaderViewController;
@synthesize nextLoaderDirection             = _nextLoaderDirection;
@synthesize nextLoaderReadyOffset           = _nextLoaderReadyOffset;

- (id)initWithScrollView:(UIScrollView *)scrollView andDelegate:(id<CCPullNavigationDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.scrollView = scrollView;
        self.previousLoaderDirection = CCNavigationDirectionUp;
        self.previousLoaderViewController = [[CCDefaultLoaderViewController alloc] initWithNibName:@"CCDefaultLoaderPreviousViewController" bundle:nil];
        self.nextLoaderDirection = CCNavigationDirectionDown;
        self.nextLoaderViewController = [[CCDefaultLoaderViewController alloc] initWithNibName:@"CCDefaultLoaderNextViewController" bundle:nil];
    }
    
    return self;
}

- (void)setScrollView:(UIScrollView *)scrollView {
	void *context = (__bridge void *)self;
    
    // Remove any observers on old scroll views.
	if ([_scrollView respondsToSelector:@selector(removeObserver:forKeyPath:context:)]) {
		[_scrollView removeObserver:self forKeyPath:@"contentOffset" context:context];
        [_scrollView removeObserver:self forKeyPath:@"contentSize" context:context];
    } 
    else if (_scrollView) {
		[_scrollView removeObserver:self forKeyPath:@"contentOffset"];
        [_scrollView removeObserver:self forKeyPath:@"contentSize"];
	}
	
	_scrollView = scrollView;	
	[_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:context];
    [_scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:context];
}

- (void)setPreviousLoaderViewController:(UIViewController<CCPullNavigationViewController> *)previousLoaderViewController
{
    // Remove the current view controller if necessary.
    if (_previousLoaderViewController != nil) {
        [_previousLoaderViewController removeFromParentViewController];
        [_previousLoaderViewController.view removeFromSuperview];
    }
    
    // If the new VC is nil just set the property and return.
    if (previousLoaderViewController == nil) {
        _previousLoaderViewController = previousLoaderViewController;
        return;
    }
    
    _previousLoaderViewController = previousLoaderViewController;
    [self updatePreviousLoaderViewControllerFrame];
    
    // Set the "ready to load" offset.
    if ((_previousLoaderDirection == CCNavigationDirectionUp) || (_previousLoaderDirection == CCNavigationDirectionDown)) {
        _previousLoaderReadyOffset = _previousLoaderViewController.view.frame.size.height * 0.75;
    }
    else {
        _previousLoaderReadyOffset = _previousLoaderViewController.view.frame.size.width * 0.75;
    }  
    
    // Use our UIView category magic to find the view controller of the scroll view.
    [[self.scrollView firstAvailableUIViewController] addChildViewController:_previousLoaderViewController];
    [self.scrollView addSubview:_previousLoaderViewController.view];
}

- (void)updatePreviousLoaderViewControllerFrame
{
    // Create the frame based on which side should be pulled to load "previous" data.
    CGRect previousViewFrame = self.previousLoaderViewController.view.frame;
    
    if (self.previousLoaderDirection == CCNavigationDirectionUp) {
        previousViewFrame.origin.y = (-previousViewFrame.size.height);
    }
    else if (self.previousLoaderDirection == CCNavigationDirectionDown) {
        // TODO: Support other directions in the future.
    }
    else if (self.previousLoaderDirection == CCNavigationDirectionLeft) {
        // TODO: Support other directions in the future.
    }
    else if (self.previousLoaderDirection == CCNavigationDirectionRight) {
        // TODO: Support other directions in the future.
    }
    
    self.previousLoaderViewController.view.frame = previousViewFrame;
}

- (void)setPreviousLoaderDirection:(CCNavigationDirection)previousLoaderDirection
{
    // TODO: This is where code would go to support loading "previous" data from
    // different directions in the future.
    _previousLoaderDirection = previousLoaderDirection;
}

- (void)setNextLoaderViewController:(UIViewController<CCPullNavigationViewController> *)nextLoaderViewController
{
    // Remove the current view controller if necessary.
    if (_nextLoaderViewController != nil) {
        [_nextLoaderViewController removeFromParentViewController];
        [_nextLoaderViewController.view removeFromSuperview];
    }
    
    // If the new VC is nil just set the property and return.
    if (nextLoaderViewController == nil) {
        _nextLoaderViewController = nextLoaderViewController;
        return;
    }
    
    _nextLoaderViewController = nextLoaderViewController;    
    [self updateNextLoaderViewControllerFrame];

    // Set the "ready to load" offset.
    if ((_nextLoaderDirection == CCNavigationDirectionUp) || (_nextLoaderDirection == CCNavigationDirectionDown)) {
        _nextLoaderReadyOffset = _nextLoaderViewController.view.frame.size.height * 0.75;
    }
    else {
        _nextLoaderReadyOffset = _nextLoaderViewController.view.frame.size.width * 0.75;
    }    
    
    // Use our UIView category magic to find the view controller of the scroll view.
    [[self.scrollView firstAvailableUIViewController] addChildViewController:_nextLoaderViewController];
    [self.scrollView addSubview:_nextLoaderViewController.view];
}

- (void)updateNextLoaderViewControllerFrame
{
    // Create the frame based on which side should be pulled to load "next" data.
    CGRect nextViewFrame = _nextLoaderViewController.view.frame;
    
    if (self.nextLoaderDirection == CCNavigationDirectionUp) {
        // TODO: Support other directions in the future.
    }
    else if (self.nextLoaderDirection == CCNavigationDirectionDown) {
        nextViewFrame.origin.y = self.scrollView.contentSize.height;
    }
    else if (self.nextLoaderDirection == CCNavigationDirectionLeft) {
        // TODO: Support other directions in the future.
    }
    else if (self.nextLoaderDirection == CCNavigationDirectionRight) {
        // TODO: Support other directions in the future.
    }
    
    self.nextLoaderViewController.view.frame = nextViewFrame;
}

- (void)setNextLoaderDirection:(CCNavigationDirection)nextLoaderDirection
{
    // TODO: This is where code would go to support loading "next" data from
    // different directions in the future.
    _nextLoaderDirection = nextLoaderDirection;
}

- (void)loadingDidFinish
{
    if (self.previousLoaderViewController) {
        [self.previousLoaderViewController loadingDidFinish];
    }
    if (self.nextLoaderViewController) {
        [self.nextLoaderViewController loadingDidFinish];
    }
    
    self.isLoadingData = NO;
    self.isResetting = YES;
}

#pragma mark - KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    //
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // TODO: This method will need to be re-worked significantly to support other configurations.
    // This is a sub-optimal implementation just get things up and running.
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    //
    
    static CGFloat lastContentOffset = 0.0;
    
	// Make sure we are observing this value.
	if (context != (__bridge void *)self) {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
		return;
	}
    
    // If the scroll view's content size changed, move the appropriate VC.
    if ((object == self.scrollView) && 
        ([keyPath isEqualToString:@"contentSize"] == YES)) {
        [self updateNextLoaderViewControllerFrame];
        return;
    }
    
    // If either "previous" or "next" VC is in a "loading" state we don't need to do anything.
    if (self.isLoadingData) {
        return;
    }
	
	// Make sure we are getting the scroll view and it's content offset.
	if ((object != self.scrollView) || 
        ([keyPath isEqualToString:@"contentOffset"] == NO)) {
		return;
	}
    
    // Lastly, check to see if the scroll view is resetting from loading.
    // If so, allow it to return to it's "reset" state before continuing.
    CGFloat contentOffset = self.scrollView.contentOffset.y;
    CGFloat maxScrollOffset = self.scrollView.contentSize.height - self.scrollView.frame.size.height;
    if (self.isResetting) {
        if ((contentOffset >= 0) && (contentOffset <= maxScrollOffset)) {
            self.isResetting = NO;
            [self.scrollView setUserInteractionEnabled:YES];
        }
        else {
            return;
        }
    }
    
    // If the user is dragging is the scroll view, check to see if we need to change it's state.
	if (self.scrollView.isDragging) {
        
        if ((contentOffset <= 0) && self.previousLoaderViewController) {
            
            // Previous "Resting" -> "Shown (normal)"
            if ((lastContentOffset >= 0) &&
                (self.previousLoaderViewController.pullState != CCNavigationViewStateShown)) {
                [self.previousLoaderViewController pullNavigationViewShouldChangeState:CCNavigationViewStateShown];
            }
            
            // Previous "Shown (normal)" -> "Ready to Load"
            else if ((contentOffset <= (-self.previousLoaderReadyOffset)) && 
                     (lastContentOffset > (-self.previousLoaderReadyOffset)) &&
                     (self.previousLoaderViewController.pullState != CCNavigationViewStateReadyToLoad)) {
                [self.previousLoaderViewController pullNavigationViewShouldChangeState:CCNavigationViewStateReadyToLoad];
            }
            
            // Previous "Ready to Load" -> "Shown (normal)"
            else if ((contentOffset > (-self.previousLoaderReadyOffset)) &&
                     (lastContentOffset < (-self.previousLoaderReadyOffset)) &&
                     (self.previousLoaderViewController.pullState != CCNavigationViewStateShown)) {
                [self.previousLoaderViewController pullNavigationViewShouldChangeState:CCNavigationViewStateShown];
            }
        }
        
        if ((contentOffset >= maxScrollOffset) && self.nextLoaderViewController) {
            
            // Next "Shown (normal)" -> "Ready to Load"
            if (contentOffset > (maxScrollOffset + self.nextLoaderReadyOffset) &&
                (self.nextLoaderViewController.pullState != CCNavigationViewStateReadyToLoad)) {
                [self.nextLoaderViewController pullNavigationViewShouldChangeState:CCNavigationViewStateReadyToLoad];
            }
            
            // Next "Resting" -> "Shown (normal)"
            else if ((contentOffset > maxScrollOffset) 
                     && (lastContentOffset <= maxScrollOffset) &&
                     (self.nextLoaderViewController.pullState != CCNavigationViewStateShown)) {
                [self.nextLoaderViewController pullNavigationViewShouldChangeState:CCNavigationViewStateShown];
            }
            
            // Next "Ready to Load" -> "Shown (normal)"
            else if ((contentOffset < (maxScrollOffset + self.nextLoaderReadyOffset)) && 
                (lastContentOffset >= (maxScrollOffset + self.nextLoaderReadyOffset)) &&
                (self.nextLoaderViewController.pullState != CCNavigationViewStateShown)) {
                [self.nextLoaderViewController pullNavigationViewShouldChangeState:CCNavigationViewStateShown];
            }
        }
	}
    
    // If the user released the drag on the scroll view...
    else {
        if (contentOffset >= 0) {
            
            // Set the previous VC to "Resting" if necessary.
            if (self.previousLoaderViewController && 
                (self.previousLoaderViewController.pullState != CCNavigationViewStateResting)) {
                [self.previousLoaderViewController pullNavigationViewShouldChangeState:CCNavigationViewStateResting];
            }
            
            // Set the next VC to "Resting" if necessary.
            if (self.nextLoaderViewController && 
                (contentOffset <= maxScrollOffset) &&
                (self.nextLoaderViewController.pullState != CCNavigationViewStateResting)) {
                [self.nextLoaderViewController pullNavigationViewShouldChangeState:CCNavigationViewStateResting];
            }
            
            // Check to see if we need to set the next VC to an active state.
            else if (self.nextLoaderViewController && (contentOffset > maxScrollOffset)) {
    
                // Set the next VC to "Loading" if necessary.
                if ((contentOffset > (maxScrollOffset + self.nextLoaderReadyOffset)) && 
                    (self.nextLoaderViewController.pullState != CCNavigationViewStateLoading)) {
                    [self lockScrollViewForLoading];
                    [self.nextLoaderViewController pullNavigationViewShouldChangeState:CCNavigationViewStateLoading];
                    [self.delegate scrollView:self.scrollView didLoadNextWithLoader:self.nextLoaderViewController];
                }
            }
        }
        
        // Set the previous VC to "Loading" if necessary.
        else if (self.previousLoaderViewController && 
                 (contentOffset < (-self.previousLoaderReadyOffset)) && 
                 (self.previousLoaderViewController.pullState != CCNavigationViewStateLoading)) {
            [self lockScrollViewForLoading];
            [self.previousLoaderViewController pullNavigationViewShouldChangeState:CCNavigationViewStateLoading];
            [self.delegate scrollView:self.scrollView didLoadPreviousWithLoader:self.previousLoaderViewController];
        }
    }
    
    lastContentOffset = contentOffset;
}

- (void)lockScrollViewForLoading
{
    [self.scrollView setUserInteractionEnabled:NO];
    self.isLoadingData = YES;
}

@end
