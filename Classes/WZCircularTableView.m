//
//  WZCircularTableView.m
//  WZCircularTableView
//
//  Copyright (c) 2013 makoto_kw. All rights reserved.
//

#import "WZCircularTableView.h"
#import "WZCircularTableViewInterceptor.h"

@implementation WZCircularTableView

{
    WZCircularTableViewInterceptor *_dataSourceInterceptor;
    NSInteger _repeatCount;
    NSInteger _totalRows;
    BOOL _enableInfiniteScrolling;
}

@dynamic enableInfiniteScrolling;
@synthesize contentAlignment = _contentAlignment;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customIntitialization];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self customIntitialization];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customIntitialization];
    }
    return self;
}

- (void)awakeFromNib
{
    [self customIntitialization];
}

- (void)customIntitialization
{
    _repeatCount = 0;
    _contentAlignment = WZCircularTableViewContentAlignmentNone;
    _radius = 0.0f;
    
    self.enableInfiniteScrolling = YES;
    self.showsVerticalScrollIndicator = NO;
}

- (BOOL)isEnableInfiniteScrolling
{
    return _enableInfiniteScrolling;
}

- (void)setEnableInfiniteScrolling:(BOOL)enableInfiniteScrolling
{
    _enableInfiniteScrolling = enableInfiniteScrolling;
    if (_enableInfiniteScrolling) {
        self.showsVerticalScrollIndicator = NO;
    }
}

- (void)layoutSubviews
{    
    [self resetContentOffsetIfNeeded];
    [super layoutSubviews];

    if (WZCircularTableViewContentAlignmentNone != _contentAlignment) {
        [self layoutVisibleCells];
    }
}

- (void)setDataSource:(id<UITableViewDataSource>)dataSource
{
    if (!_dataSourceInterceptor) {
        _dataSourceInterceptor = [[WZCircularTableViewInterceptor alloc] init];
    }
    
    _dataSourceInterceptor.receiver  = dataSource;
    _dataSourceInterceptor.middleReceiver = self;
    
    [super setDataSource:(id<UITableViewDataSource>)_dataSourceInterceptor];
}

- (void)resetContentOffsetIfNeeded
{
    if (!_enableInfiniteScrolling || _repeatCount < 2) {
        return;
    }
    
    if (self.contentSize.height == 0
        || self.contentSize.height <= self.bounds.size.height) {
        return;
    }
    
    CGPoint contentOffset = self.contentOffset;
    CGFloat contentHeightPerUnit = self.contentSize.height / _repeatCount;
    
    if (contentOffset.y <= 0.0) {
        contentOffset.y += contentHeightPerUnit;
    }
    else if (contentOffset.y >= (self.contentSize.height - self.bounds.size.height)) {
        while (contentOffset.y > contentHeightPerUnit) {
            contentOffset.y -= contentHeightPerUnit;
        }
    }
    [self setContentOffset:contentOffset];
}

- (void)layoutVisibleCells
{
    NSArray   *indexPaths        = [self indexPathsForVisibleRows];
    NSUInteger totalVisibleCells = [indexPaths count];
    
    CGFloat viewHalfHeight = (self.frame.size.height) / 2.0f;
    CGFloat yCenterOffset = self.contentInset.top + (self.frame.size.height - self.contentInset.top - self.contentInset.bottom) / 2.0f;
    
    CGFloat vRadius = (self.frame.size.height);
    CGFloat hRadius = (self.frame.size.width);
    
    CGFloat yRadius = viewHalfHeight + ( self.rowHeight );
    CGFloat xRadius  = (vRadius <  hRadius) ? vRadius : hRadius;
    if (self.radius > 0 && isfinite(self.radius)) {
        xRadius = self.radius;
    }

    for (NSUInteger index = 0; index < totalVisibleCells; index++) {

        NSIndexPath * indexPath = [indexPaths objectAtIndex:index];
        UITableViewCell *cell  = (UITableViewCell *) [self cellForRowAtIndexPath:indexPath];
        CGRect           frame = cell.frame;
        
        CGFloat rowHeight = self.rowHeight;
        if ([self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
            rowHeight = [self.delegate tableView:self heightForRowAtIndexPath:indexPath];
        }
        
        CGFloat y = MIN(ABS(yCenterOffset - (frame.origin.y - self.contentOffset.y + (rowHeight / 2.0f))), yRadius);
        CGFloat angle = asinf(y / yRadius);
        CGFloat x = xRadius * cosf(angle);

        if (_contentAlignment == WZCircularTableViewContentAlignmentLeft) {
            x = xRadius  - x;
        } else {
            x = x - xRadius / 2;
        }
        
        if (!isnan(x)) {
            frame.origin.x = x;
            cell.frame = frame;
        }
    }
}

- (void)clearBackground
{
    self.backgroundColor = [UIColor clearColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    _totalRows = [_dataSourceInterceptor.receiver tableView:tableView numberOfRowsInSection:section];
    
    _repeatCount = 1;
    if (_enableInfiniteScrolling) {
        NSInteger _visibledRows = ceil(self.frame.size.height / self.rowHeight);
        if (_totalRows * 2 > _visibledRows) {
            _repeatCount = 3;
        }
    }            
    return _totalRows * _repeatCount;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_totalRows > 0) {
        NSIndexPath *morphedIndexPath = _enableInfiniteScrolling ? [NSIndexPath indexPathForRow:indexPath.row % _totalRows inSection:indexPath.section] : indexPath;
        return [_dataSourceInterceptor.receiver tableView:tableView cellForRowAtIndexPath:morphedIndexPath];
    }
    return [_dataSourceInterceptor.receiver tableView:tableView cellForRowAtIndexPath:indexPath];
}

@end
