//
//  CoreViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 3/31/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "CoreViewController.h"

#import "OrderMenuViewController.h"
#import "MenuDetailsViewController.h"
#import "ConfirmOrderViewController.h"
#import "OptionListTableViewController.h"
#import "WaiterTableViewController.h"
#import "PayScreenViewController.h"

@interface CoreViewController ()
@property (strong, nonatomic) UILabel *titleLabel;
@property (assign, nonatomic) CGFloat defaultHeight;

@end

@implementation CoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNeedsStatusBarAppearanceUpdate];
    
    //Setup Title Bar
//    _titleBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.bounds.size.width, self.navigationController.navigationBar.frame.size.height)];
    _titleBarView.backgroundColor = UIColorFromRGB(0x333333);
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KEYWINDOW.frame.size.width, 44.0f)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"...";
    _titleLabel.font = [UIFont fontWithName:@"LucidaGrande" size:25.0f];
    _titleLabel.textColor = UIColorFromRGB(0xFFFFFF);
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    _titleLabel.minimumScaleFactor = -5.0f;
    [self hideTitleBar];
    
    
    [_titleBarView addSubview:_titleLabel];
        
    _defaultHeight = self.view.frame.size.height;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    /*
     
     //constraints
     
     NSDictionary *viewsDictionary = @{@"button":button,@"customButton":customSignInLinkButton};
     NSDictionary *metrics = @{@"buttonWidth": @150,
     @"padding": [NSNumber numberWithFloat:padding],
     @"topMargin": [NSNumber numberWithFloat:buttonHeight / 2]
     };
     
     NSArray *constraint_SIZE_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(buttonWidth)]"
     options:0
     metrics:metrics
     views:viewsDictionary];
     NSArray *constraint_SIZE_H_CUSTOM = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[customButton(buttonWidth)]"
     options:0
     metrics:metrics
     views:viewsDictionary];
     NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topMargin-[button]"
     options:0
     metrics:metrics
     views:viewsDictionary];
     NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[button]-padding-[customButton]-padding-|"
     options:NSLayoutFormatAlignAllTop
     metrics:metrics
     views:viewsDictionary];
     [button addConstraints:constraint_SIZE_H];
     [customSignInLinkButton addConstraints:constraint_SIZE_H_CUSTOM];
     [footerView addConstraints:constraint_POS_H];
     [footerView addConstraints:constraint_POS_V];
     
     */
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"billoutRequestedOrdersClearedObserver" object:nil];
    [self hideTitleBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(billoutRequestedOrdersCleared) name:@"billoutRequestedOrdersClearedObserver" object:nil];
    self.title = @"Yan";
    
    Account *loggedUSER = [self userLoggedIn];
    if (loggedUSER && loggedUSER.current_restaurantName && loggedUSER.current_restaurantName.length > 0) {
        self.title = loggedUSER.current_restaurantName;
    }
    
    
}
//
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void) addDoneToolbar:(UITextField*)textfield {
    UIToolbar *accessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, KEYWINDOW.bounds.size.width, 44.0f)];
    accessoryView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"DONE" style:UIBarButtonItemStyleDone target:textfield action:@selector(resignFirstResponder)];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [accessoryView setItems:@[flex,barItem]];
    textfield.inputAccessoryView = accessoryView;
}

- (void) showTitleBar:(NSString*)title {
    if (title.length == 0){
        return;
    }
        
    _titleBarView.hidden = NO;
    _titleLabel.text = [title uppercaseString];
//    _titleBarView.alpha = 1.0f;
//    _titleLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:[title uppercaseString] attributes:TextAttributes(@"LucidaGrande", (0xFFFFFF), _titleBarView.frame.size.height - 20.0f)];
    
    
//    self.view.userInteractionEnabled = NO;
//    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        _titleBarView.alpha = 1.0f;
//        CGRect frame = self.view.frame;
//        frame.origin.y = _titleBarView.frame.size.height + self.navigationController.navigationBar.frame.size.height + 20.0f;
//        frame.size.height = _defaultHeight - (_titleBarView.frame.size.height + self.navigationController.navigationBar.frame.size.height + 20.0f);
//        self.view.frame = frame;
//        self.view.alpha = 1.0f;
//    } completion:^
//     (BOOL finished) {
//        
//        self.view.userInteractionEnabled = YES;
//    }];
    
    
    
}

- (void) hideTitleBar {
    _titleBarView.hidden = YES;
}

-(void) openMenu {
    
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
    
}

- (Account*) userLoggedIn {
    
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Account"];
    
    NSError *error = nil;
    
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if (result.count) {
        return ((Account*)result[0]);
    }
    
    return nil;
    
}


