//
//  RMTMonitorManager.h
//  RMTMonitorDemo
//
//  Created by game3108 on 16/9/23.
//  Copyright © 2016年 game3108. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RMTMonitorManagerDelegate <NSObject>
@optional
- (void) notifyUILag;
@end

@interface RMTMonitorManager : NSObject
@property (nonatomic, weak) id<RMTMonitorManagerDelegate> delegate;
/**
 The check interval.Default is 50.The unit is NSEC_PER_MSEC.
 */
@property (nonatomic, assign) NSUInteger checkInterval;
/**
 The max check time.Default is 5.
 */
@property (nonatomic, assign) NSUInteger maxCheckTime;

+ (instancetype) sharedInstance;


/**
 start ui lag monitor
 */
- (void) rmt_startUIMonitor;


/**
 end ui lag monitor
 */
- (void) rmt_endUIMonitor;
@end
