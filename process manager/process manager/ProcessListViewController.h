//
//  ProcessListViewController.h
//  process manager
//
//  Created by sheen vempeny on 2/26/17.
//  Copyright © 2017 sheen vempeny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>


@interface ProcessListViewController : NSObject

@property (nonatomic,weak) NSTableView *tableView;
@property (nonatomic,strong) NSArray *items;
@property (nonatomic,weak) NSButton *btnKill;

- (NSRunningApplication*)selectedApp;
- (void)reload;

@end
