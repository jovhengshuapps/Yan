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
    CollapseMenuView *collapseMenuView = [[CollapseMenuView alloc] initWithContent:[self extractMenuContent]];
    collapseMenuView.delegate = self;
    
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
