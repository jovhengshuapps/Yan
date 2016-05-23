//
//  CoreViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 3/31/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "CoreViewController.h"


@interface CoreViewController ()
@property (strong, nonatomic) UILabel *titleLabel;
@property (assign, nonatomic) CGFloat defaultHeight;

@end

@implementation CoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.title = @"Yan";
    
    //Setup Title Bar
//    _titleBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.bounds.size.width, self.navigationController.navigationBar.frame.size.height)];
    _titleBarView.backgroundColor = UIColorFromRGB(0x333333);
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KEYWINDOW.frame.size.width, 44.0f)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"...";
    _titleLabel.font = [UIFont fontWithName:@"LucidaGrande" size:25.0f];
    _titleLabel.textColor = UIColorFromRGB(0xFFFFFF);
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
    
    [self hideTitleBar];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    
//}
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

- (void)getImageFromURL:(NSString*)urlPath completionNotification:(NSString*)notificationName {
    
    NSURL *baseURL = [NSURL URLWithString:BASE_API_URL];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
     manager.responseSerializer = [AFImageResponseSerializer serializer];
    
    [manager GET:urlPath parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"progress:%f",[uploadProgress fractionCompleted]);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NETWORK_INDICATOR(NO)
        NSLog(@"response:%@",responseObject);
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"task:%@\n\n[%@]%@",task,[error description],[error localizedDescription]);
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
        
        NSLog(@"progress:%f",[uploadProgress fractionCompleted]);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NETWORK_INDICATOR(NO)
        completion(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"task:%@\n\n[%@]%@",task,[error description],[error localizedDescription]);
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
    
    [self callPostSessionManager:manager :method :parameters :notificationName];
}

- (void)callPostSessionManager:(AFHTTPSessionManager*)manager :(NSString*)method :(NSDictionary*)parameters :(NSString*)notificationName {
    
    NETWORK_INDICATOR(YES)
    
    NSLog(@"parameters:%@",parameters);
    [manager POST:method parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"progress:%f",[uploadProgress fractionCompleted]);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NETWORK_INDICATOR(NO)
        NSLog(@"response:%@",responseObject);
        if ([responseObject isKindOfClass:[NSArray class]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:responseObject];
        }
        else if ([responseObject isKindOfClass:[NSDictionary class]] && [[responseObject allKeys] containsObject:@"error"]) {
            if([responseObject[@"error"] integerValue] == 404 && [notificationName isEqualToString:@"socialLoginObserver"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:responseObject];
            }else {
                [self resolveErrorResponse:responseObject withNotification:notificationName];
            }
            
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:responseObject];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"task:%@\n\n[%@]%@",task,[error description],[error localizedDescription]);
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
    
    [manager GET:method parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"progress:%f",[uploadProgress fractionCompleted]);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NETWORK_INDICATOR(NO)
        NSLog(@"response:%@",responseObject);
        if ([responseObject isKindOfClass:[NSArray class]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:responseObject];
        }
        else if ([responseObject isKindOfClass:[NSDictionary class]] && [[responseObject allKeys] containsObject:@"error"]) {
            if([responseObject[@"error"] integerValue] == 404 && [notificationName isEqualToString:@"socialLoginObserver"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:responseObject];
            }else {
                [self resolveErrorResponse:responseObject withNotification:notificationName];
            }
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:responseObject];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"task:%@\n\n[%@]%@",task,[error description],[error localizedDescription]);
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
    account.username = username;
    account.password = password;
    account.birthday = birthday;
    account.fullname = fullname;
    account.token = token;
    account.identifier = [NSString stringWithFormat:@"%@",identifier];
    NSLog(@"identifier USER:%@",identifier);
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
    else {}
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
    
    [self presentViewController:alert animated:YES completion:^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:response];
    }];
}

- (void) logoutUser {
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
        return;
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
    
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OrderList"];
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    
    NSArray *result = [NSArray arrayWithArray:[context executeFetchRequest:request error:&error]];
    
    if (result.count == 0) {
        NSDictionary *item = [self menuItemToDictionary:menu itemNumber:1];
        NSDictionary *bundle = @{@"identifier":item[@"identifier"],
                                  @"details":@[item],
                                  @"quantity":@1
                                  };
        NSArray *orderItems = [NSArray arrayWithObjects:bundle, nil];
        
        OrderList *order = [[OrderList alloc] initWithEntity:[NSEntityDescription entityForName:@"OrderList" inManagedObjectContext:context]  insertIntoManagedObjectContext:context];

        order.items = [self encodeData:orderItems withKey:@"orderItems"];
        order.orderSent = @NO;
        order.tableNumber = tableNumber;
        
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
    else {
        
        OrderList *order = (OrderList*)result[0];
        NSMutableArray *newOrderList = [NSMutableArray new];
        NSArray *decodedList = (NSArray*)[self decodeData:order.items forKey:@"orderItems"];
        
        BOOL isNewIdentifier = YES;
        
        [newOrderList addObjectsFromArray:decodedList];
        
        for (NSInteger index = 0; index < decodedList.count; index++) {
            NSMutableDictionary *bundle = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)decodedList[index]];
//            isNewIdentifier = YES;
            if ([bundle[@"identifier"] integerValue] == [menu.identifier integerValue]) {
                isNewIdentifier = NO;
                NSInteger sum = [bundle[@"quantity"] integerValue] + 1;
                
                NSMutableArray *itemDetails = [NSMutableArray arrayWithArray:(NSArray*)bundle[@"details"]];
                NSDictionary *item = [self menuItemToDictionary:menu itemNumber:sum];
                [itemDetails addObject:item];
                
                [bundle setObject:itemDetails forKey:@"details"];
                
                NSNumber *quantity = [NSNumber numberWithInteger:sum];
                [bundle setObject:quantity forKey:@"quantity"];
                
                [newOrderList replaceObjectAtIndex:index withObject:bundle];
            }
        }
        
        
        if (isNewIdentifier == YES) {
            NSDictionary *item = [self menuItemToDictionary:menu itemNumber:1];
            NSDictionary *bundle = @{@"identifier":item[@"identifier"],
                                     @"details":@[item],
                                     @"quantity":@1
                                     };
            [newOrderList addObject:bundle];
        }
        
        order.items = [self encodeData:newOrderList withKey:@"orderItems"];
        order.orderSent = @NO;
        order.tableNumber = tableNumber;
        
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
    
    return dictionary;
}


@end
