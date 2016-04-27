//
//  ReserveRestoViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 4/19/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "ReserveRestoViewController.h"
#import "RestaurantDetailsViewController.h"

@interface ReserveRestoViewController ()

@end

@implementation ReserveRestoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
    
    [button addTarget:self action:@selector(showRestaurantDetails) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *detailsItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [[self navigationItem] setRightBarButtonItem:detailsItem];


}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showTitleBar:@"RESERVATION"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) showRestaurantDetails {
    
    RestaurantDetailsViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"restaurantDetails"];
    [self.navigationController pushViewController:details animated:YES];
}

@end
