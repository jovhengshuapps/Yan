//
//  OrderMenuViewController.m
//  Yan
//
//  Created by IOS Developer on 05/04/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "OrderMenuViewController.h"

@interface OrderMenuViewController()

@property(strong,nonatomic) NSDictionary *rawData;

@end

@implementation OrderMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _rawData = [self getMenuForRestaurant:@"dummy"];
    // Array containing Dictionaries containining Items.
    // This nested table view only supports two level of sections.
    CollapseMenuView *collapseMenuView = [[CollapseMenuView alloc] initWithPosition:CollapseMenuViewPositionBottom content:[self extractMenuContent]];
    collapseMenuView.delegate = self;
//    collapseMenuView.content = @{@"DESSERT":@{@"CAKE":@[@"SANZRIVAL",@"CHOCOLATE",@"MOCHA"],@"FRUITS":@[@"PINEAPPLE",@"PEACH"]},@"MAIN COURSE":@{@"BEEF":@[@"STEAK",@"ROAST BEEF"],@"FISH":@[@"FILLET"]},@"DRINKS":@{@"JUICES":@[@"MANGO",@"LEMONADE"],@"COFFEE":@[@"INSTANT COFFEE",@"MOCHACCINO",@"CAPUCCINO",@"FRAPUCCINO"]}};
    
//    collapseMenuView.content = [self extractMenuContent];
    
    collapseMenuView.cellHeight = 44.0f;
    
    [self.view addSubview:collapseMenuView];
    [self.view layoutSubviews];
}

- (NSDictionary*) extractMenuContent {
    NSMutableDictionary *data = [NSMutableDictionary new];
    
    for (NSDictionary *category in [_rawData objectForKey:@"categories"]) {
        NSString *categoryName = [category objectForKey:@"name"];
        NSMutableArray *categoryItems = [NSMutableArray new];
        for (NSDictionary *item in [category objectForKey:@"menu"]) {
            [categoryItems addObject:item];
        }
        [data setObject:(NSArray*)categoryItems forKey:categoryName];
    }
    
    return data;
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
