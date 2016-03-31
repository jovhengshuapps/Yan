//
//  LoginViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 3/31/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIBarButtonItem *menuBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"app-menu.png"] style:UIBarButtonItemStyleDone target:self action:@selector(openMenu)];
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Yan"];
    [item setLeftBarButtonItem:menuBarItem];
    
    [self.navigationController.navigationBar setItems:[NSArray arrayWithObjects:item, nil] animated:YES];
}

-(void) openMenu {
    NSLog(@"LEFT:%@",(((RootViewController *)[UIApplication sharedApplication].delegate.window.rootViewController).leftView != nil)?@"YES":@"NO");
    [(RootViewController *)[UIApplication sharedApplication].delegate.window.rootViewController showLeftViewAnimated:YES completionHandler:nil];
}
@end
