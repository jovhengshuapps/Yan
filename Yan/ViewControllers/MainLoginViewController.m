//
//  MainLoginViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 4/7/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "MainLoginViewController.h"
#import "Account.h"

@interface MainLoginViewController()
@property (weak, nonatomic) IBOutlet UIButton *loginButton; //facebook
@property(weak, nonatomic) IBOutlet GIDSignInButton *signInButton; //google

@property (weak, nonatomic) IBOutlet UIButton *googleLoginButton; //google

@property (strong, nonatomic) NSMutableDictionary *socialAccount;

@end


@implementation MainLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        // TODO:Token is already available.
    }
    
    [GIDSignIn sharedInstance].uiDelegate = self;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self showTitleBar:@"SIGN IN"];
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    
}

- (BOOL)loginButtonWillLogin:(FBSDKLoginButton *)loginButton {
    return YES;
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    
}
- (IBAction)loginWithFacebook:(id)sender {
//    NSLog( @"### running FB sdk version: %@", [FBSDKSettings sdkVersion] );
    
    if ([FBSDKAccessToken currentAccessToken]) {
        [self getYanAccountFromFacebook];
    }
    else {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        login.loginBehavior = FBSDKLoginBehaviorWeb;
        
        [login
         logInWithReadPermissions: @[@"public_profile",@"email",@"user_birthday"]
         fromViewController:self
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
             if (error) {
                 NSLog(@"Process error");
             } else if (result.isCancelled) {
                 NSLog(@"Cancelled");
             } else {
                 NSLog(@"Logged in Facebook");
                 [self getYanAccountFromFacebook];
             }
         }];
    }
    
    
}

- (void) getYanAccountFromFacebook {
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me"
                                  parameters:@{ @"fields": @"id,name,email,birthday,gender",}
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            _socialAccount = nil;
            _socialAccount = [[NSMutableDictionary alloc] init];
            _socialAccount[@"fullname"] = result[@"name"];
            _socialAccount[@"username"] = result[@"email"];
            _socialAccount[@"birthday"] = result[@"birthday"];
            _socialAccount[@"password"] = [self passwordForName:result[@"name"] email:result[@"email"] birthday:result[@"birthday"] gender:result[@"gender"]];
            
//            NSLog(@"fetched user:%@\n\naccount:%@", result,_socialAccount);
            [self showTitleBar:@"Logging in to Yan!"];
            self.view.userInteractionEnabled = NO;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessful:) name:@"socialLoginObserver" object:nil];
            [self callAPI:API_USER_LOGIN withParameters:@{
                                                          @"username": _socialAccount[@"username"],
                                                          @"password": _socialAccount[@"password"]
                                                          } completionNotification:@"socialLoginObserver"];
        }
    }];
}

- (void)loginSuccessful:(NSNotification*)notification {
    id response = notification.object;
    if ([response isMemberOfClass:[NSError class]]) {
        
        [self showTitleBar:@"SIGN IN"];
        self.view.userInteractionEnabled = YES;
        return;
    }
    if (response[@"token"]){
        if ([self saveLoggedInAccount:_socialAccount[@"username"] :_socialAccount[@"password"] :_socialAccount[@"fullname"] :_socialAccount[@"birthday"] :response[@"token"]]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } else {
        
        [self showTitleBar:@"Creating Yan! account"];
        self.view.userInteractionEnabled = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerCompletedMethod:) name:@"registerCompletedObserver" object:nil];
        [self callAPI:API_USER_REGISTER withParameters:@{
                                                         @"user_email": _socialAccount[@"username"],
                                                         @"user_password": _socialAccount[@"password"],
                                                         @"full_name": _socialAccount[@"fullname"],
                                                         @"birthday": _socialAccount[@"birthday"]
                                                         } completionNotification:@"registerCompletedObserver"];
    }
    
    
}


- (void)registerCompletedMethod:(NSNotification*)notification {
    id response = notification.object;
    if ([response isMemberOfClass:[NSError class]]) {
        
        [self showTitleBar:@"SIGN IN"];
        self.view.userInteractionEnabled = YES;
        return;
    }
    if ([self saveLoggedInAccount:_socialAccount[@"username"] :_socialAccount[@"password"] :_socialAccount[@"fullname"] :_socialAccount[@"birthday"] :response[@"token"]]) {
        self.view.userInteractionEnabled = YES;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)loginWithGoogle:(id)sender {
    GIDSignIn *google = [GIDSignIn sharedInstance];
    google.delegate = self;
    google.uiDelegate = self;
    google.allowsSignInWithWebView = YES;
    google.allowsSignInWithBrowser = YES;
    google.shouldFetchBasicProfile = YES;
    
    [google signIn];
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
//    NSLog(@"userGoogle:%@ | %@ | %@ | %@",user.profile.email,user.profile.name,user.profile.givenName,user.profile.familyName);
    if (!user) {
        return;
    }
    _socialAccount = nil;
    _socialAccount = [[NSMutableDictionary alloc] init];
    _socialAccount[@"fullname"] = user.profile.name;
    _socialAccount[@"username"] = user.profile.email;
    _socialAccount[@"birthday"] = @"01/01/1970";
    _socialAccount[@"password"] = [self passwordForName:user.profile.name email:user.profile.email birthday:@"01/01/1970" gender:@"unknown"];
    
    NSLog(@"account:%@", _socialAccount);
    [self showTitleBar:@"Logging in to Yan!"];
    self.view.userInteractionEnabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessful:) name:@"socialLoginObserver" object:nil];
    [self callAPI:API_USER_LOGIN withParameters:@{
                                                  @"username": _socialAccount[@"username"],
                                                  @"password": _socialAccount[@"password"]
                                                  } completionNotification:@"socialLoginObserver"];
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

- (NSString*)passwordForName:(NSString*)name email:(NSString*)email birthday:(NSString*)birthday gender:(NSString*)gender{
    NSMutableString * password = [NSMutableString new];
    
    NSString *emailAdd = [email substringToIndex:[email rangeOfString:@"@"].location];
    
    NSString *bday = [birthday stringByReplacingOccurrencesOfString:@"/" withString:@""];
    bday = [bday stringByReplacingOccurrencesOfString:@"0" withString:@"_"];
    
    NSInteger index = 0;
    
    for (NSString *string1 in [name componentsSeparatedByString:@" "]) {
        [password appendString:[string1 substringToIndex:1]];
        index += 1;
        if ((emailAdd.length-index) <= -1) {
            [password appendFormat:@"%c",[emailAdd characterAtIndex:emailAdd.length-index]];
        }
        else {
            [password appendString:@"*"];
        }
        
        if ((bday.length-index) <= -1) {
            [password appendFormat:@"%c",[bday characterAtIndex:bday.length-index]];
        }
        else {
            [password appendString:@"!"];
        }
        
        if ((gender.length-index) <= -1) {
            [password appendFormat:@"%c",[gender characterAtIndex:gender.length-index]];
        }
        else {
            [password appendString:@"#"];
        }
        
    }
    
    return password;
}







@end
