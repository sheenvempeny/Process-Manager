//
//  KillApp.m
//  process manager
//
//  Created by sheen vempeny on 2/27/17.
//  Copyright © 2017 sheen vempeny. All rights reserved.
//

#import "KillApp.h"

@interface KillApp ()

+ (NSString*)toolPath;

@end

@implementation KillApp


+ (NSString*)toolPath{
    
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/ProcDeleteHelper"];
    return path;
    
}

+ (void)kill:(NSInteger)pid{
    
    NSString *toolPath = [KillApp toolPath];
    NSArray *args = [NSArray arrayWithObjects:toolPath, [NSString stringWithFormat:@"%ld",(long)pid] , nil];
    [NSTask launchedTaskWithLaunchPath:toolPath arguments:args];
    
}

@end
