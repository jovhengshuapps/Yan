//
//  MainLoginViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 4/7/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "MainLoginViewController.h"

@interface MainLoginViewController()
@property (weak, nonatomic) IBOutlet UIButton *loginButton; //facebook
@property(weak, nonatomic) IBOutlet GIDSignInButton *signInButton; //google

@property (weak, nonatomic) IBOutlet UIButton *googleLoginButton; //google

@end


@implementation MainLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        // TODO:Token is already available.
    }
    
    [self showTitleBar:@"SIGN IN"];
    
    [GIDSignIn sharedInstance].uiDelegate = self;

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
- (IBAction)loginWithGoogle:(id)sender {
    [[GIDSignIn sharedInstance] signIn];
}

//// Stop the UIActivityIndicatorView animation that was started when the user
//// pressed the Sign In button
//- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
////    [myActivityIndicator stopAnimating];
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//}
//
//// Present a view that prompts the user to sign in with Google
//- (void)signIn:(GIDSignIn *)signIn
//presentViewController:(UIViewController *)viewController {
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//    [self presentViewController:viewController animated:YES completion:nil];
//}
//
//// Dismiss the "Sign in with Google" view
//- (void)signIn:(GIDSignIn *)signIn
//dismissViewController:(UIViewController *)viewController {
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

- (IBAction)didTapSignOut:(id)sender {
    [[GIDSignIn sharedInstance] signOut];
}
@end
