//
//  OrderMenuViewController.m
//  Yan
//
//  Created by IOS Developer on 05/04/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "OrderMenuViewController.h"
#import "CollapseMenuView.h"

@implementation OrderMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Array containing Dictionaries containining Items.
    // This nested table view only supports two level of sections.
    CollapseMenuView *collapseMenuView = [[CollapseMenuView alloc] initWithPosition:CollapseMenuViewPositionBottom];
//    collapseMenuView.delegate = self;
    collapseMenuView.arrayContent = @[@{@"All":@[@{@"Sports":@[@"Baseball", @"Softball", @"Cricket"]}, @{@"Engineering":@[@"Software Engineer", @"Electrical Engineer"]}]}];
    collapseMenuView.sectionHeaders = @[@{@"All":@[@"Sports", @"Engineering"]}];
    collapseMenuView.cellHeight = 44.0f;
    [self.view addSubview:collapseMenuView];
    [self.view layoutSubviews];
}
@end
