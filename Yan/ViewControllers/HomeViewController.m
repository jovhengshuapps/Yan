//
//  HomeViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 4/4/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"

@implementation HomeViewController

- (void)viewDidLoad {
    
    UIBarButtonItem *menuBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"app-menu.png"] style:UIBarButtonItemStyleDone target:self action:@selector(openMenu)];
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Yan"];
    [item setLeftBarButtonItem:menuBarItem];
    
    [self.navigationController.navigationBar setItems:[NSArray arrayWithObjects:item, nil] animated:YES];
    
    [super viewDidLoad];
    
    
    //check if logged in
    if (![self userLoggedIn]) {
        [self.navigationController performSegueWithIdentifier:@"showLogin" sender:self];
    }
    
}

@end
