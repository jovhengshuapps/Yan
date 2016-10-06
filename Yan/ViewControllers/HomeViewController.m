//
//  HomeViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 4/4/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "SquareCamViewController.h"
#import "OrderMenuViewController.h"
#import "QRReaderViewController.h"


@interface HomeViewController()
@property (weak, nonatomic) IBOutlet UIView *viewDefaultHome;
@property (weak, nonatomic) IBOutlet UIView *viewRegistrationComplete;
@property (weak, nonatomic) IBOutlet UIView *viewNotificationReminder;
@property (weak, nonatomic) IBOutlet UIView *viewLogin;

@property (weak, nonatomic) IBOutlet UIButton *loginButton; //facebook
@property (weak, nonatomic) IBOutlet UIButton *googleLoginButton; //google
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackground;

@property (strong, nonatomic) NSMutableDictionary *socialAccount;
@property (assign, nonatomic) NSInteger restaurantID;
@property (assign, nonatomic) NSInteger tableNumber;

@property (strong, nonatomic) UILabel *labelTextStatus;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeView:) name:ChangeHomeViewToShow object:nil];
    
    
    
    [super viewDidLoad];
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    Account *account = [self userLoggedIn];
    if (account) {
        if ([account.current_restaurantID integerValue] + [account.current_restaurantName integerValue] + [account.current_tableNumber integerValue] == 0) {
            self.navigationItem.rightBarButtonItem = nil;
        }
        else {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"out"] style:UIBarButtonItemStylePlain target:self action:@selector(rescanQR)];
        }
        UIBarButtonItem *menuBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"app-menu.png"] style:UIBarButtonItemStyleDone target:self action:@selector(openMenu)];
        
        [[self navigationItem] setLeftBarButtonItem:menuBarItem];
        if (!(self.viewToShow == HomeViewRegistrationComplete || self.viewToShow == HomeViewNotification || self.viewToShow == HomeViewLogin)) {
            
            self.frostedViewController.panGestureEnabled = YES;
            _viewDefaultHome.hidden = NO;
            _viewLogin.hidden = YES;
            _viewNotificationReminder.hidden = YES;
            _viewRegistrationComplete.hidden = YES;
            
        }
    }
    else {
        [self.navigationItem setLeftBarButtonItem:nil];
        [self.navigationItem setRightBarButtonItem:nil];
        self.frostedViewController.panGestureEnabled = NO;
        _viewLogin.hidden = NO;
        _viewDefaultHome.hidden = YES;
        _viewNotificationReminder.hidden = YES;
        _viewRegistrationComplete.hidden = YES;
        
        
        if ([FBSDKAccessToken currentAccessToken]) {
            // TODO:Token is already available.
        }
        
        [GIDSignIn sharedInstance].uiDelegate = self;
        
    }
    self.title = @"Home";
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    NSData *backgroundData = [[NSUserDefaults standardUserDefaults] dataForKey:@"ImageBackground"];
    
    self.imageViewBackground.contentMode = UIViewContentModeScaleAspectFill;
    self.imageViewBackground.clipsToBounds = NO;
    if (backgroundData) {
        UIImage *image = [UIImage imageWithData:backgroundData];
        
        self.imageViewBackground.image = image;
        //        self.progressView.hidden = YES;
    }
    else {
        //        self.progressView.hidden = NO;
        //        [self.progressView setProgress:0.0f];
        CABasicAnimation *theAnimation;
        
        theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
        theAnimation.duration=1.0;
        theAnimation.repeatCount=HUGE_VALF;
        theAnimation.autoreverses=YES;
        theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
        theAnimation.toValue=[NSNumber numberWithFloat:0.0];
        
        //        NSLog(@"URL_LOGO:%@",loggedUSER.restaurant_logo_url);
        [self.imageViewBackground.layer addAnimation:theAnimation forKey:@"animateOpacity"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBackgroundImage:) name:@"getBackgroundImage_Observer" object:nil];
        [self callGETAPI:API_GETBACKGROUND_IMAGE withParameters:@{} completionNotification:@"getBackgroundImage_Observer"];
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


