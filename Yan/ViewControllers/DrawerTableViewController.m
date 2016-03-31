//
//  DrawerTableViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 3/31/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "DrawerTableViewController.h"

@interface DrawerTableViewController ()

@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation DrawerTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _titlesArray = @[@"Style Scale From Big",
                     @"Style Slide Above",
                     @"Style Slide Below",
                     @"Style Scale From Little",
                     @"Landscape always visible",
                     @"Status bar always visible",
                     @"Status bar light content",
                     @"Custom style"];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titlesArray.count;
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    cell.textLabel.text = _titlesArray[indexPath.row];
    
    return cell;
}

@end