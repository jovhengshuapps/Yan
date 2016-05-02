//
//  ReserveCompleteViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 4/19/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "ReserveCompleteViewController.h"

@interface ReserveCompleteViewController ()

@end

@implementation ReserveCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setFrame:CGRectMake(0.0f, 0.0f, 45.0f, 30.0f)];
    
    [button setImage:[UIImage imageNamed:@"waiter-icon-normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"waiter-icon-highlighted"] forState:UIControlStateHighlighted];
        
    [button addTarget:self action:@selector(showWaiterView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *waiterItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [[self navigationItem] setRightBarButtonItem:waiterItem];
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self showTitleBar:@"CONFIRMATION"];
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
- (IBAction)closeButton:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) showWaiterView {
    
}

@end