- (void) getBackgroundImage:(NSNotification*)notification {
    if ([notification.object isKindOfClass:[NSError class]]) {
        
        NSError *error = (NSError*)notification.object;
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Error %li",(long)error.code] message:error.description preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:^{
            }];
        }];
        [alert addAction:actionOK];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
    else {
        NSDictionary *response = (NSDictionary*)notification.object;
        [self getImageFromURL:response[@"img_url"] completionHandler:^(NSURLResponse * _Nullable response, id  _Nullable responseObject, NSError * _Nullable error) {
//            NSLog(@"responseObject:%@",responseObject);
            if (!error) {
                NSData *backgroundDataFromServer = UIImageJPEGRepresentation((UIImage*)responseObject, 100.0f);
                [[NSUserDefaults standardUserDefaults] setObject:backgroundDataFromServer forKey:@"ImageBackground"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                UIImage *image = (UIImage*)responseObject;
                self.imageViewBackground.image = image;
                [self.imageViewBackground.layer removeAllAnimations];
            }
        } andProgress:^(NSInteger expectedBytesToReceive, NSInteger receivedBytes) {
            
        }];
    }

}

- (void) changeView:(NSNotification*)notification {
//    [self.navigationItem setPrompt:nil];
    
    
    KEYWINDOW.windowLevel = UIWindowLevelNormal;
    [_labelTextStatus removeFromSuperview];
    
    if ([notification.object isEqualToString:@"ProceedToMenu"]) {
        _viewDefaultHome.hidden = NO;
        _viewRegistrationComplete.hidden = YES;
        _viewLogin.hidden = YES;
        _viewNotificationReminder.hidden = YES;
        
        UIBarButtonItem *menuBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"app-menu.png"] style:UIBarButtonItemStyleDone target:self action:@selector(openMenu)];
        
        [[self navigationItem] setLeftBarButtonItem:menuBarItem];
        self.frostedViewController.panGestureEnabled = YES;
        
        [self performSelector:@selector(gotoOrderScreen:) withObject:nil];
//        [self performSegueWithIdentifier:@"homeOrder" sender:nil];
    }
    else if ([notification.object isEqualToString:@"HomeViewNotification"]) {
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
        
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"apple" withExtension:@"mp4"];
        AlertView *alert = [[AlertView alloc] initVideoAd:url delegate:self];
        alert.tag = 1;
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

