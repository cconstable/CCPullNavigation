//
//  CCPullNavigationViewController.h
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

#import <Foundation/Foundation.h>

/**
 This enum represents different states that a CCPullNavigationViewController can be in. Normally
 the states will follow this pattern:
 Resting -> Shown -> Ready To Load -> Loading -> Closing -> Resting
 
 Custom CCPullNavigationViewControllers can implement custom animations at each state. 
 */
typedef enum {
    CCNavigationViewStateResting,       ///< Normal resting state. Ususally, the user cannot see the view.
    CCNavigationViewStateShown,         ///< User can see the view but has not pulled far enough initiate loading.
    CCNavigationViewStateReadyToLoad,   ///< User has pulled the view far enough to release and initiate loading.
    CCNavigationViewStateLoading,       ///< User has released the pull from the ReadyToLoad state.
    CCNavigationViewStateClosing        ///< The final state of the view after the data has been loaded.
} CCNavigationViewState;


/**
 When a user navigates to the edge (e.g. top or bottom) of a scroll view and continues to pull
 they are shown CCPullNavigationViewController. This protocol defines what messags those views should be
 able to receive.
 
 For example, normally, as the user is pulling, an animation will occur at some point to let the
 user know they can release the pull and their data will be loaded / refreshed. Concretely, this
 happens when the CCPullNavigation object calls pullNavigationViewShouldChangeState: on the
 CCPullNavigationViewController.
 */
@protocol CCPullNavigationViewController <NSObject>
@required

/**
 State of the "pull" on the scroll view with respect to this view controller.
 
 @see CCNavigationViewState
 */
@property (nonatomic, readonly) CCNavigationViewState pullState;

/**
 Lets the CCPullNavigationViewController know that it should change it's state.
 
 @see CCNavigationViewState
 */
- (void)pullNavigationViewShouldChangeState:(CCNavigationViewState)newState;

/**
 Tells the CCPullNavigationViewController to reset because data has been loaded. 
 */
- (void)loadingDidFinish;

@optional

/**
 Updates when the scroll view is pulled. Represents the percentage of the view's height
 that has been pulled down.
 
 @param newProgress A value between 0.0 and 1.0.
 */
- (void)pullNavigationProgressUpdated:(CGFloat)newProgress;

@end
