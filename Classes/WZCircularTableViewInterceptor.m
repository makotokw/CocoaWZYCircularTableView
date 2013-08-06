//
//  WZCircularTableViewInterceptor.m
//  WZCircularTableView
//
//  Copyright (c) 2013 makoto_kw. All rights reserved.
//

#import "WZCircularTableViewInterceptor.h"

@implementation WZCircularTableViewInterceptor

@synthesize receiver       = _receiver;
@synthesize middleReceiver = _middleReceiver;

- (id)forwardingTargetForSelector:(SEL)selector
{
    if ([_middleReceiver respondsToSelector:selector]) {
        return _middleReceiver;
    }
    if ([_receiver respondsToSelector:selector]) {
        return _receiver;
    }
    
    return [super forwardingTargetForSelector:selector];
}

- (BOOL)respondsToSelector:(SEL)selector
{
    if ([_middleReceiver respondsToSelector:selector]) {
        return YES;
    }
    if ([_receiver respondsToSelector:selector]) {
        return YES;
    }
    return [super respondsToSelector:selector];
}

@end
