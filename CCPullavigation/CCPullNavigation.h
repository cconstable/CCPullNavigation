//
//  CCPullNavigator.h
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

#import <UIKit/UIKit.h>
#import "CCPullNavigationViewController.h"


/**
 This enum defines the directions in which "next" or "previous" data can be loaded.
 By default, the "previous" data direction is CCNavigationDirectionUp and the "next"
 data direction is CCNavigationDirectionDown.
 
 NOTE: Currently only CCNavigationDirectionUp and CCNavigationDirection down are supported.
 I have no plans to support left/right ATM but I added the enum in case someone in the future
 wants to add support for them.
 */
typedef enum {
    CCNavigationDirectionUp,    ///< Pulling down from the top.
    CCNavigationDirectionDown,  ///< Pulling up from the bottom.
    CCNavigationDirectionLeft,  ///< Pulling right from the left side.
    CCNavigationDirectionRight  ///< Pulling left from the right side.
} CCNavigationDirection;


/**
 The object that adheres to this protocol will receive messages when the scroll view
 needs to load "next" or "previous" data. This protocol is generally implemented by
 the view controller that contains the scroll view.
 */
@protocol CCPullNavigationDelegate <NSObject>
@required

/**
 Called when the scroll view was pulled far enough to load "previous data".
 @param scrollView The scroll view was used to initialize the CCPullNavigation object.
 @param loaderVC The scroll view was used to initialize the CCPullNavigation object.
 */
- (void)scrollView:(UIScrollView *)scrollView didLoadPreviousWithLoader:(UIViewController<CCPullNavigationViewController> *)loaderVC;

/**
 Called when the scroll view was pulled far enough to load "next data".
 @param scrollView The scroll view was used to initialize the CCPullNavigation object.
 */
- (void)scrollView:(UIScrollView *)scrollView didLoadNextWithLoader:(UIViewController<CCPullNavigationViewController> *)loaderVC;

@optional

/**
 This optional method allows the delegate to receive more detailed information about the
 navigation. 
 
 @param scrollView The scroll view was used to initialize the CCPullNavigation object.
 @param navigationView The navigation view that changed state. @see CCPullNavigationView
 @param navigationState The new state of the navigation view.
 */
- (void)scrollView:(UIScrollView *)scrollView 
    navigationView:(UIViewController<CCPullNavigationViewController> *)navigationViewController 
     didEnterState:(CCNavigationViewState)navigationState;

@end


/**
 CCPullNavigation handles all the logic for adding "pull navigation" to a scroll view.
 CCPullNavigation is initialized with a UIScrollView (or UIScrollView subclass), then it adds it's 
 CCPullNavigationViewControllers (previousLoaderViewController and nextLoaderViewController) 
 to their respective edges of the scroll view. It notifies the CCPullNavigationViews when a 
 user is pulling allowing them to animate, etc. Finally, when the user has pulled far enough 
 to "load" the CCPullNavigation object sends it's delegate a message.
 */
@interface CCPullNavigation : NSObject

/**
 CCPullNavigationDelegate delegate. @see CCPullNavigationDelegate
 */
@property (weak, nonatomic) id<CCPullNavigationDelegate> delegate;

/**
 Scroll view that will have "pull navigation" added to it.
 */
@property (weak, nonatomic) UIScrollView *scrollView;

/**
 CCPullNavigationViewController that controls the view that should be shown when the user pulls
 to navigate to a "previous" view or data set.
 */
@property (strong, nonatomic) UIViewController<CCPullNavigationViewController> *previousLoaderViewController;

/**
 This indicates what side of the screen should be pulled to load "previous" data.
 This defaults to CCNavigationDirectionUp.
 
 @see CCNavigationDirection
 */
@property (nonatomic) CCNavigationDirection previousLoaderDirection;

/**
 This is the distance (in pts.) that the user needs to pull to put the previousLoaderViewController
 in a "ready to load" state. This defaults to 75% of the previousLoaderViewController's view height (or
 width, whichever is appropriate for its position).
 */
@property (nonatomic) CGFloat previousLoaderReadyOffset;

/**
 CCPullNavigationViewController that controls the view that should be shown when the user pulls
 to navigate to a "next" view or data set.
 */
@property (strong, nonatomic) UIViewController<CCPullNavigationViewController> *nextLoaderViewController;

/**
 This indicates what side of the screen should be pulled to load "next" data.
 This defaults to CCNavigationDirectionDown.
 
 @see CCNavigationDirection
 */
@property (nonatomic) CCNavigationDirection nextLoaderDirection;

/**
 This is the distance (in pts.) that the user needs to pull to put the nextLoaderViewController
 in a "ready to load" state. This defaults to 75% of the loadNextViewController's view height (or
 width, whichever is appropriate for its position).
 */
@property (nonatomic) CGFloat nextLoaderReadyOffset;

/**
 This is THE designator initializer. Use this to initialize the CCPullNavigation object.
 
 @param scrollView The scroll view that will have "pull navigation" added to it.
 @param delegate The delegate that will receive messages when the scroll view needs to load
                 new data. @see CCPullNavigationDelegate
 */
- (id)initWithScrollView:(UIScrollView *)scrollView andDelegate:(id<CCPullNavigationDelegate>)delegate;

/**
 This should be called after data has finished loading. It resets the UI, pull states, etc.
 */
- (void)loadingDidFinish;

@end