- (void)alertView:(AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1990 && buttonIndex == 0) {
        
        self.restaurantID = 0;
        self.tableNumber = 0;
        NSString *orderID = @"";
        NSError *error = nil;
        
        NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
        Account *loggedUSER = [self userLoggedIn];
        orderID = loggedUSER.current_orderID;
        loggedUSER.current_tableNumber = @"";
        loggedUSER.current_restaurantID = @"";
        loggedUSER.current_restaurantName = @"";
        loggedUSER.current_orderID = @"";
        
        if ([context save:&error]) {
            
            error = nil;
            
            NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OrderList"];
            [request setReturnsObjectsAsFaults:NO];
            NSArray *result = [NSArray arrayWithArray:[context executeFetchRequest:request error:&error]];
            
            for (OrderList *orders in result) {
                [context deleteObject:orders];
            }
            
            if ([context save:&error]) {
                
                self.navigationItem.rightBarButtonItem = nil;
                
//                QRReaderViewController *scanLogo = [self.storyboard instantiateViewControllerWithIdentifier:@"qrReader"];
//                scanLogo.modalPresentationStyle = UIModalPresentationOverFullScreen;
//                scanLogo.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//                [self presentViewController:scanLogo animated:NO completion:^{
//                    
//                }];
            }
            
        }

    }
    else {
        
        [alertView dismissAlertView];
    }
}
- (void)videoAdPlayer:(AlertView *)alertView{
    [alertView dismissAlertView];
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
//                 NSLog(@"Process error");
             } else if (result.isCancelled) {
//                 NSLog(@"Cancelled");
             } else {
//                 NSLog(@"Logged in Facebook");
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
            _socialAccount[@"birthday"] = (result[@"birthday"])?result[@"birthday"]:@"01/01/1970";
            _socialAccount[@"password"] = [self passwordForName:result[@"name"] email:result[@"email"] birthday:result[@"birthday"] gender:result[@"gender"]];
            
            //            NSLog(@"fetched user:%@\n\naccount:%@", result,_socialAccount);
//            [self showTitleBar:@"Logging in to Yan!"];
//            [self.navigationItem setPrompt:@"Logging in to Yan!"];
            
            
            KEYWINDOW.windowLevel = UIWindowLevelStatusBar;
            
            if (!self.labelTextStatus) {
                _labelTextStatus = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, KEYWINDOW.frame.size.width, 20.0f)];
                _labelTextStatus.backgroundColor = [UIColor clearColor];
                _labelTextStatus.textColor = [UIColor whiteColor];
                [KEYWINDOW addSubview:self.labelTextStatus];
            }
            _labelTextStatus.text = @"Logging in to Yan!";
            
            self.view.userInteractionEnabled = NO;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessful:) name:@"socialLoginObserver" object:nil];
            NSString *deviceToken = ((AppDelegate*)[UIApplication sharedApplication].delegate).deviceToken;
            [self callAPI:API_USER_LOGIN withParameters:@{
                                                          @"username": _socialAccount[@"username"],
                                                          @"password": _socialAccount[@"password"],
                                                          @"device_token": deviceToken,
                                                          @"device_type":@"ios"
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
//    [self.navigationItem setPrompt:@"Logging in to Yan!"];
    
    KEYWINDOW.windowLevel = UIWindowLevelStatusBar;
    
    if (!self.labelTextStatus) {
        _labelTextStatus = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, KEYWINDOW.frame.size.width, 20.0f)];
        _labelTextStatus.backgroundColor = [UIColor clearColor];
        _labelTextStatus.textColor = [UIColor whiteColor];
        [KEYWINDOW addSubview:self.labelTextStatus];
    }
    _labelTextStatus.text = @"Logging in to Yan!";
    
    self.view.userInteractionEnabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessful:) name:@"socialLoginObserver" object:nil];
    NSString *deviceToken = ((AppDelegate*)[UIApplication sharedApplication].delegate).deviceToken;
    [self callAPI:API_USER_LOGIN withParameters:@{
                                                  @"username": _socialAccount[@"username"],
                                                  @"password": _socialAccount[@"password"],
                                                  @"device_token": deviceToken,
                                                  @"device_type":@"ios"
                                                  } completionNotification:@"socialLoginObserver"];
}


- (void)loginSuccessful:(NSNotification*)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification.name object:nil];
    id response = notification.object;
    NSLog(@"login response:%@",response);
    if ([response isKindOfClass:[NSError class]]) {
        
        //        [self showTitleBar:@"SIGN IN"];
        self.view.userInteractionEnabled = YES;
        return;
    }
    if (response[@"token"]){
        if ([self saveSocialLoggedInAccount:_socialAccount[@"username"] :_socialAccount[@"password"] :response[@"name"] :response[@"birthday"] :response[@"token"] :response[@"uid"]]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            self.view.userInteractionEnabled = YES;
            [self changeView:nil];
        }
    } else {
        
//        [self.navigationItem setPrompt:@"Creating Yan! account"];
        
        
        KEYWINDOW.windowLevel = UIWindowLevelStatusBar;
        
        if (!self.labelTextStatus) {
            _labelTextStatus = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, KEYWINDOW.frame.size.width, 20.0f)];
            _labelTextStatus.backgroundColor = [UIColor clearColor];
            _labelTextStatus.textColor = [UIColor whiteColor];
            [KEYWINDOW addSubview:self.labelTextStatus];
        }
        _labelTextStatus.text = @"Creating Yan! account";
        
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
//    [self.navigationItem setPrompt:nil];
    
    KEYWINDOW.windowLevel = UIWindowLevelNormal;
    [_labelTextStatus removeFromSuperview];
    
    if ([response isKindOfClass:[NSError class]] || ([response isKindOfClass:[NSDictionary class]] && [[response allKeys] containsObject:@"error"])) {
        
        //        [self showTitleBar:@"SIGN IN"];
        self.view.userInteractionEnabled = YES;
        return;
    }
    if ([self saveSocialLoggedInAccount:_socialAccount[@"username"] :_socialAccount[@"password"] :_socialAccount[@"fullname"] :_socialAccount[@"birthday"] :response[@"token"] :response[@"uid"]]) {
        self.view.userInteractionEnabled = YES;
        [self.navigationController popToRootViewControllerAnimated:YES];
        self.view.userInteractionEnabled = YES;
        [self changeView:nil];
    }
}