- (void)isFromRegistration:(BOOL)fromRegistration {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    view.backgroundColor = [UIColor redColor];
    view.center = KEYWINDOW.center;
    [self.view addSubview:view];
}


- (void)getImageFromURL:(NSString*)urlPath  completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler andProgress:(void (^)(NSInteger expectedBytesToReceive, NSInteger receivedBytes))progress{
    NETWORK_INDICATOR(YES)
    NSURL *baseURL = [NSURL URLWithString:BASE_URL];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlPath relativeToURL:baseURL]] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NETWORK_INDICATOR(NO)
        
        completionHandler(response, responseObject, error);
    }];
    
    [manager setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data) {
        NETWORK_INDICATOR(YES)
        progress(dataTask.countOfBytesExpectedToReceive,dataTask.countOfBytesReceived);
    }];
    
    
//    [manager setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data) {
//        
//        NSLog(@"data:%@",data);
//    }];

    [task resume];
    
    
}


- (void)getImageFromURL:(NSString*)urlPath updateImageView:(UIImageView*)imageView completionNotification:(NSString*)notificationName {
    NETWORK_INDICATOR(YES)
    NSURL *baseURL = [NSURL URLWithString:BASE_API_URL];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
     manager.responseSerializer = [AFImageResponseSerializer serializer];
    
    UIActivityIndicatorView *progressView = nil;
    if (![imageView viewWithTag:12345]) {
        progressView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        progressView.frame = CGRectMake(0.0f, 10.0f, 30.0f, 30.0f);
        progressView.center = imageView.center;
        progressView.backgroundColor = [UIColor grayColor];
        progressView.tag = 12345;
        [imageView addSubview:progressView];
    }
    else {
        progressView = (UIActivityIndicatorView*)[imageView viewWithTag:12345];
    }
    [progressView startAnimating];
    
    
    
    [manager GET:urlPath parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
//        NSLog(@"progress:%f",[downloadProgress fractionCompleted]);
        
//        UIProgressView *progressView = nil;
//        if (![imageView viewWithTag:12345]) {
//            progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
//            progressView.frame = CGRectMake(0.0f, 0.0f, imageView.frame.size.width - 15.0f, 30.0f);
//            progressView.tag = 12345;
//            [imageView.layer addSublayer:progressView.layer];
//        }
//        else {
//            progressView = (UIProgressView*)[imageView viewWithTag:12345];
//        }
//        [progressView setProgress:0.0f animated:YES];
//        [progressView setProgress:[downloadProgress fractionCompleted] animated:YES];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NETWORK_INDICATOR(NO)
//        NSLog(@"response:%@",responseObject);
        [[imageView viewWithTag:12345] removeFromSuperview];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"task:%@\n\n[%@]%@",task,[error description],[error localizedDescription]);
        NETWORK_INDICATOR(NO)
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:error];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Error %li",(long)[error code]] message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:actionOK];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }];
}

