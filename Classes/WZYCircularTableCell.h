//
//  WZYCircularTableCell.h
//  WZYCircularTableView
//
//  Copyright (c) 2013 makoto_kw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface WZYCircularTableCell : UITableViewCell

- (void)setCellTitle:(NSString *)title;
- (void)setIcon:(UIImage *)image;
- (void)setBorderColor:(UIColor *)color;

@end
