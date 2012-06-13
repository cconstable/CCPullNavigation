CCPullNavigation
================

This library allows users to navigate views by pulling up or down at the the bottom or top of a scroll view (respectively).

CCPullNavigation was created because there were no easily accessable library that did the following:
1. Provide pull-to-refresh style navigation (in any direction).
2. Did not add extra container views to the view hierarchy.
3. Did not use the scroll view's delegate.
4. Was easily customizable.

## Note

This library is in a very early stage. The core functionality works but many features are disabled or have not been added.

## Example Usage

``` objective-c
// Have your view controller implement the CCPullNavigationDelegate protocol.
@interface MyViewController : UIViewController <CCPullNavigationDelegate>

// Then initialize the CCPullNavigation in the view controller's viewDidLoad.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pullNavigation = [[CCPullNavigation alloc] initWithScrollView:self.tableView andDelegate:self];
    
    // Configure CCPullNavigationContainer properties (optional).
    self.pullNavigation.previousLoaderViewController = [[MyCustomLoaderViewController alloc] init];
    self.pullNavigation.nextLoaderViewController = [[MyCustomLoaderViewController alloc] init];
    
    // How far the user needs to pull to activate. Default is 75% of the loader view controller's height.
    self.pullNavigation.previousLoaderReadyOffset = 50.0f;     
}

- (void)scrollView:(UIScrollView *)scrollView didLoadPreviousWithLoader:(UIViewController<CCPullNavigationViewController> *)loaderVC
{    
    self.pageNumber--;
    [self refreshTableView];
}

- (void)scrollView:(UIScrollView *)scrollView didLoadNextWithLoader:(UIViewController<CCPullNavigationViewController> *)loaderVC
{
    self.pageNumber++;
    [self refreshTableView];
}

- (void)refreshTableView
{    
	// Do some stuff...
	
	// Let the pull navigation know when you are done.
    [self.pullNavigation loadingDidFinish];
}
```