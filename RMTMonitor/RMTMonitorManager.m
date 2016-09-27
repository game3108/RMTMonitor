//
//  RMTMonitorManager.m
//  RMTMonitorDemo
//
//  Created by game3108 on 16/9/23.
//  Copyright © 2016年 game3108. All rights reserved.
//

#import "RMTMonitorManager.h"
#import "RMTRunloopMonitor.h"

@interface RMTMonitorManager() <RMTRunloopMonitorDelegate>
@property (nonatomic, strong) RMTRunloopMonitor *runloopMonitor;
@end

@implementation RMTMonitorManager

- (instancetype)init{
    self = [super init];
    if (self){
        _runloopMonitor = [RMTRunloopMonitor sharedInstance];
        _runloopMonitor.delegate = self;
    }
    return self;
}

#pragma mark public method

+ (instancetype) sharedInstance{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
     
- (void) rmt_startUIMonitor{
    [_runloopMonitor start];
}

- (void) rmt_endUIMonitor{
    [_runloopMonitor stop];
}

#pragma mark setter

- (void)setCheckInterval:(NSUInteger)checkInterval{
    _checkInterval = checkInterval;
    _runloopMonitor.checkInterval = checkInterval;
}

- (void)setMaxCheckTime:(NSUInteger)maxCheckTime{
    _maxCheckTime = maxCheckTime;
    _runloopMonitor.maxCheckTime = maxCheckTime;
}

#pragma mark RMTRunloopMonitorDelegate

- (void) notifyRunloopMonitor{
    [_delegate notifyUILag];
}

@end
