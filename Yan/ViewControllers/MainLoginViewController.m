//
//  MainLoginViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 4/7/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "MainLoginViewController.h"

@interface MainLoginViewController()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end


@implementation MainLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        // TODO:Token is already available.
    }
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    
}

- (BOOL)loginButtonWillLogin:(FBSDKLoginButton *)loginButton {
    return YES;
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    
}
- (IBAction)loginWithFacebook:(id)sender {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    login.loginBehavior = FBSDKLoginBehaviorWeb;
    [login
     logInWithReadPermissions: @[@"public_profile",@"email"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
         }
     }];
    
    
}

@end
