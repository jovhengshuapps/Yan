//
//  HomeViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 4/4/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"

@interface HomeViewController()
@property (weak, nonatomic) IBOutlet UIView *viewDefaultHome;
@property (weak, nonatomic) IBOutlet UIView *viewRegistrationComplete;
@property (weak, nonatomic) IBOutlet UIView *viewNotificationReminder;
@property (weak, nonatomic) IBOutlet UIView *viewLogin;

@property (weak, nonatomic) IBOutlet UIButton *loginButton; //facebook
@property (weak, nonatomic) IBOutlet UIButton *googleLoginButton; //google

@property (strong, nonatomic) NSMutableDictionary *socialAccount;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeView:) name:ChangeHomeViewToShow object:nil];
    
    
    
    [super viewDidLoad];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self userLoggedIn]) {
        UIBarButtonItem *menuBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"app-menu.png"] style:UIBarButtonItemStyleDone target:self action:@selector(openMenu)];
        
        [[self navigationItem] setLeftBarButtonItem:menuBarItem];
        if (!(self.viewToShow == HomeViewRegistrationComplete || self.viewToShow == HomeViewNotification || self.viewToShow == HomeViewLogin)) {
            
            self.frostedViewController.panGestureEnabled = YES;
            _viewDefaultHome.hidden = NO;
        }
    }
    else {
        [self.navigationItem setLeftBarButtonItem:nil];
        self.frostedViewController.panGestureEnabled = NO;
        _viewLogin.hidden = NO;
        
        
        if ([FBSDKAccessToken currentAccessToken]) {
            // TODO:Token is already available.
        }
        
        [GIDSignIn sharedInstance].uiDelegate = self;
        
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if ([self userLoggedIn]) {
    [[NSNotificationCenter defaultCenter] postNotificationName:ChangeHomeViewToShow object:nil];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:ChangeHomeViewToShow object:@"HomeViewLogin"];
            
    }
    
}

- (void) changeView:(NSNotification*)notification {
    [self.navigationItem setPrompt:nil];
    if ([notification.object isEqualToString:@"HomeViewNotification"]) {
        self.viewToShow = HomeViewNotification;
        _viewDefaultHome.hidden = YES;
        _viewRegistrationComplete.hidden = YES;
        _viewLogin.hidden = YES;
        _viewNotificationReminder.hidden = NO;
        
        UIBarButtonItem *menuBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"app-menu.png"] style:UIBarButtonItemStyleDone target:self action:@selector(openMenu)];
        
        [[self navigationItem] setLeftBarButtonItem:menuBarItem];
        self.frostedViewController.panGestureEnabled = YES;
    }
    else if ([notification.object isEqualToString:@"HomeViewRegistrationComplete"]) {
        self.viewToShow = HomeViewRegistrationComplete;

        _viewDefaultHome.hidden = YES;
        _viewRegistrationComplete.hidden = NO;
        _viewLogin.hidden = YES;
        _viewNotificationReminder.hidden = YES;
        
        UIBarButtonItem *menuBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"app-menu.png"] style:UIBarButtonItemStyleDone target:self action:@selector(openMenu)];
        
        [[self navigationItem] setLeftBarButtonItem:menuBarItem];
        self.frostedViewController.panGestureEnabled = YES;
    }
    else if ([notification.object isEqualToString:@"HomeViewLogin"]) {
        self.viewToShow = HomeViewLogin;
        
        _viewDefaultHome.hidden = YES;
        _viewRegistrationComplete.hidden = YES;
        _viewLogin.hidden = NO;
        _viewNotificationReminder.hidden = YES;
        
        [self.navigationItem setLeftBarButtonItem:nil];
        self.frostedViewController.panGestureEnabled = NO;
    }
    else {
        _viewDefaultHome.hidden = NO;
        _viewRegistrationComplete.hidden = YES;
        _viewLogin.hidden = YES;
        _viewNotificationReminder.hidden = YES;
        
        UIBarButtonItem *menuBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"app-menu.png"] style:UIBarButtonItemStyleDone target:self action:@selector(openMenu)];
        
        [[self navigationItem] setLeftBarButtonItem:menuBarItem];
        self.frostedViewController.panGestureEnabled = YES;
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
//            [self showTitleBar:@"Logging in to Yan!"];
            [self.navigationItem setPrompt:@"Logging in to Yan!"];
            self.view.userInteractionEnabled = NO;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessful:) name:@"socialLoginObserver" object:nil];
            [self callAPI:API_USER_LOGIN withParameters:@{
                                                          @"username": _socialAccount[@"username"],
                                                          @"password": _socialAccount[@"password"]
                                                          } completionNotification:@"socialLoginObserver"];
        }
    }];
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
    
