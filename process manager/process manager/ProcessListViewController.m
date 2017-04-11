//
//  ProcessListViewController.m
//  process manager
//
//  Created by sheen vempeny on 2/26/17.
//  Copyright © 2017 sheen vempeny. All rights reserved.
//

#import "ProcessListViewController.h"
#import "ProcessInfo.h"
#import "NSRunningApplication+Adds.h"

@interface ProcessListViewController () <NSTableViewDelegate,NSTableViewDataSource>

@end

@implementation ProcessListViewController

- (void)reload{
    
    [self.tableView reloadData];
}

- (void)setItems:(NSArray *)items{
    
    _items = items;
    self.btnKill.enabled = NO;
    [self reload];
}

- (void)setTableView:(NSTableView *)tableView{
    
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    
    return self.items.count;
}
- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:nil];
    cellView.textField.stringValue = [self valueForCol:tableColumn forRow:row];
    
    return cellView;
}

- (void)tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray *)oldDescriptors
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.items];
    [array sortUsingDescriptors: [tableView sortDescriptors]];
    self.items = array;
    [tableView reloadData];
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn
                                                                  *)tableColumn row:(NSInteger)row{
    
    NSRunningApplication *app = [self.items objectAtIndex:row];
    return app;
}

- (NSString*)valueForCol:(NSTableColumn*)col forRow:(NSInteger)row{
    
    NSRunningApplication *app = [self.items objectAtIndex:row];
    NSString *returnVal = @"";
    int colValue = [col.identifier intValue];
    switch (colValue) {
        case 1:
            returnVal = app.localizedName;
            break;
        case 2:
            returnVal = app.CPUUsage;
            break;
        case 3:
            returnVal = app.userName;
            break;
        case 4:
            returnVal = [NSString stringWithFormat:@"%d",app.processIdentifier];
            break;

        default:
            break;
    }
    
    return returnVal;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)rowIndex {
    self.btnKill.enabled = YES;
    return YES;
}

- (NSRunningApplication*)selectedApp{
    
    NSInteger selectedRow = self.tableView.selectedRow;
    NSRunningApplication *app = nil;
    if(selectedRow >= 0){
        
        app = [self.items objectAtIndex:selectedRow];
    }
    
    return app;
}

@end
