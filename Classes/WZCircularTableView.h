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

@interface WZCircularTableView : UITableView

@property (nonatomic, assign, getter = isInfiniteScrollingEnabled) BOOL enableInfiniteScrolling;
@property (nonatomic, assign) WZCircularTableViewContentAlignment contentAlignment;
@property (nonatomic, assign) CGFloat radius;

- (void)clearBackground;

@end
