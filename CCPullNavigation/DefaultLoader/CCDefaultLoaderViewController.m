//
//  CCDefaultLoaderViewController.m
//
//  Created by Christopher Constable on 6/12/12.
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

#import "CCDefaultLoaderViewController.h"

@implementation CCDefaultLoaderViewController

@synthesize pullState = _pullState;
@synthesize activityIndicator;
@synthesize icon;
@synthesize label;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _pullState = CCNavigationViewStateResting;

    }
    return self;
}

- (void)viewDidUnload
{
    [self setIcon:nil];
    [self setLabel:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)pullNavigationViewShouldChangeState:(CCNavigationViewState)newState
{
    _pullState = newState;
    
    // Ready to load.
    if (_pullState == CCNavigationViewStateReadyToLoad) {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.icon.transform = CGAffineTransformMakeRotation(M_PI);
        } completion:^(BOOL finished) {
        }];
    }
    
    // Loading.
    else if (_pullState == CCNavigationViewStateLoading) {
        self.icon.alpha = 0.0;
        [self.activityIndicator startAnimating];
    }
    
    // Normal.
    else if ((_pullState == CCNavigationViewStateResting) || (_pullState == CCNavigationViewStateShown)) {
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.icon.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)loadingDidFinish
{
    [self pullNavigationViewShouldChangeState:CCNavigationViewStateResting];
    self.icon.alpha = 1.0;
    [self.activityIndicator stopAnimating]; 
}

@end
