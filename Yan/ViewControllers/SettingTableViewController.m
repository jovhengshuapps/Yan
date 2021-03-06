//
//  SettingTableViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 17/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "SettingTableViewController.h"
#import "Config.h"
#import "ProfileBirthdayViewController.h"
#import "ProfilePasswordViewController.h"
#import "ProfileTextFieldViewController.h"

@interface SettingTableViewController ()
@property (strong, nonatomic) NSArray *arraySettings;
@property (strong, nonatomic) NSDictionary *settingDetails;
@property (assign, nonatomic) BOOL isSocial;
@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"Settings";
    self.isSocial = NO;
    [self refreshAccountDetails];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.title = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) refreshAccountDetails {
    
    
    BOOL pushNotification_ON = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
    //    UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    //    if (types == UIRemoteNotificationTypeBadge){
    //    }
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Account"];
    
    NSError *error = nil;
    
    NSArray *result = [context executeFetchRequest:request error:&error];
    self.settingDetails = nil;
    self.arraySettings = nil;
    if (result.count) {
        Account *account = ((Account*)result[0]);
        self.isSocial = [account.is_social boolValue];
        
        self.settingDetails = @{@"fullname":account.fullname,
                                @"birthday":account.birthday,
                                @"email":account.username,
                                @"password":account.password,
                                @"pushnotification":[NSNumber numberWithBool:pushNotification_ON],
                                @"authorize":@"Logout"
                                };
        self.arraySettings = @[@"fullname",@"birthday",@"email",@"password",@"pushnotification",@"authorize"];
    }
    else {
        self.settingDetails = @{@"fullname":@"",
                                @"birthday":@"",
                                @"email":@"",
                                @"password":@"",
                                @"pushnotification":[NSNumber numberWithBool:pushNotification_ON],
                                @"authorize":@"Login"
                                };
        self.arraySettings = @[@"pushnotification",@"authorize"];
    }

    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _arraySettings.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_arraySettings[indexPath.row] isEqualToString:@"authorize"]) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.textLabel.text = _settingDetails[@"authorize"];
        return cell;
    }
    else if ([_arraySettings[indexPath.row] isEqualToString:@"pushnotification"]) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pushNotificationCell" forIndexPath:indexPath];
        UILabel *label = nil;
        UISwitch *switchControl = nil;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pushNotificationCell"];
        }
        for (UIView *subview in cell.contentView.subviews) {
            if (subview.tag == 1 && [subview isKindOfClass:[UILabel class]]) {
                label = (UILabel*)subview;
            }
            else if (subview.tag == 2 && [subview isKindOfClass:[UISwitch class]]) {
                switchControl = (UISwitch*)subview;
                [switchControl addTarget:self action:@selector(changeNotification:) forControlEvents:UIControlEventValueChanged];
            }
        }
        label.text = @"Push Notification";
        [switchControl setOn:[_settingDetails[@"pushnotification"] boolValue]];
        
        return cell;
    }
    else {
        
        UITableViewCell *cell = nil;
        if (self.isSocial && ([_arraySettings[indexPath.row] isEqualToString:@"email"] || [_arraySettings[indexPath.row] isEqualToString:@"password"])) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
        }
        else {
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"profileInfoCell" forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"profileInfoCell"];
            }
        }
        
        
        if ([_arraySettings[indexPath.row] isEqualToString:@"password"]) {
            cell.textLabel.text = @"Password";
        }
        else if ([_arraySettings[indexPath.row] isEqualToString:@"birthday"]) {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy"];
            
            NSDate *birthdate = [dateFormatter dateFromString:_settingDetails[_arraySettings[indexPath.row]]];
            [dateFormatter setDateFormat:@"MMMM dd, YYYY"];
            cell.textLabel.text = [dateFormatter stringFromDate:birthdate];
        }
        else {
            cell.textLabel.text = _settingDetails[_arraySettings[indexPath.row]];
        }
        return cell;
        
    }
    
    
}


