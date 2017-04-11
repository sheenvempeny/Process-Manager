//
//  NSRunningApplication+Adds.m
//  process manager
//
//  Created by sheen vempeny on 2/26/17.
//  Copyright © 2017 sheen vempeny. All rights reserved.
//

#import "NSRunningApplication+Adds.h"
#import "ProcessInfo.h"
#import <objc/runtime.h>


static void *processInfo;

@implementation NSRunningApplication (Adds)


- (ProcessInfo*)processInfo{
    
    ProcessInfo *mInfo = objc_getAssociatedObject(self, &processInfo);
    if (mInfo == nil) {
        mInfo = [[ProcessInfo alloc] initWithApp:self];
        objc_setAssociatedObject(self, &processInfo, mInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return mInfo;
}

- (void)update{
    
    [self.processInfo update];
}

- (NSString *)userName {

    return [self.processInfo owner];
}
- (NSString *)CPUUsage{
    
    return [self.processInfo CPUUsage];
    
}
- (NSNumber *)CPU{
   
    return [self.processInfo CPU];
    
}

@end