- (void)callPOSTAPI:(NSString*)method withParameters:(NSDictionary*)parameters completionHandler:(void (^)(id _Nullable response))completion{
    
    NSURL *baseURL = [NSURL URLWithString:BASE_API_URL];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    Account *user = [self userLoggedIn];
    if (user.token) {
        
        [manager.requestSerializer setValue:user.token forHTTPHeaderField:@"x-yan-resto-api"];
    }
    NETWORK_INDICATOR(YES)
    
    [manager POST:method parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
//        NSLog(@"progress:%f",[uploadProgress fractionCompleted]);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NETWORK_INDICATOR(NO)
        completion(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"task:%@\n\n[%@]%@",task,[error description],[error localizedDescription]);
        NETWORK_INDICATOR(NO)
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Error %li",(long)[error code]] message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:actionOK];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }];
}


- (void)callGETAPI:(NSString*)method withParameters:(NSDictionary*)parameters completionNotification:(NSString*)notificationName{
    
    NSURL *baseURL = [NSURL URLWithString:BASE_API_URL];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    Account *user = [self userLoggedIn];
    if (user.token) {
        NSLog(@"DEVICE TOKEN:%@",user.token);
        [manager.requestSerializer setValue:user.token forHTTPHeaderField:@"x-yan-resto-api"];
    }
    
    [self callGetSessionManager:manager :method :parameters :notificationName];
}

- (void)callAPI:(NSString*)method withParameters:(NSDictionary*)parameters completionNotification:(NSString*)notificationName{
    
    NSURL *baseURL = [NSURL URLWithString:BASE_API_URL];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    Account *user = [self userLoggedIn];
    if (user.token) {
        
        [manager.requestSerializer setValue:user.token forHTTPHeaderField:@"x-yan-resto-api"];
    }
//    NSLog(@"METHOD:%@",method);
    [self callPostSessionManager:manager :method :parameters :notificationName];
}

- (void)callPostSessionManager:(AFHTTPSessionManager*)manager :(NSString*)method :(NSDictionary*)parameters :(NSString*)notificationName {
    
    NETWORK_INDICATOR(YES)
    
//    NSLog(@"parameters:%@",parameters);
    [manager POST:method parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
//        NSLog(@"progress:%f",[uploadProgress fractionCompleted]);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NETWORK_INDICATOR(NO)
//        NSLog(@"response:%@",responseObject);
        if ([responseObject isKindOfClass:[NSError class]] || ([responseObject isKindOfClass:[NSDictionary class]] && [[responseObject allKeys] containsObject:@"error"])) {
            if ([responseObject isKindOfClass:[NSError class]]) {
                
                NSError *error = (NSError*)responseObject;
                
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
                
                [self resolveErrorResponse:responseObject withNotification:notificationName];
            }
//            if([responseObject[@"error"] integerValue] == 404 && [notificationName isEqualToString:@"socialLoginObserver"]){
//                [self resolveErrorResponse:responseObject withNotification:notificationName];
//            }
            
        }
        else if ([responseObject isKindOfClass:[NSArray class]] || [responseObject isKindOfClass:[NSDictionary class]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:responseObject];
        }
        else {
            [self resolveErrorResponse:responseObject withNotification:notificationName];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"task:%@\n\n[%@]%@",task,[error description],[error localizedDescription]);
        NETWORK_INDICATOR(NO)
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:error];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Error %li",(long)[error code]] message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:actionOK];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }];
}

- (void)callGetSessionManager:(AFHTTPSessionManager*)manager :(NSString*)method :(NSDictionary*)parameters :(NSString*)notificationName {
    
    NETWORK_INDICATOR(YES)
    
//    NSLog(@"[123]method:%@",method);
    [manager GET:method parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
//        NSLog(@"progress:%f",[uploadProgress fractionCompleted]);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NETWORK_INDICATOR(NO)
        if ([responseObject isKindOfClass:[NSError class]] || ([responseObject isKindOfClass:[NSDictionary class]] && [[responseObject allKeys] containsObject:@"error"])) {
            if ([responseObject isKindOfClass:[NSError class]]) {
                
                NSError *error = (NSError*)responseObject;
                
                
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
                
                [self resolveErrorResponse:responseObject withNotification:notificationName];
            }
//            if([responseObject[@"error"] integerValue] == 404 && [notificationName isEqualToString:@"socialLoginObserver"]){
//                [self resolveErrorResponse:responseObject withNotification:notificationName];
//            }
        }
        else if ([responseObject isKindOfClass:[NSArray class]] || [responseObject isKindOfClass:[NSDictionary class]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:responseObject];
        }
        else {
            [self resolveErrorResponse:responseObject withNotification:notificationName];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"task:%@\n\n[%@]%@",task,[error description],[error localizedDescription]);
        NETWORK_INDICATOR(NO)
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:error];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Error %li",(long)[error code]] message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:actionOK];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }];
}

- (BOOL)saveLoggedInAccount:(NSString*)username :(NSString*)password :(NSString*)fullname :(NSString*)birthday :(NSString*)token :(NSNumber*)identifier {
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    Account *account = [[Account alloc] initWithEntity:[NSEntityDescription entityForName:@"Account" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
    account.username = isNIL(username);
    account.password = isNIL(password);
    account.birthday = isNIL(birthday);
    account.fullname = isNIL(fullname);
    account.token = isNIL(token);
    account.identifier = [NSString stringWithFormat:@"%@",identifier];
//    NSLog(@"identifier USER:%@",identifier);
    NSError *error = nil;
    if ([context save:&error]) {
        return YES;
    }
    else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Error %li",(long)[error code]] message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:actionOK];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
    return NO;
}

- (void) resolveErrorResponse:(NSDictionary*)response withNotification:(NSString*)notificationName {
    NSString *title = @"";
    NSString *message = @"";
    UIAlertAction *actionOK = nil;
    if ([response[@"error"] integerValue] == 404) {
        title = @"Error Login";
        message = response[@"message"];
    }
    else if ([response[@"error"] integerValue] == 403) {
        title = @"Error User Profile";
        message = response[@"detail"];
        
    }
    else if ([response[@"error"] integerValue] == 503) {
        title = @"Error User";
        message = response[@"message"];
        
    }
    else {
        title = [NSString stringWithFormat:@"Error Code [%li]",[response[@"error"] integerValue]];
        message = response[@"message"];
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if ([response[@"error"] integerValue] == 404) {
        actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:^{
            }];
        }];
    }
    else if ([response[@"error"] integerValue] == 403) {
        actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self logoutUser];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [alert dismissViewControllerAnimated:YES completion:^{
            }];
        }];
    }
    else {
        actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:^{
            }];
        }];
    }
    
    
    [alert addAction:actionOK];
    
    if ([notificationName isEqualToString:@"socialLoginObserver"] == YES && [response[@"error"] integerValue] == 404) {
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:response];
        //do nothing
    }
    else {
        
        [self presentViewController:alert animated:YES completion:^{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:response];
        }];
    }
}

