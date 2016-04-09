//
//  RegistrationCompleteViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 4/9/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "RegistrationCompleteViewController.h"
#import "HomeViewController.h"

@interface RegistrationCompleteViewController ()

@end

@implementation RegistrationCompleteViewController

- (void)viewDidLoad {
    
    
    UIBarButtonItem *menuBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"app-menu.png"] style:UIBarButtonItemStyleDone target:self action:@selector(openMenu)];
    
    [[self navigationItem] setLeftBarButtonItem:menuBarItem];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    
}

//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    
//}


@end
