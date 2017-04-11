//
//  ProcessInfo.h
//  process manager
//
//  Created by sheen vempeny on 2/26/17.
//  Copyright © 2017 sheen vempeny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface ProcessInfo : NSObject

- (id)initWithApp:(NSRunningApplication*)app;
//Process owner 
- (NSString*)owner;
//Process owner Id
- (uid_t)ownerUserID;
//cpu usage in number
- (NSNumber *)CPU;
//cpu usage in string
- (NSString *)CPUUsage;
//update
- (void)update;
@end
