//
//  OrderMenuViewController.m
//  Yan
//
//  Created by IOS Developer on 05/04/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "OrderMenuViewController.h"

@implementation OrderMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Array containing Dictionaries containining Items.
    // This nested table view only supports two level of sections.
    CollapseMenuView *collapseMenuView = [[CollapseMenuView alloc] initWithPosition:CollapseMenuViewPositionBottom];
    collapseMenuView.delegate = self;
//    collapseMenuView.content = @{@"DESSERT":@{@"CAKE":@[@"SANZRIVAL",@"CHOCOLATE",@"MOCHA"],@"FRUITS":@[@"PINEAPPLE",@"PEACH"]},@"MAIN COURSE":@{@"BEEF":@[@"STEAK",@"ROAST BEEF"],@"FISH":@[@"FILLET"]},@"DRINKS":@{@"JUICES":@[@"MANGO",@"LEMONADE"],@"COFFEE":@[@"INSTANT COFFEE",@"MOCHACCINO",@"CAPUCCINO",@"FRAPUCCINO"]}};
    
    collapseMenuView.content = @{@"DESSERT":@[@"SANZRIVAL",@"CHOCOLATE",@"MOCHA",@"PINEAPPLE",@"PEACH"],@"MAIN COURSE":@[@"STEAK",@"ROAST BEEF",@"FILLET"],@"DRINKS":@[@"MANGO",@"LEMONADE",@"INSTANT COFFEE",@"MOCHACCINO",@"CAPUCCINO",@"FRAPUCCINO"]};
    
    collapseMenuView.cellHeight = 44.0f;
    [self.view addSubview:collapseMenuView];
    [self.view layoutSubviews];
}

- (void)selectedIndex:(NSInteger)index {
    NSLog(@"SELECTED:%li",(long)index);
}

- (void)collapsedMenuShown:(BOOL)shown {
//    if (shown) {
//        self.frostedViewController.panGestureEnabled = NO;
//    }
//    else {
//        self.frostedViewController.panGestureEnabled = YES;
//    }
}


@end
