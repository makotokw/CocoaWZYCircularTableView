//
//  WZYCircularTableView.m
//  WZYCircularTableView
//
//  Copyright (c) 2013 makoto_kw. All rights reserved.
//

#import "WZYCircularTableView.h"
#import "WZYCircularTableViewInterceptor.h"

@implementation WZYCircularTableView

{
    WZYCircularTableViewInterceptor *_dataSourceInterceptor;
    NSInteger _repeatCount;
    NSInteger _numberOfDataSourceRows;
    BOOL _enableInfiniteScrolling;
}

@dynamic enableInfiniteScrolling;

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
    _contentAlignment = WZYCircularTableViewContentAlignmentNone;
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

- (void)setDataSource:(id<UITableViewDataSource>)dataSource
{
    if (!_dataSourceInterceptor) {
        _dataSourceInterceptor = [[WZYCircularTableViewInterceptor alloc] init];
    }
    
    _dataSourceInterceptor.receiver  = dataSource;
    _dataSourceInterceptor.middleReceiver = self;
    
    [super setDataSource:(id<UITableViewDataSource>)_dataSourceInterceptor];
}

- (BOOL)scrollFirstCellToCenter
{
    if (!_enableInfiniteScrolling || _repeatCount < 2) {
        return NO;
    }
    
    if (self.contentSize.height == 0
        || self.contentSize.height <= self.bounds.size.height) {
        return NO;
    }
    
    CGPoint contentOffset = self.contentOffset;
    CGFloat contentHeightPerUnit = self.contentSize.height / _repeatCount;
    contentOffset.y = contentHeightPerUnit - self.contentCenterInsetTop + (self.rowHeight / 2);
    [self setContentOffset:contentOffset];
    
    return YES;
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
        contentOffset.y = contentHeightPerUnit;
    }
    else if (contentOffset.y >= (self.contentSize.height - self.bounds.size.height)) {
        while (contentOffset.y > contentHeightPerUnit) {
            contentOffset.y -= contentHeightPerUnit;
        }
    }
    [self setContentOffset:contentOffset];
}

- (NSArray *)cellsAtRow:(NSInteger)row
{
    NSMutableArray *cells = [NSMutableArray array];
    
    for (NSInteger i = 0; i < _repeatCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(row + i * _numberOfDataSourceRows) inSection:0];
        UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
        if (cell) {
            [cells addObject:cell];
        }
    }
    
    return cells;
}

- (UITableViewCell *)cellAtCenter
{
    return [self cellForRowAtIndexPath:self.indexPathAtCenter];
}

- (NSIndexPath *)indexPathAtCenter
{
    return [self indexPathForRowAtPoint:self.contentCenter];
}

- (CGFloat)contentCenterInsetTop
{
    return self.contentInset.top + (self.frame.size.height - self.contentInset.top - self.contentInset.bottom) / 2.0f;
}

- (CGPoint)contentCenter
{
    return CGPointMake(
                       self.frame.size.width / 2,
                       self.contentOffset.y + self.contentCenterInsetTop
                       );
}

- (CGPoint)contentCenterInFrame
{
    return CGPointMake(
                       self.frame.size.width / 2,
                       self.contentCenterInsetTop
                       );
}

- (void)layoutVisibleCells
{
    NSArray   *indexPaths        = [self indexPathsForVisibleRows];
    NSUInteger totalVisibleCells = [indexPaths count];
    
    if (WZYCircularTableViewContentAlignmentNone != _contentAlignment) {
        
        CGPoint contentCenterInFrame = self.contentCenterInFrame;
        CGFloat viewHalfHeight = (self.frame.size.height) / 2.0f;
        
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
            
            CGFloat y = MIN(ABS(contentCenterInFrame.y - (frame.origin.y - self.contentOffset.y + (rowHeight / 2.0f))), yRadius);
            CGFloat angle = asinf(y / yRadius);
            CGFloat x = xRadius * cosf(angle);

            if (_contentAlignment == WZYCircularTableViewContentAlignmentLeft) {
                x = xRadius  - x;
            } else {
                x = x - xRadius / 2;
            }
            
            if (!isnan(x)) {
                frame.origin.x = x;
                cell.frame = frame;
            }
        }
    } else {
        for (NSUInteger index = 0; index < totalVisibleCells; index++) {
            NSIndexPath * indexPath = [indexPaths objectAtIndex:index];
            UITableViewCell *cell  = (UITableViewCell *) [self cellForRowAtIndexPath:indexPath];
            CGRect           frame = cell.frame;
            
            frame.origin.x = 0;
            cell.frame = frame;
        }
    }
    
    if (_layoutCompletionHandler) {
        _layoutCompletionHandler();
    }
}

- (void)layoutSubviews
{
    [self resetContentOffsetIfNeeded];
    [super layoutSubviews];
    [self layoutVisibleCells];
}

- (void)clearBackground
{
    self.backgroundColor = [UIColor clearColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)reloadData
{
    [super reloadData];
    
    if (_reloadCompletionHandler) {
        _reloadCompletionHandler();
    }
}

-(void)reloadData:(WZYCircularTableViewCompletionHander)completionHander
{
    [self reloadData];
    
    if (completionHander){
        completionHander();
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    _numberOfDataSourceRows = [_dataSourceInterceptor.receiver tableView:tableView numberOfRowsInSection:section];
    
    _repeatCount = 1;
    if (_enableInfiniteScrolling) {
        NSInteger _visibledRows = ceil(self.frame.size.height / self.rowHeight);
        if (_numberOfDataSourceRows * 2 > _visibledRows) {
            _repeatCount = 3;
        }
    }            
    return _numberOfDataSourceRows * _repeatCount;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_numberOfDataSourceRows > 0) {
        NSIndexPath *morphedIndexPath = _enableInfiniteScrolling ? [NSIndexPath indexPathForRow:indexPath.row % _numberOfDataSourceRows inSection:indexPath.section] : indexPath;
        return [_dataSourceInterceptor.receiver tableView:tableView cellForRowAtIndexPath:morphedIndexPath];
    }
    return [_dataSourceInterceptor.receiver tableView:tableView cellForRowAtIndexPath:indexPath];
}

@end
