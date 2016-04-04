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
    [super viewDidLoad];
    
    [self hideTitleBar];
    
    //check if logged in
    if (![self userLoggedIn]) {
        [self.navigationController performSegueWithIdentifier:@"showLogin" sender:self];
    }
    
}

@end
