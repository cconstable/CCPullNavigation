//
//  ViewController.h
//  CCPullNavigationDemo
//
//  Created by Christopher Constable on 6/8/12.
//

#import <UIKit/UIKit.h>
#import "CCPullNavigation.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CCPullNavigationDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CCPullNavigation *pullNavigation;

@end
