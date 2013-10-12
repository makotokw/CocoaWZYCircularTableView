//
//  WZCircularTableView.h
//  WZCircularTableView
//
//  Copyright (c) 2013 makoto_kw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    WZCircularTableViewContentAlignmentNone,
    WZCircularTableViewContentAlignmentLeft,
    WZCircularTableViewContentAlignmentRight
} WZCircularTableViewContentAlignment;

typedef void (^WZCircularTableViewCompletionHander)();

@interface WZCircularTableView : UITableView

@property (nonatomic, copy) WZCircularTableViewCompletionHander reloadCompletionHandler;
@property (nonatomic, copy) WZCircularTableViewCompletionHander layoutCompletionHandler;

@property (nonatomic, assign, getter = isInfiniteScrollingEnabled) BOOL enableInfiniteScrolling;
@property (nonatomic, assign) WZCircularTableViewContentAlignment contentAlignment;
@property (nonatomic, assign) CGFloat radius;

- (UITableViewCell*)cellAtCenter;
- (NSIndexPath*)indexPathAtCenter;
- (BOOL)scrollFirstCellToCenter;
- (void)clearBackground;

-(void)reloadData:(WZCircularTableViewCompletionHander)completionHander;

@end
