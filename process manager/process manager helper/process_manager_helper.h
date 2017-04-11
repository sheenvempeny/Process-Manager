//
//  process_manager_helper.h
//  process manager helper
//
//  Created by sheen vempeny on 2/27/17.
//  Copyright © 2017 sheen vempeny. All rights reserved.
//

#import <PreferencePanes/PreferencePanes.h>
#import <Cocoa/Cocoa.h>

@interface process_manager_helper : NSPreferencePane

@property (nonatomic,weak) IBOutlet NSButton *btnAll;
@property (nonatomic,weak) IBOutlet NSButton *btnMyOwn;

- (void)mainViewDidLoad;

- (IBAction)selChanged:(id)sender;

@end