- (void) logoutUser {
    
    Account *account = [self userLoggedIn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutCurrentAccount:) name:@"logoutCurrentAccount" object:nil];
    [self callGETAPI:API_USER_LOGOUT(account.identifier) withParameters:@{} completionNotification:@"logoutCurrentAccount"];
    
}

- (void) logoutCurrentAccount:(NSNotification*)notification {
//    NSLog(@"response:%@",notification.object);
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Account"];
    
    NSError *error = nil;
    
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    
    for (Account *account in result) {
        [context deleteObject:account];
    }
    
    error = nil;
    if ([context save:&error]) {
        //            [[GIDSignIn sharedInstance] signOut];
        //            FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        //            [login logOut];
        
        //remove orders
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OrderList"];
        
        error = nil;
        
        NSArray *result = [context executeFetchRequest:request error:&error];
        
        
        for (OrderList *orders in result) {
            [context deleteObject:orders];
        }
        
        error = nil;
        if ([context save:&error]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ChangeHomeViewToShow object:@"HomeViewLogin"];
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
        
    }
}


- (void)alertView:(AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}

- (NSData*)encodeData:(id)object withKey:(NSString*)key {
    NSMutableData *data = [NSMutableData new];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:object forKey:key];
    [archiver finishEncoding];
    return data;
}

- (id)decodeData:(NSData*)data forKey:(NSString*)key {
    id object = nil;
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    object = [unarchiver decodeObjectForKey:key];
    [unarchiver finishDecoding];
    return object;
}


//- (NSData*)encodeMenuList:(NSArray*)list withKey:(NSString*)key {
//    
//    NSMutableArray *encodedList = [NSMutableArray new];
//    
//    for (MenuItem *item in list) {
//        [encodedList addObject:[self menuItemToDictionary:item]];
//    }
//    
//    NSMutableData *data = [NSMutableData new];
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//    [archiver encodeObject:encodedList forKey:key];
//    [archiver finishEncoding];
//    return data;
//}
//
//- (NSArray*)decodeMenuList:(NSData*)data forKey:(NSString*)key {
//    NSMutableArray *decodedList = [NSMutableArray new];
//    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
//    NSArray *objectList = [unarchiver decodeObjectForKey:key];
//    [unarchiver finishDecoding];
//    
//    for (NSDictionary *object in objectList) {
//        //checkDB
//        NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
//        
//        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"MenuItem"];
//        
////        [request setPredicate:[NSPredicate predicateWithFormat:@"identifier == \"%@\"",object[@"identifier"]]];
//        NSError *error = nil;
//        
//        NSArray *result = [context executeFetchRequest:request error:&error];
//        
//        NSLog(@"\n\n####### object:%@\n\nresult:%@\n\n",object,result);
//        if (result.count) {
//            [decodedList addObject:(MenuItem*)result[0]];
//        }
//    }
//    
//    NSLog(@"objectsList:%@\n\ndecoded:%@",objectList,decodedList);
//    return decodedList;
//}


