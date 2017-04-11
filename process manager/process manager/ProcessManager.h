//
//  ProcessManager.h
//  process manager
//
//  Created by sheen vempeny on 2/26/17.
//  Copyright © 2017 sheen vempeny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

typedef void (^RefreshBlock)();

@interface ProcessManager : NSObject

- (id)initWithRefreshBlock:(RefreshBlock)block;
- (NSArray*)allProcess;
- (NSArray*)userProcess;
- (void)kill:(NSRunningApplication*)app;

@end
