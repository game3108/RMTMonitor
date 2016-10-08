//
//  RMTRunloopMonitor.m
//  RMTMonitorDemo
//
//  Created by game3108 on 16/9/23.
//  Copyright © 2016年 game3108. All rights reserved.
//

#import "RMTRunloopMonitor.h"
#import <libkern/OSAtomic.h>
#import <execinfo.h>

@interface RMTRunloopMonitor()
@property (nonatomic, assign) CFRunLoopObserverRef observer;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, assign) CFRunLoopActivity activity;
@property (nonatomic, assign) NSInteger countTime;
@property (nonatomic, assign) BOOL isMonitoring;
@end


@implementation RMTRunloopMonitor

#pragma mark private function
- (instancetype)init{
    self = [super init];
    if ( self ){
        _checkInterval = 50;
        _maxCheckTime = 5;
    }
    return self;
}

- (void)startObserver
{
    if (_isMonitoring){
        return;
    }
    _isMonitoring = YES;
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    _observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                        kCFRunLoopAllActivities,
                                        YES,
                                        0,
                                        &runLoopObserverCallBack,
                                        &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), _observer, kCFRunLoopCommonModes);
    
    _semaphore = dispatch_semaphore_create(0);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES)
        {
            long st = dispatch_semaphore_wait(_semaphore, dispatch_time(DISPATCH_TIME_NOW, _checkInterval*NSEC_PER_MSEC));
            if (st != 0)
            {
                BOOL isUIInterval = [self isUIIntervalActivity];
                if (isUIInterval)
                {
                    if (++_countTime < _maxCheckTime)
                        continue;
                    [_delegate notifyRunloopMonitor];
                }
            }
            _countTime = 0;
        }
    });
}

- (void)endObserver{
    if (!_observer) {
        return;
    }
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), _observer, kCFRunLoopCommonModes);
    CFRelease(_observer);
    _observer = nil;
    _isMonitoring = NO;
}

- (BOOL)isUIIntervalActivity{
    return _activity==kCFRunLoopBeforeSources || _activity==kCFRunLoopAfterWaiting;
}

- (void)reset{
    if (_isMonitoring){
        return;
    }
    _observer = nil;
    _semaphore = nil;
    _countTime = 0;
}

#pragma mark public function

+ (instancetype) sharedInstance{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void) start{
    [self startObserver];
}

- (void) stop{
    [self endObserver];
    [self reset];
}


#pragma mark observer methods
static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    RMTRunloopMonitor *instrance = [RMTRunloopMonitor sharedInstance];
    instrance->_activity = activity;
    dispatch_semaphore_signal(instrance->_semaphore);
    
}

@end
