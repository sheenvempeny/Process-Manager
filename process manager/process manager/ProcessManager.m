//
//  ProcessManager.m
//  process manager
//
//  Created by sheen vempeny on 2/26/17.
//  Copyright © 2017 sheen vempeny. All rights reserved.
//


#import "ProcessManager.h"
#import <sys/event.h>
#import "KillApp.h"
#import "NSRunningApplication+Adds.h"

@interface ProcessManager()
{
    
   
}
@property (nonatomic,copy) RefreshBlock block;
@property (nonatomic,strong) NSMutableArray *runningApps;

@end


@implementation ProcessManager


- (id)initWithRefreshBlock:(RefreshBlock)block{
    
    self = [super init];
    if (self) {
        self.block = block;
        self.runningApps = [NSMutableArray array];
        [self addItems:[self currentApps]];
        [self addObserve];
        
    }
    return self;
    
}

- (NSMutableArray*)currentApps{
    
    NSMutableArray *currentApps = [NSMutableArray arrayWithArray: [[NSWorkspace sharedWorkspace] runningApplications]];
    return currentApps;
}

- (void)appLaunched:(NSNotification*)notification{
    
    NSMutableArray *newApps = [self currentApps];
    [newApps removeObjectsInArray:self.runningApps];
    [self addItems:newApps];
}

- (void)addObserve{
    
    NSNotificationCenter *center = [[NSWorkspace sharedWorkspace] notificationCenter];
    [center addObserver:self
               selector:@selector(appLaunched:)
                   name:NSWorkspaceDidLaunchApplicationNotification
                 object:nil];
   
}

- (void)removeObserve{
    
    NSNotificationCenter *center = [[NSWorkspace sharedWorkspace] notificationCenter];
    [center removeObserver:self name:NSWorkspaceDidLaunchApplicationNotification object:nil];
    
}



- (void)removeApp:(NSRunningApplication*)app{
    
    [app removeObserver:self forKeyPath:@"isTerminated"];
    [self.runningApps removeObject:app];
    self.block();
}

- (void)addItems:(NSArray*)array{
    [self.runningApps addObjectsFromArray:array];
    [array makeObjectsPerformSelector:@selector(update)];
    for (NSRunningApplication *app in array) {
        
        [app addObserver:self
                          forKeyPath:@"isTerminated"
                             options:NSKeyValueObservingOptionNew
                             context:NULL];
    }
    
    self.block();
}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    
    if ([keyPath isEqual:@"isTerminated"])
    {
        
        [self removeApp:object];
    }
}

- (void)dealloc
{
    [self removeObserve];
    self.runningApps = nil;
    
}

- (NSArray*)userProcess{
    
    NSMutableArray *array = [NSMutableArray array];
    for(NSRunningApplication *app in self.runningApps){
        
        if([[app userName] isEqualToString:@"root"] == NO){
            [array addObject:app];
        }
    }

    return [NSArray arrayWithArray:array];
}

- (NSArray*)allProcess{
    
    return [NSArray arrayWithArray:self.runningApps];
}
- (void)kill:(NSRunningApplication*)app{
    
    if([[app userName] isEqualToString:@"root"]){
        [KillApp kill:app.processIdentifier];
    }
    else{
        kill( app.processIdentifier, SIGKILL );
    }
    
}


@end
