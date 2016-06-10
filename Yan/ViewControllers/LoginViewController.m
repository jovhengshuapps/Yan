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
    NSString *deviceToken = ((AppDelegate*)[UIApplication sharedApplication].delegate).deviceToken;
    [self callAPI:API_USER_LOGIN withParameters:@{
                                                     @"username": self.textFieldUsername.text,
                                                     @"password": self.textFieldPassword.text,
                                                     @"device_token": deviceToken,
                                                     @"device_type":@"ios"
                                                     } completionNotification:@"loginCompletedObserver"];
}

- (void)loginSuccessful:(NSNotification*)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification.name object:nil];
    id response = notification.object;
    if ([response isKindOfClass:[NSError class]] || [response isKindOfClass:[NSURLErrorDomain class]] || ([response isKindOfClass:[NSDictionary class]] && [[response allKeys] containsObject:@"error"])) {
        
        [self showTitleBar:@"SIGN IN"];
        return;
    }
    if (response[@"token"]) {
        if ([self saveLoggedInAccount:self.textFieldUsername.text :self.textFieldPassword.text :response[@"name"] :response[@"birthday"] :response[@"token"] :response[@"uid"]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:ChangeHomeViewToShow object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else {
        
    }
    
}

- (void)alertView:(AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    NSLog(@"Clicked index:%li",(long)buttonIndex);
}

- (IBAction)showRegister:(id)sender {
//    RegisterViewController *registerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"registerForm"];
//    [self.navigationController pushViewController:registerViewController animated:YES];
}
- (IBAction)showForgotPassword:(id)sender {
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
