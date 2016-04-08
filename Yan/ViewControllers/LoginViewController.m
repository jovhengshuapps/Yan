//
//  LoginViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 3/31/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"


@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.buttonLogin.layer.cornerRadius = 5.0f;
    
    [self showTitleBar:@"SIGN IN"];
    
}
- (IBAction)loginPressed:(id)sender {
    AlertView *alert = [[AlertView alloc] initAlertWithMessage:@"This is a text message\n\nThank you!" delegate:self buttons:@[@"OK",@"Close"]];
    [alert showAlertView];
}

- (void)alertView:(AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"Clicked index:%li",(long)buttonIndex);
}

- (IBAction)showRegister:(id)sender {
//    RegisterViewController *registerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"registerForm"];
//    [self.navigationController pushViewController:registerViewController animated:YES];
}
- (IBAction)showForgotPassword:(id)sender {
}

@end
