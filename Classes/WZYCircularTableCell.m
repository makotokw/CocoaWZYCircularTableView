//
//  WZYCircularTableCell.m
//  WZYCircularTableView
//
//  Copyright (c) 2013 makoto_kw Inc. All rights reserved.
//

#import "WZYCircularTableCell.h"

@implementation WZYCircularTableCell

{
    UIColor *_borderColor;
    UILabel *_cellTtleLabel;
    CALayer *_imageLayer;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // add the image layer
        self.contentView.backgroundColor = [UIColor clearColor];
        _imageLayer                      = [CALayer layer];
        _imageLayer.cornerRadius         = 16.0;
        [self.contentView.layer addSublayer:_imageLayer];
        _borderColor            = [UIColor whiteColor];
        _imageLayer.borderWidth = 4.0;
        _imageLayer.borderColor = _borderColor.CGColor;
        
        // the title label
        _cellTtleLabel = [[UILabel alloc] initWithFrame:CGRectMake(44.0, 10.0, self.contentView.bounds.size.width - 44.0, 21.0)];
        [self.contentView addSubview:_cellTtleLabel];
        _cellTtleLabel.backgroundColor = [UIColor clearColor];
        _cellTtleLabel.textColor       = [UIColor whiteColor];
        _cellTtleLabel.shadowColor     = [UIColor blackColor];
        _cellTtleLabel.shadowOffset    = CGSizeMake(1.f, 1.f);
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    float imageY             = 4.0;
    float heightOfImageLayer = self.bounds.size.height - imageY * 2.0;
    heightOfImageLayer       = floorf(heightOfImageLayer);
    _imageLayer.cornerRadius = heightOfImageLayer / 2.0f;
    _imageLayer.frame        = CGRectMake(4.0, imageY, heightOfImageLayer, heightOfImageLayer);
    _cellTtleLabel.frame     = CGRectMake(heightOfImageLayer + 10.0, floorf(heightOfImageLayer / 2.0 - (21 / 2.0f)) + 4.0, self.contentView.bounds.size.width - heightOfImageLayer + 10.0, 21.0);
}

- (void)setCellTitle:(NSString *)title
{
    _cellTtleLabel.text = title;
}

- (void)setIcon:(UIImage *)image
{
    [CATransaction begin];
    [CATransaction setAnimationDuration:0];
    _imageLayer.contents = (id)image.CGImage;
    [CATransaction commit];
}

- (void)setBorderColor:(UIColor *)color
{
    _borderColor            = color;
    _imageLayer.borderColor = color.CGColor;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    _imageLayer.borderColor  = selected ? [UIColor orangeColor].CGColor : _borderColor.CGColor;
    _cellTtleLabel.textColor = selected ? [UIColor orangeColor] : _borderColor;
}

@end
