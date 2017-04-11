//
//  process_manager_helper.m
//  process manager helper
//
//  Created by sheen vempeny on 2/27/17.
//  Copyright © 2017 sheen vempeny. All rights reserved.
//

#import "process_manager_helper.h"

@interface  process_manager_helper()

@property (nonatomic,strong)  NSMutableDictionary *prefs;

@end

@implementation process_manager_helper

- (void)setupDefaults{
    
    NSDictionary *inPrefs = [[NSUserDefaults standardUserDefaults]
                             persistentDomainForName:[[NSBundle bundleForClass:[self class]]
                                                      bundleIdentifier]];
    self.prefs = [NSMutableDictionary dictionaryWithDictionary:inPrefs];
    
}

- (void)dealloc
{
    self.prefs = nil;
}

- (void)mainViewDidLoad
{
    [self setupDefaults];
    [self updateSelectionToUI:[self currentSel]];
}

- (void)updateSelectionToUI:(NSInteger)selection{
    
    if(selection == 0){
        [self.btnMyOwn setState:NSOffState];
        [self.btnAll setState:NSOnState];
    }
    else{
        [self.btnAll setState:NSOffState];
        [self.btnMyOwn setState:NSOnState];
    }
}

- (IBAction)selChanged:(NSButton*)sender{
    NSInteger sel = [sender tag];
    [self updateSelectionToUI:sel];
    [self updateSelToDefaults:sel];
}

- (NSInteger)currentSel{
    
    NSInteger val = [[self.prefs objectForKey:@"showSelection"] integerValue];
    return val;
}

- (void)updateSelToDefaults:(NSInteger)val{
    
    [self.prefs setObject:[NSNumber numberWithInteger:val] forKey:@"showSelection"];
    [[NSUserDefaults standardUserDefaults]
     removePersistentDomainForName:[[NSBundle bundleForClass:
                                     [self class]] bundleIdentifier]];
    [[NSUserDefaults standardUserDefaults] setPersistentDomain:self.prefs
                                                       forName:[[NSBundle bundleForClass:[self class]] bundleIdentifier]];
    
}


@end
