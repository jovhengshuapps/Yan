//
//  LoginViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 3/31/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"

@interface LoginViewController()
@property (weak, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showTitleBar:@"SIGN IN"];
}

- (IBAction)loginPressed:(id)sender {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessful:) name:@"loginCompletedObserver" object:nil];
    [self callAPI:API_USER_LOGIN withParameters:@{
                                                     @"username": self.textFieldUsername.text,
                                                     @"password": self.textFieldPassword.text
                                                     } completionNotification:@"loginCompletedObserver"];
}

- (void)loginSuccessful:(NSNotification*)notification {
    id response = notification.object;
    if ([self saveLoggedInAccount:self.textFieldUsername.text :self.textFieldPassword.text :@"" :@"" :response[@"token"]]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
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