//    NSLog(@"account:%@", _socialAccount);
    [self.navigationItem setPrompt:@"Logging in to Yan!"];
    self.view.userInteractionEnabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gloginSuccessful:) name:@"socialLoginObserver" object:nil];
    [self callAPI:API_USER_LOGIN withParameters:@{
                                                  @"username": _socialAccount[@"username"],
                                                  @"password": _socialAccount[@"password"]
                                                  } completionNotification:@"socialLoginObserver"];
}


- (void)loginSuccessful:(NSNotification*)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification.name object:nil];
    id response = notification.object;
    if ([response isMemberOfClass:[NSError class]]) {
        
        //        [self showTitleBar:@"SIGN IN"];
        self.view.userInteractionEnabled = YES;
        return;
    }
    if (response[@"token"]){
        if ([self saveLoggedInAccount:_socialAccount[@"username"] :_socialAccount[@"password"] :_socialAccount[@"fullname"] :_socialAccount[@"birthday"] :response[@"token"] :response[@"uid"]]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            self.view.userInteractionEnabled = YES;
            [self changeView:nil];
        }
    } else {
        
        [self.navigationItem setPrompt:@"Creating Yan! account"];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification.name object:nil];
    id response = notification.object;
    [self.navigationItem setPrompt:nil];
    if ([response isMemberOfClass:[NSError class]] || ([response isKindOfClass:[NSDictionary class]] && [[response allKeys] containsObject:@"error"])) {
        
        //        [self showTitleBar:@"SIGN IN"];
        self.view.userInteractionEnabled = YES;
        return;
    }
    if ([self saveLoggedInAccount:_socialAccount[@"username"] :_socialAccount[@"password"] :_socialAccount[@"fullname"] :_socialAccount[@"birthday"] :response[@"token"] :response[@"uid"]]) {
        self.view.userInteractionEnabled = YES;
        [self.navigationController popToRootViewControllerAnimated:YES];
        self.view.userInteractionEnabled = YES;
        [self changeView:nil];
    }
}

- (void)gloginSuccessful:(NSNotification*)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification.name object:nil];
    id response = notification.object;
    if ([response isMemberOfClass:[NSError class]]) {
        
//        [self showTitleBar:@"SIGN IN"];
        self.view.userInteractionEnabled = YES;
        return;
    }
    if (response[@"token"]){
        if ([self saveLoggedInAccount:_socialAccount[@"username"] :_socialAccount[@"password"] :_socialAccount[@"fullname"] :_socialAccount[@"birthday"] :response[@"token"] :response[@"uid"]]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            self.view.userInteractionEnabled = YES;
            [self changeView:nil];
        }
    } else {
        
        [self.navigationItem setPrompt:@"Creating Yan! account"];
        self.view.userInteractionEnabled = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gregisterCompletedMethod:) name:@"registerCompletedObserver" object:nil];
        [self callAPI:API_USER_REGISTER withParameters:@{
                                                         @"user_email": _socialAccount[@"username"],
                                                         @"user_password": _socialAccount[@"password"],
                                                         @"full_name": _socialAccount[@"fullname"],
                                                         @"birthday": _socialAccount[@"birthday"]
                                                         } completionNotification:@"registerCompletedObserver"];
    }
    
    
}


- (void)gregisterCompletedMethod:(NSNotification*)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification.name object:nil];
    id response = notification.object;
    [self.navigationItem setPrompt:nil];
    if ([response isMemberOfClass:[NSError class]] || ([response isKindOfClass:[NSDictionary class]] && [[response allKeys] containsObject:@"error"])) {
        
        //        [self showTitleBar:@"SIGN IN"];
        self.view.userInteractionEnabled = YES;
        return;
    }
    if ([self saveLoggedInAccount:_socialAccount[@"username"] :_socialAccount[@"password"] :_socialAccount[@"fullname"] :_socialAccount[@"birthday"] :response[@"token"] :response[@"uid"]]) {
        self.view.userInteractionEnabled = YES;
        [self.navigationController popToRootViewControllerAnimated:YES];
        self.view.userInteractionEnabled = YES;
        [self changeView:nil];
    }
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

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    
    if ([self userLoggedIn] || [identifier isEqualToString:@"viewLoginToRegister"] || [identifier isEqualToString:@"viewLoginToLogin"]) {
        return YES;
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:ChangeHomeViewToShow object:@"HomeViewLogin"];
        return NO;
    }
}

@end