- (void)changeNotification:(id)sender {
    UISwitch *switchControl = (UISwitch*)sender;
    if ([switchControl isOn]) {
//        NSLog(@"SET TO ON");
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else {
//        NSLog(@"SET TO OFF NOTIFICAITON");
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeNone categories:nil]];
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([_arraySettings[indexPath.row] isEqualToString:@"authorize"]) {
        if ([_settingDetails[@"authorize"] isEqualToString:@"Login"]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Logout"] message:@"Are you sure?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionNO = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            UIAlertAction *actionYES = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                [self logoutUser];
                
                
//                NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
//                NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Account"];
//                
//                NSError *error = nil;
//                
//                NSArray *result = [context executeFetchRequest:request error:&error];
//                
//                
//                for (Account *account in result) {
//                    [context deleteObject:account];
//                }
//                
//                error = nil;
//                if ([context save:&error]) {
//                    //            [[GIDSignIn sharedInstance] signOut];
//                    //            FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//                    //            [login logOut];
//                    
//                    //remove orders
//                    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OrderList"];
//                    
//                    error = nil;
//                    
//                    NSArray *result = [context executeFetchRequest:request error:&error];
//                    
//                    
//                    for (OrderList *orders in result) {
//                        [context deleteObject:orders];
//                    }
//                    
//                    error = nil;
//                    if ([context save:&error]) {
//                        
//                        [[NSNotificationCenter defaultCenter] postNotificationName:ChangeHomeViewToShow object:@"HomeViewLogin"];
//                        [self.navigationController popToRootViewControllerAnimated:YES];
//                        return;
//                    }
//                    
//                }
            }];
            [alert addAction:actionNO];
            [alert addAction:actionYES];
            
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }
    }
    else if ([_arraySettings[indexPath.row] isEqualToString:@"pushnotification"]) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        UISwitch *switchControl = nil;
        for (UIView *subview in cell.contentView.subviews) {
            if (subview.tag == 2 && [subview isKindOfClass:[UISwitch class]]) {
                switchControl = (UISwitch*)subview;
                break;
            }
        }
        
        [switchControl setOn:![switchControl isOn]];
        [self changeNotification:switchControl];
    }
    
    else if (self.isSocial && ([_arraySettings[indexPath.row] isEqualToString:@"email"] || [_arraySettings[indexPath.row] isEqualToString:@"password"])) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    else {
        if ([_arraySettings[indexPath.row] isEqualToString:@"fullname"] || [_arraySettings[indexPath.row] isEqualToString:@"email"]) {
            ProfileTextFieldViewController *profile = (ProfileTextFieldViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"profileTextField"];
            profile.titleText = [_arraySettings[indexPath.row] uppercaseString];
            profile.currentValue = _settingDetails[_arraySettings[indexPath.row]];
            [self.navigationController pushViewController:profile animated:YES];
        }
        else if ([_arraySettings[indexPath.row] isEqualToString:@"birthday"]) {
            ProfileBirthdayViewController *profile = (ProfileBirthdayViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"profileBirthday"];
            profile.birthday = _settingDetails[_arraySettings[indexPath.row]];
            [self.navigationController pushViewController:profile animated:YES];
        }
        else if ([_arraySettings[indexPath.row] isEqualToString:@"password"]) {
            ProfilePasswordViewController *profile = (ProfilePasswordViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"profilePassword"];
            profile.currentPassword = _settingDetails[_arraySettings[indexPath.row]];
            [self.navigationController pushViewController:profile animated:YES];
        }
    }
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


- (void)callGetSessionManager:(AFHTTPSessionManager*)manager :(NSString*)method :(NSDictionary*)parameters :(NSString*)notificationName {
    
    NETWORK_INDICATOR(YES)
    
    [manager GET:method parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
//        NSLog(@"progress:%f",[uploadProgress fractionCompleted]);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NETWORK_INDICATOR(NO)
//        NSLog(@"response:%@",responseObject);
        if ([responseObject isKindOfClass:[NSArray class]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:responseObject];
        }
        else if ([responseObject isKindOfClass:[NSDictionary class]] && [[responseObject allKeys] containsObject:@"error"]) {
            if([responseObject[@"error"] integerValue] == 404 && [notificationName isEqualToString:@"socialLoginObserver"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:responseObject];
            }
//            else {
//                [self resolveErrorResponse:responseObject withNotification:notificationName];
//            }
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:responseObject];
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

- (void) logoutUser {
    
    Account *account = [self userLoggedIn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutCurrentAccount:) name:@"logoutCurrentAccount" object:nil];
    [self callGETAPI:API_USER_LOGOUT(account.identifier) withParameters:@{} completionNotification:@"logoutCurrentAccount"];
}



- (void) logoutCurrentAccount:(NSNotification*)notification {
    if ([[notification.object objectForKey:@"success"] boolValue] == YES) {
//        NSLog(@"response:%@",notification.object);
        NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Account"];
        
        NSError *error = nil;
        
        NSArray *result = [context executeFetchRequest:request error:&error];
        
        
        for (Account *account in result) {
            [context deleteObject:account];
        }
        
        error = nil;
        if ([context save:&error]) {
            
            //remove orders
            NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OrderList"];
            
            error = nil;
            
            NSArray *result = [context executeFetchRequest:request error:&error];
            
            
            for (OrderList *orders in result) {
                [context deleteObject:orders];
            }
            
            error = nil;
            if ([context save:&error]) {
                [[GIDSignIn sharedInstance] signOut];
                FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
                [login logOut];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:ChangeHomeViewToShow object:@"HomeViewLogin"];
                [self.navigationController popToRootViewControllerAnimated:YES];
                return;
            }
            
        }
    }
    
}


@end
