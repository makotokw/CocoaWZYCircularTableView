//
//  WZYCircularTableView.h
//  WZYCircularTableView
//
//  Copyright (c) 2013 makoto_kw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    WZYCircularTableViewContentAlignmentNone,
    WZYCircularTableViewContentAlignmentLeft,
    WZYCircularTableViewContentAlignmentRight
} WZYCircularTableViewContentAlignment;

typedef void (^WZYCircularTableViewCompletionHander)();

@interface WZYCircularTableView : UITableView

@property (nonatomic, copy) WZYCircularTableViewCompletionHander reloadCompletionHandler;
@property (nonatomic, copy) WZYCircularTableViewCompletionHander layoutCompletionHandler;

@property (nonatomic, assign, getter = isInfiniteScrollingEnabled) BOOL enableInfiniteScrolling;
@property (nonatomic, assign) WZYCircularTableViewContentAlignment contentAlignment;
@property (nonatomic, assign) CGFloat radius;

- (UITableViewCell*)cellAtCenter;
- (NSIndexPath*)indexPathAtCenter;
- (BOOL)scrollFirstCellToCenter;
- (void)clearBackground;

-(void)reloadData:(WZYCircularTableViewCompletionHander)completionHander;

@end
