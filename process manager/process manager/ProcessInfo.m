//
//  ProcessInfo.m
//  process manager
//
//  Created by sheen vempeny on 2/26/17.
//  Copyright © 2017 sheen vempeny. All rights reserved.
//

#import "ProcessInfo.h"
#import <sys/sysctl.h>
#import <pwd.h>
#import <sys/proc_info.h>
#include <libproc.h>

#define kPasswdBufferSize (128)

@interface  ProcessInfo ()
{
    
    
}

- (pid_t)pid;

@property (nonatomic,strong) NSString *owner;
@property (nonatomic,strong) NSNumber *CPU;
@property (nonatomic,strong) NSNumber *proc_cpu;
@property (nonatomic,strong) NSNumber *sys_time;
@property (nonatomic,strong) NSRunningApplication *app;

- (NSString*)ownerName;
- (bool)upadteCPUUsage;

@end


@implementation ProcessInfo

- (instancetype)initWithApp:(NSRunningApplication*)app
{
    self = [super init];
    if (self) {
        self.app = app;
    }
    return self;
}

- (void)dealloc
{
    self.app = nil;
    self.CPU = nil;
    self.proc_cpu = nil;
    self.app = nil;
}

- (pid_t)pid{
    pid_t current_pid = self.app.processIdentifier;
    return current_pid;
}

- (uid_t)ownerUserID
{
    uid_t _uid = 0;
    
    pid_t current_pid = self.pid;
    struct kinfo_proc proc_info;
    int ctl_args[4] = {
        CTL_KERN, KERN_PROC, KERN_PROC_PID, current_pid
    };
    size_t info_size = sizeof(proc_info);
    int err = sysctl(ctl_args, 4, &proc_info, &info_size, NULL, 0);
    if (err == KERN_SUCCESS && info_size > 0) {
        _uid = proc_info.kp_eproc.e_ucred.cr_uid;
    }
    
    return _uid;
}

- (NSString*)owner{
    
    if(_owner == nil){
        _owner = [self ownerName];
    }
    return _owner;
}

- (NSString*)ownerName
{
    struct passwd user_data, *tmp = NULL;
    uid_t user_id = [self ownerUserID];
    if (user_id == -1) {
        return @"";
    }
    char* buffer = malloc(sizeof(*buffer) * kPasswdBufferSize);
    int err = getpwuid_r(user_id, &user_data, buffer, kPasswdBufferSize, &tmp);
    if (err != KERN_SUCCESS) {
        free(buffer);
        return @"";
    }
    
    NSString *_owner_user_name = [[NSString stringWithUTF8String: user_data.pw_name] copy];
    
    free(buffer);
    
    return _owner_user_name;
}

- (void)update{
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [self upadteCPUUsage];
        [self owner];
    });
    
}

- (bool)upadteCPUUsage{
    struct proc_taskinfo pti;
    struct timeval tv;
    
    if(self.proc_cpu==nil){
        self.proc_cpu=[NSNumber numberWithUnsignedLongLong:0];
        self.sys_time=[NSNumber numberWithUnsignedLongLong:0];
    }
    
    gettimeofday(&tv, NULL);
    int rsize=proc_pidinfo(self.pid, PROC_PIDTASKINFO, 0, &pti, sizeof(pti));
    if (rsize <= 0) {
        return NO;
    }
    NSNumber *sys_time2 = [NSNumber numberWithUnsignedLongLong:((tv.tv_sec*1000000L)+tv.tv_usec)];
    double sys_diff = (double)[sys_time2 unsignedLongLongValue]-[self.sys_time unsignedLongLongValue];
    self.sys_time = sys_time2;
    NSNumber *proc_cpu2 = [NSNumber numberWithUnsignedLongLong:(pti.pti_total_user + pti.pti_total_system)/10];
    
    double proc_diff = (double)[proc_cpu2 unsignedLongLongValue]-[self.proc_cpu unsignedLongLongValue];
    self.proc_cpu = proc_cpu2;
    
    _CPU = [NSNumber numberWithDouble:(proc_diff/sys_diff)];
    
    return YES;
}

-(NSNumber *)CPU{
    return _CPU;
}

-(NSString *)CPUUsage{
    if(_CPU == nil){
        [self upadteCPUUsage];
    }
    if(_CPU != nil){
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setFormat:@"##0.0"];
        NSString *inUse = [formatter stringFromNumber:_CPU];
        return [NSString stringWithFormat:@"%@%%",inUse];
    }
    return @"";
}


@end
