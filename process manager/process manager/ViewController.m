//
//  ViewController.m
//  process manager
//
//  Created by sheen vempeny on 2/26/17.
//  Copyright © 2017 sheen vempeny. All rights reserved.
//

#import "ViewController.h"
#import "ProcessListViewController.h"
#import "ProcessManager.h"

typedef enum : NSUInteger {
    showAll = 0,
    showMyOwn = 1,
    
} eShowOptions;


@interface  ViewController()

@property (nonatomic,strong) ProcessListViewController *listController;
@property (nonatomic,strong) ProcessManager *procManager;
@property (nonatomic,assign) eShowOptions showOption;


@end

@implementation ViewController


- (void)observeChanges{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveChanges:)
                                                 name:NSApplicationWillTerminateNotification
                                               object:nil];
}


- (void) saveChanges:(NSNotification*)aNotification {
    [self fillShowOption];
}

- (void)fillShowOption{
    
    NSDictionary *prefs  = [[NSUserDefaults standardUserDefaults] persistentDomainForName:[[NSBundle bundleForClass:[self class]]bundleIdentifier]];
    NSInteger val = [[prefs objectForKey:@"showSelection"] integerValue];
    self.showOption = (eShowOptions)val;
    [self fillItems];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self observeChanges];
    // Do any additional setup after loading the view.
    self.procManager = [[ProcessManager alloc] initWithRefreshBlock:^{
        [self fillShowOption];
    }];
   
    self.listController = [ProcessListViewController new];
    self.listController.btnKill = self.btnKill;
    self.listController.tableView = self.tableView;
    self.listController.items = [self.procManager allProcess];
}

- (void)fillItems{
    NSArray *items = nil;
    if(self.showOption == showAll){
        items = [self.procManager allProcess];
    }
    else{
       items = [self.procManager userProcess];
    }
    
    self.listController.items = items;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:NSApplicationWillTerminateNotification object:nil];
     
    self.procManager = nil;
    self.listController = nil;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

-(IBAction)killApp:(id)sender{
    
    NSRunningApplication *selApp = self.listController.selectedApp;
    NSAlert *alert = [[NSAlert alloc] init];
    NSString *message = [NSString stringWithFormat:@"%@%@?",@"Do you want to kill  ",selApp.localizedName];
    [alert setMessageText:message];
    message = [NSString stringWithFormat:@"%@ %@",selApp.localizedName,@"wil quit"];
    [alert setInformativeText:message];
    [alert addButtonWithTitle:@"Yes"];
    [alert addButtonWithTitle:@"NO"];
    [alert setAlertStyle:NSWarningAlertStyle];
    
    [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSAlertFirstButtonReturn) {
            
             [self.procManager kill:self.listController.selectedApp];
        }
        
    }];
    
}

@end
