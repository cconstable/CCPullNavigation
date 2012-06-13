//
//  ViewController.m
//  CCPullNavigationDemo
//
//  Created by Christopher Constable on 6/8/12.
//

#import "ViewController.h"
#import "CCDefaultLoaderViewController.h"

@interface ViewController ()
@property (nonatomic) int pageNumber;
- (void)refreshTableView;
@end

@implementation ViewController

@synthesize pageNumber      = _pageNumber;
@synthesize tableView       = _tableView;
@synthesize pullNavigation  = _pullNavigation;

- (id)init
{
    self = [super init];
    if (self) {
        self.pageNumber = 1;
    }
    
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.pullNavigation = [[CCPullNavigation alloc] initWithScrollView:self.tableView andDelegate:self];
    self.pullNavigation.previousLoaderViewController = nil;
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)refreshTableView
{    
    // Update the page numbers.
    [[(CCDefaultLoaderViewController *)self.pullNavigation.previousLoaderViewController label] setText:[NSString stringWithFormat:@"Chapter %d - Title", (self.pageNumber - 1)]];
    [[(CCDefaultLoaderViewController *)self.pullNavigation.nextLoaderViewController label] setText:[NSString stringWithFormat:@"Chapter %d - Title", (self.pageNumber + 1)]];
    
    // Scroll to the top and reload the table.
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    // Let the pull navigation know we are done loading.
    // In a real situation, this would probably be called later sometime.
    [self.pullNavigation loadingDidFinish];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    return (screenFrame.size.height == 480) ? 7 : 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resuableCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"resuableCell"];
    }
    
    [[cell textLabel] setText:[NSString stringWithFormat:@"Chapter %d - Section %d", self.pageNumber, indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Colors!!
    [cell setBackgroundColor:[UIColor colorWithRed:(((arc4random() % 125) + 130) / 255.0) 
                                             green:(((arc4random() % 125) + 130) / 255.0) 
                                              blue:(((arc4random() % 125) + 130) / 255.0) alpha:1.0]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)scrollView:(UIScrollView *)scrollView didLoadPreviousWithLoader:(UIViewController<CCPullNavigationViewController> *)loaderVC
{    
    self.pageNumber--;

    // If we are at the first page, disable the "previous" VC.
    if (self.pageNumber == 1) {
        self.pullNavigation.previousLoaderViewController = nil;
    }
    
    // Create "next" VC if necessary.
    if (self.pageNumber == 3) {
        self.pullNavigation.nextLoaderViewController = [[CCDefaultLoaderViewController alloc] initWithNibName:@"CCDefaultLoadNextViewController" bundle:nil];
    }
    
    [self refreshTableView];
}

- (void)scrollView:(UIScrollView *)scrollView didLoadNextWithLoader:(UIViewController<CCPullNavigationViewController> *)loaderVC
{
    self.pageNumber++;
    
    // Create "previous" VC if necessary.
    if (self.pageNumber == 2) {
        self.pullNavigation.previousLoaderViewController = [[CCDefaultLoaderViewController alloc] initWithNibName:@"CCDefaultLoadPreviousViewController" bundle:nil];
    }
    
    // Stop at chapter 4.
    if (self.pageNumber == 4) {
        self.pullNavigation.nextLoaderViewController = nil;
    }
    
    [self refreshTableView];
}

@end