- (void)gloginSuccessful:(NSNotification*)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification.name object:nil];
    id response = notification.object;
    if ([response isKindOfClass:[NSError class]]) {
        
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
        
//        [self.navigationItem setPrompt:@"Creating Yan! account"];
        
        
        KEYWINDOW.windowLevel = UIWindowLevelStatusBar;
        
        if (!self.labelTextStatus) {
            _labelTextStatus = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, KEYWINDOW.frame.size.width, 20.0f)];
            _labelTextStatus.backgroundColor = [UIColor clearColor];
            _labelTextStatus.textColor = [UIColor whiteColor];
            [KEYWINDOW addSubview:self.labelTextStatus];
        }
        _labelTextStatus.text = @"Logging in to Yan!";
        
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
    
    KEYWINDOW.windowLevel = UIWindowLevelNormal;
    [_labelTextStatus removeFromSuperview];
    
//    [self.navigationItem setPrompt:nil];
    if ([response isKindOfClass:[NSError class]] || ([response isKindOfClass:[NSDictionary class]] && [[response allKeys] containsObject:@"error"])) {
        
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
    
    
    if ([identifier isEqualToString:@"viewLoginToRegister"] || [identifier isEqualToString:@"viewLoginToLogin"]) {
        return YES;
    }
    else if ([identifier isEqualToString:@"regCompleteOrderButton"] || [identifier isEqualToString:@"homeOrder"]) {
        self.restaurantID = 0;
        self.tableNumber = 0;
        
        Account *loggedUSER = [self userLoggedIn];
        self.restaurantID = [loggedUSER.current_restaurantID integerValue];
        self.tableNumber = [loggedUSER.current_tableNumber integerValue];
        
        
        
        if (self.restaurantID > 0 && self.tableNumber > 0) {
            return YES;
        }
        else {
        return NO;
        }
    }
    else {
//        [[NSNotificationCenter defaultCenter] postNotificationName:ChangeHomeViewToShow object:@"HomeViewLogin"];
        return YES;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"regCompleteOrderButton"] || [segue.identifier isEqualToString:@"homeOrder"]) {

        
        if (self.restaurantID == 0  && self.tableNumber == 0) {
            
            QRReaderViewController *scanLogo = [self.storyboard instantiateViewControllerWithIdentifier:@"qrReader"];
            scanLogo.modalPresentationStyle = UIModalPresentationOverFullScreen;
            scanLogo.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:scanLogo animated:NO completion:^{
                
            }];
        }
        
            
        
    }
}

- (IBAction)gotoOrderScreen:(id)sender {
    self.restaurantID = 0;
    self.tableNumber = 0;
    
    Account *loggedUSER = [self userLoggedIn];
    self.restaurantID = [loggedUSER.current_restaurantID integerValue];
    self.tableNumber = [loggedUSER.current_tableNumber integerValue];
    
    
    
    if (self.restaurantID > 0 && self.tableNumber > 0) {
        OrderMenuViewController *orderMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"orderMenu"];
        [self.navigationController pushViewController:orderMenu animated:YES];
    }
    else {
        QRReaderViewController *scanLogo = [self.storyboard instantiateViewControllerWithIdentifier:@"qrReader"];
        scanLogo.modalPresentationStyle = UIModalPresentationOverFullScreen;
        scanLogo.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:scanLogo animated:NO completion:^{
            
        }];
    }
}

- (void) rescanQR {
    
    Account *loggedUSER = [self userLoggedIn];
    NSString *message = [NSString stringWithFormat:@"Are you sure you wanna leave table %@, %@?",loggedUSER.current_tableNumber, loggedUSER.current_restaurantName];
    
    AlertView *alert = [[AlertView alloc] initAlertWithMessage:message delegate:self buttons:@[@"YES",@"NO"]];
    alert.tag = 1990;
    [alert showAlertView];
}

@end
