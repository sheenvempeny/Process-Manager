//
//  ViewController.h
//  process manager
//
//  Created by sheen vempeny on 2/26/17.
//  Copyright © 2017 sheen vempeny. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (nonatomic,weak) IBOutlet NSTableView *tableView;
@property (nonatomic,weak) IBOutlet NSButton *btnKill;

-(IBAction)killApp:(id)sender;

@end

