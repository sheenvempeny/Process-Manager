//
//  NSRunningApplication+Adds.h
//  process manager
//
//  Created by sheen vempeny on 2/26/17.
//  Copyright © 2017 sheen vempeny. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSRunningApplication (Adds)

- (NSString *)userName;
- (NSString *)CPUUsage;
- (NSNumber *)CPU;
- (void)update;

@end
