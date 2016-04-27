//
//  CoreViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 3/31/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "CoreViewController.h"
#import "RegistrationCompleteViewController.h"
#import "AppDelegate.h"

@interface CoreViewController ()
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation CoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.title = @"Yan";
    
    //Setup Title Bar
    _titleBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.bounds.size.width, self.navigationController.navigationBar.frame.size.height)];
    _titleBarView.backgroundColor = UIColorFromRGB(0x333333);
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _titleBarView.frame.size.width, _titleBarView.frame.size.height)];
    _titleLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:@"..." attributes:TextAttributes(@"LucidaGrande", (0xFFFFFF), 25.0f)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self hideTitleBar];
    
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
    
    [_titleBarView addSubview:_titleLabel];
    [self.navigationController.navigationBar addSubview:_titleBarView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self hideTitleBar];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void) showTitleBar:(NSString*)title {
    _titleBarView.hidden = NO;
    _titleLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:[title uppercaseString] attributes:TextAttributes(@"LucidaGrande", (0xFFFFFF), _titleBarView.frame.size.height - 20.0f)];
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

- (void)callAPI:(NSString*)method withParameters:(NSDictionary*)parameters completionNotification:(NSString*)notificationName{
    
    NSURL *baseURL = [NSURL URLWithString:BASE_API_URL];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    if (@"token") {
        
        [manager.requestSerializer setValue:@"token" forHTTPHeaderField:@"x-yan-resto-api"];
    }
    
    [self callPostSessionManager:manager :method :parameters :notificationName];
}

- (void)callPostSessionManager:(AFHTTPSessionManager*)manager :(NSString*)method :(NSDictionary*)parameters :(NSString*)notificationName {
    
    NETWORK_INDICATOR(YES)
    
    [manager POST:method parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"progress:%f",[uploadProgress fractionCompleted]);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"response:%@",responseObject);
        NETWORK_INDICATOR(NO)
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NETWORK_INDICATOR(NO)
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
}

- (BOOL)saveLoggedInAccount:(NSString*)username :(NSString*)password :(NSString*)fullname :(NSString*)birthday :(NSString*)token {
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    Account *account = [[Account alloc] initWithEntity:[NSEntityDescription entityForName:@"Account" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
    account.username = username;
    account.password = password;
    account.birthday = birthday;
    account.fullname = fullname;
    account.token = token;
    
    NSError *error = nil;
    if ([context save:&error]) {
        return YES;
    }
    else {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    return NO;
}

- (NSDictionary*) getMenuForRestaurant:(NSString*)restaurantName {
    //dummy data
    NSDictionary *data = @{};
    if ([restaurantName isEqualToString:@"dummy"]) {
        data = @{
                 @"categories": @[
                         @{
                             @"menu": @[
                                     @{
                                         @"price": @"120.00",
                                         @"image": @"/uploads/yan_uploads/V6YSF2IZMZ72/menu/banana-split.jpg",
                                         @"id": @1,
                                         @"name": @"Banana Split",
                                         @"desc": @""
                                         }
                                     ],
                             @"name": @"Main Course"
                             },
                         @{
                             @"menu": @[
                                     @{
                                         @"price": @"120.00",
                                         @"image": @"/uploads/yan_uploads/V6YSF2IZMZ72/menu/banana-split.jpg",
                                         @"id": @1,
                                         @"name": @"Banana Split",
                                         @"desc": @""
                                         },
                                     @{
                                         @"price": @"120.00",
                                         @"image": @"/uploads/yan_uploads/V6YSF2IZMZ72/menu/banana-split.jpg",
                                         @"id": @1,
                                         @"name": @"Banana Split",
                                         @"desc": @""
                                         },
                                     @{
                                         @"price": @"120.00",
                                         @"image": @"/uploads/yan_uploads/V6YSF2IZMZ72/menu/banana-split.jpg",
                                         @"id": @1,
                                         @"name": @"Banana Split",
                                         @"desc": @""
                                         },
                                     @{
                                         @"price": @"120.00",
                                         @"image": @"/uploads/yan_uploads/V6YSF2IZMZ72/menu/banana-split.jpg",
                                         @"id": @1,
                                         @"name": @"Banana Split",
                                         @"desc": @""
                                         }
                                     ],
                             @"name": @"Desserts"
                             },
                         @{
                             @"menu": @[
                                     @{
                                         @"price": @"120.00",
                                         @"image": @"/uploads/yan_uploads/V6YSF2IZMZ72/menu/banana-split.jpg",
                                         @"id": @1,
                                         @"name": @"Banana Split",
                                         @"desc": @""
                                         },
                                     @{
                                         @"price": @"120.00",
                                         @"image": @"/uploads/yan_uploads/V6YSF2IZMZ72/menu/banana-split.jpg",
                                         @"id": @1,
                                         @"name": @"Banana Split",
                                         @"desc": @""
                                         }
                                     ],
                             @"name": @"Appetizers"
                             },
                         @{
                             @"menu": @[
                                     @{
                                         @"price": @"120.00",
                                         @"image": @"/uploads/yan_uploads/V6YSF2IZMZ72/menu/banana-split.jpg",
                                         @"id": @1,
                                         @"name": @"Banana Split",
                                         @"desc": @""
                                         },
                                     @{
                                         @"price": @"120.00",
                                         @"image": @"/uploads/yan_uploads/V6YSF2IZMZ72/menu/banana-split.jpg",
                                         @"id": @1,
                                         @"name": @"Banana Split",
                                         @"desc": @""
                                         }
                                     ],
                             @"name": @"Soup"
                             },
                         @{
                             @"menu": @[
                                     @{
                                         @"price": @"120.00",
                                         @"image": @"/uploads/yan_uploads/V6YSF2IZMZ72/menu/banana-split.jpg",
                                         @"id": @1,
                                         @"name": @"Banana Split",
                                         @"desc": @""
                                         },
                                     @{
                                         @"price": @"120.00",
                                         @"image": @"/uploads/yan_uploads/V6YSF2IZMZ72/menu/banana-split.jpg",
                                         @"id": @1,
                                         @"name": @"Banana Split",
                                         @"desc": @""
                                         }
                                     ],
                             @"name": @"Noodles"
                             },
                         @{
                             @"menu": @[
                                     @{
                                         @"price": @"120.00",
                                         @"image": @"/uploads/yan_uploads/V6YSF2IZMZ72/menu/banana-split.jpg",
                                         @"id": @1,
                                         @"name": @"Banana Split",
                                         @"desc": @""
                                         },
                                     @{
                                         @"price": @"120.00",
                                         @"image": @"/uploads/yan_uploads/V6YSF2IZMZ72/menu/banana-split.jpg",
                                         @"id": @1,
                                         @"name": @"Banana Split",
                                         @"desc": @""
                                         }
                                     ],
                             @"name": @"Beverages"
                             }
                         ],
                 @"restaurant": @{
                         @"image": @"/uploads/restaurant/default-restaurant.jpg",
                         @"payment_options": @"",
                         @"name": @"Pancake House",
                         @"location": @"Caiptol Commons"
                         }
                 };
    }
    
    return data;
}

@end