- (void) addMenuItem:(MenuItem*)menu tableNumber:(NSString*)tableNumber{
    
    Account *user = [self userLoggedIn];
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
//    
//    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OrderList"];
//    [request setPredicate:[NSPredicate predicateWithFormat:@"tableNumber == %@ AND user_id == %@ AND restaurant_id == %@", user.current_tableNumber, user.identifier, user.current_restaurantID]];
//    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
//    
//    NSArray *result = [NSArray arrayWithArray:[context executeFetchRequest:request error:&error]];
    
    NSArray *result = [self orderListFromUser:user onContext:context];
    
    if (result.count == 0) {
        NSDictionary *item = [self menuItemToDictionary:menu itemNumber:1];
        NSDictionary *bundle = @{@"menu_id":item[@"identifier"],
                                 @"menu_name":item[@"name"],
                                 @"options":item[@"option_choices"],
                                 @"price":item[@"price"],
                                 @"quantity":@1
                                 };
        NSArray *orderItems = [NSArray arrayWithObjects:bundle, nil];
//        NSLog(@"orderItems:%@",orderItems);
        OrderList *order = [[OrderList alloc] initWithEntity:[NSEntityDescription entityForName:@"OrderList" inManagedObjectContext:context]  insertIntoManagedObjectContext:context];

        order.items = [self encodeData:orderItems withKey:@"orderItems"];
        order.orderSent = @NO;
        order.tableNumber = user.current_tableNumber;
        order.user_id = user.identifier;
        order.user_name = user.username;
        order.restaurant_id = user.current_restaurantID;
        
        error = nil;
        if ([context save:&error]) {
            NSLog(@"DATA SAVED!");
        }else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Error %li",(long)[error code]] message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:actionOK];
            
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }
    }
    else {
        
        OrderList *order = (OrderList*)result[0];
        NSMutableArray *newOrderList = [NSMutableArray new];
        NSArray *decodedList = (NSArray*)[self decodeData:order.items forKey:@"orderItems"];
        
        BOOL isNewIdentifier = YES;
        
        [newOrderList addObjectsFromArray:decodedList];
        
        NSDictionary *menuItem = [self menuItemToDictionary:menu itemNumber:1];
        NSLog(@"decoded:%@",decodedList);
        
        for (NSInteger index = 0; index < decodedList.count; index++) {
            NSMutableDictionary *item = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)decodedList[index]];
            if ([item[@"menu_id"] integerValue] == [menuItem[@"identifier"] integerValue] && [item[@"options"] isEqualToString:menuItem[@"option_choices"]]) {
                isNewIdentifier = NO;
                NSInteger sum = [item[@"quantity"] integerValue] + 1;
                NSNumber *quantity = [NSNumber numberWithInteger:sum];
//                NSNumber *total_amount = [NSNumber numberWithFloat:((float)sum) * [menu.price floatValue]];
                
                NSDictionary *bundle = @{@"menu_id":item[@"menu_id"],
                                         @"menu_name":item[@"menu_name"],
                                         @"options":item[@"options"],
                                         @"price":item[@"price"],
                                         @"quantity":quantity
                                         };
                
                [newOrderList replaceObjectAtIndex:index withObject:bundle];
            }
        }
        
        
        if (isNewIdentifier == YES) {
            NSDictionary *item = [self menuItemToDictionary:menu itemNumber:1];
            NSDictionary *bundle = @{@"menu_id":item[@"identifier"],
                                     @"menu_name":item[@"name"],
                                     @"options":item[@"option_choices"],
                                     @"price":item[@"price"],
                                     @"quantity":@1
                                     };
            [newOrderList addObject:bundle];
        }
        NSLog(@"orderItems:%@",newOrderList);
        order.items = [self encodeData:newOrderList withKey:@"orderItems"];
        order.orderSent = @NO;
        order.tableNumber = tableNumber;
        order.user_id = user.identifier;
        
        error = nil;
        if (![context save:&error]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Error %li",(long)[error code]] message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:actionOK];
            
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }
        
    }
    
}


- (NSDictionary*)menuItemToDictionary:(MenuItem*)menuItem itemNumber:(NSInteger)itemNumber {
    NSArray *keys = [[[menuItem entity] attributesByName] allKeys];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:[menuItem dictionaryWithValuesForKeys:keys]];
    [dictionary setObject:[NSNumber numberWithInteger:itemNumber] forKey:@"itemnumber"];
    [dictionary setObject:@"Basic" forKey:@"option_choices"];
    return dictionary;
}

- (void)billoutRequestedOrdersCleared {
    
    if ([self isMemberOfClass:[OrderMenuViewController class]] || [self isMemberOfClass:[MenuDetailsViewController class]] || [self isMemberOfClass:[ConfirmOrderViewController class]] || [self isMemberOfClass:[OptionListTableViewController class]] || [self isMemberOfClass:[WaiterTableViewController class]] || [self isMemberOfClass:[PayScreenViewController class]]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
}


- (NSArray*) orderListFromUser:(Account*)userAccount onContext:(NSManagedObjectContext *)context{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OrderList"];
    [request setReturnsObjectsAsFaults:NO];
    [request setPredicate:[NSPredicate predicateWithFormat:@"tableNumber == %@ AND user_id == %@ AND restaurant_id == %@", userAccount.current_tableNumber, userAccount.identifier, userAccount.current_restaurantID]];
    NSError *error = nil;
    
    NSArray *result = [NSArray arrayWithArray:[context executeFetchRequest:request error:&error]];
    return result;
}


@end
