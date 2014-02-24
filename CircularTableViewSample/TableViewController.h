//
//  TableViewController.h
//  CircularTableViewSample
//
//  Copyright (c) 2013 makoto_kw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZYCircularTableView.h"

@interface TableViewController : UITableViewController

@property (nonatomic, assign, getter = isInfiniteScrollingEnabled) BOOL enableInfiniteScrolling;
@property (nonatomic, assign) WZYCircularTableViewContentAlignment contentAlignment;
@property (nonatomic, assign) CGFloat radius;

@end
