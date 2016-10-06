//
//  AppDelegate.m
//  Yan
//
//  Created by Joshua Jose Pecson on 3/31/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "Config.h"
//#import <Fabric/Fabric.h>
//#import <Crashlytics/Crashlytics.h>



@interface AppDelegate ()

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //[Fabric with:@[[Crashlytics class]]];
    
    
    
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x660000)];
    [[UINavigationBar appearance] setTintColor:UIColorFromRGB(0xFFFFFF)];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    
    UIApplication *app = [UIApplication sharedApplication];
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -app.statusBarFrame.size.height, self.window.rootViewController.view.bounds.size.width + 200.0f, app.statusBarFrame.size.height)];
    statusBarView.backgroundColor = [UIColor blackColor];
    
    [[UINavigationBar appearance] addSubview:statusBarView];
    
    [[UINavigationBar appearance] setTitleTextAttributes:TextAttributes(@"LucidaGrande",0xFFFFFF,18.0f)];
    
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:3.0f forBarMetrics:UIBarMetricsDefault];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    [GIDSignIn sharedInstance].clientID = GOOGLE_CLIENT_ID;
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    self.deviceToken = @"dffb861f98604e27cac021b76d1a6cca0019bfdf842adadd50982f2fa68c086a";
    
    return YES;
}
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    BOOL handled = NO;
    
    if ([[url absoluteString] rangeOfString:@"facebook"].location != NSNotFound) {
        handled = [[FBSDKApplicationDelegate sharedInstance] application:[UIApplication sharedApplication]
                                                                 openURL:url
                                                       sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                              annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
        
    }
    else if ([[url absoluteString] rangeOfString:@"waze"].location != NSNotFound) {
        handled = YES;
    }
    else {
        handled = [[GIDSignIn sharedInstance] handleURL:url
                                      sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                             annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
        
    }
    return handled;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL handled = NO;
    if ([[url absoluteString] rangeOfString:@"facebook"].location != NSNotFound) {
        handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                 openURL:url
                                                       sourceApplication:sourceApplication
                                                              annotation:annotation];
        
    }
    else if ([[url absoluteString] rangeOfString:@"waze"].location != NSNotFound) {
        handled = YES;
    }
    else {
        handled = [[GIDSignIn sharedInstance] handleURL:url
                                      sourceApplication:sourceApplication
                                             annotation:annotation];

    }
    return handled;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

//    self.deviceToken=[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
//    self.deviceToken = [self.deviceToken stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    self.deviceToken = [self.deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    char * tokenChars = (char*)[deviceToken bytes];
    NSMutableString * tokenString = [NSMutableString new];
    
    for (NSInteger i = 0; i < deviceToken.length; i++) {
        [tokenString appendFormat:@"%02.2hhx", tokenChars[i]];
    }
    
//    NSLog(@"tokenString:%@",tokenString);
    self.deviceToken = tokenString;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
//        NSLog(@"received notification:%@",userInfo);
    [self saveNotificationData:userInfo[@"aps"][@"alert"]];
    [UIApplication sharedApplication].applicationIconBadgeNumber += [[[userInfo objectForKey:@"aps"] objectForKey: @"badge"] intValue];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
//    NSLog(@"completion received notification:%@",userInfo);
    [self saveNotificationData:userInfo[@"aps"][@"alert"]];
    
    completionHandler(UIBackgroundFetchResultNewData);
    
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//    NSLog(@"error:%@",error.description);
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    [FBSDKAppEvents activateApp];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Notification"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"type == 'reminder' OR type == 'notification'"]];
    
    NSError *error = nil;
    
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if (result.count) {
        Notification * notificationData = (Notification*)[result lastObject];
        
        self.notificationUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:notificationData.type,@"type",notificationData.name,@"name",notificationData.reservation_time,@"reservation-time",notificationData.title,@"title",notificationData.body_text,@"body", nil];
        
        
        [context deleteObject:notificationData];
        
        error = nil;
        if ([context save:&error]) {
            [self showNoticationScreen:self.notificationUserInfo];
        }
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.jovhengshuapps.yan.Yan" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Yan" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Yan.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark GoogleSignIn Delegate
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
//    NSString *userId = user.userID;                  // For client-side use only!
//    NSString *idToken = user.authentication.idToken; // Safe to send to the server
//    NSString *fullName = user.profile.name;
//    NSString *givenName = user.profile.givenName;
//    NSString *familyName = user.profile.familyName;
//    NSString *email = user.profile.email;
    // ...
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}




- (NSInteger) hourFromString:(NSString*)string {
    if ([string rangeOfString:@"AM"].location != NSNotFound) {
        return [[string componentsSeparatedByString:@":"][0] integerValue];
    }
    else if ([string rangeOfString:@"PM"].location != NSNotFound) {
        return [[string componentsSeparatedByString:@":"][0] integerValue] + 12;
    }
    return 0;
}

- (void) saveNotificationData:(NSDictionary*)data {
    
//    NSLog(@"data:%@",data);
    if (data[@"confirm_order"]) {
        self.notificationUserInfo = nil;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"get_table_orders"  object:nil];
        
        
        
    }
    else if (data[@"billout"]) {
        self.notificationUserInfo = nil;
        
        NSManagedObjectContext *contextAccount = self.managedObjectContext;
        
        NSFetchRequest *requestAccount = [[NSFetchRequest alloc] initWithEntityName:@"Account"];
        NSError *error = nil;
        
        NSArray *accounts = [contextAccount executeFetchRequest:requestAccount error:&error];
        Account *loggedUSER = (Account*)accounts[0];
        
        
        AlertView *alert = [[AlertView alloc] initAlertWithMessage:[NSString stringWithFormat:@"%@ has requested to bill out the orders from your table.\n\nTable %@",data[@"billout"][@"name"],data[@"billout"][@"table_number"]] delegate:nil buttons:nil];
        [alert showAlertView];
        
        
        NSManagedObjectContext *context = self.managedObjectContext;
        
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OrderList"];
        
        [request setPredicate:[NSPredicate predicateWithFormat:@"tableNumber == %@ AND restaurant_id == %@", loggedUSER.current_tableNumber, loggedUSER.current_restaurantID]];
        
        error = nil;
        NSArray *result = [NSArray arrayWithArray:[context executeFetchRequest:request error:&error]];
        if (result.count) {
            OrderList *order = (OrderList*)result[0];
            [context deleteObject:order];
        }
        
        error = nil;
        if ([context save:&error]) {
            
//            NSManagedObjectContext *contextAccount = self.managedObjectContext;
//            
//            NSFetchRequest *requestAccount = [[NSFetchRequest alloc] initWithEntityName:@"Account"];
//            
//            error = nil;
//            
//            NSArray *accounts = [contextAccount executeFetchRequest:requestAccount error:&error];
//            Account *loggedUSER = (Account*)accounts[0];
            loggedUSER.current_restaurantID = @"";
            loggedUSER.current_tableNumber = @"";
            loggedUSER.current_restaurantName = @"";
            
            error = nil;
            if ([contextAccount save:&error]) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"billoutRequestedOrdersClearedObserver"  object:@""];
            }
            
            
        }
        
    }
    else {
        
        
        self.notificationUserInfo = [NSDictionary dictionaryWithDictionary:data];
        
        NSManagedObjectContext *context = self.managedObjectContext;
        
        Notification *notificationItem = [[Notification alloc] initWithEntity:[NSEntityDescription entityForName:@"Notification" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
        
        
        notificationItem.name = isNIL(data[@"name"]);
        notificationItem.title = isNIL(data[@"title"]);
        notificationItem.body_text = isNIL(data[@"body"]);
        notificationItem.reservation_time = isNIL(data[@"reservation-time"]);
        if (data[@"name"] && [data[@"name"] length]) {
            notificationItem.type = @"reminder";
        }
        else {
            notificationItem.type = @"notification";
        }
        
        NSError *error = nil;
        
        [context save:&error];
    }
    
    
    [self showNoticationScreen:self.notificationUserInfo];
    
    
}




- (void) showNoticationScreen:(NSDictionary*)notificationData {
    if (notificationData != nil) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
        
        ReminderNotificationViewController *reminder = [storyboard instantiateViewControllerWithIdentifier:@"reminderNotification"];
        if (notificationData[@"name"] && [notificationData[@"name"] length]) {
            reminder.restaurantName = self.notificationUserInfo[@"name"];
            reminder.reservationTimeFrom = self.notificationUserInfo[@"reservation-time"];
            reminder.type = @"reminder";
        }
        else {
//            NSLog(@"notification:%@",self.notificationUserInfo);
            reminder.type = @"notification";
            reminder.notificationTitle = self.notificationUserInfo[@"title"];
            reminder.bodyText = self.notificationUserInfo[@"body"];
            reminder.restaurantName = self.notificationUserInfo[@"restaurant-name"];
            reminder.numberOfPerson = [NSString stringWithFormat:@"%@",self.notificationUserInfo[@"number-of-person"]];
            reminder.restaurantAddress = self.notificationUserInfo[@"restaurant-address"];
            reminder.restaurantContact = self.notificationUserInfo[@"restaurant-contacts"];
            reminder.restaurantOperation = self.notificationUserInfo[@"restaurant-hours"];
            
//            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//            NSDate *currentDate = [NSDate date];
//            NSDateComponents *comps = [[NSDateComponents alloc] init];
//            //        [comps setDay:1];
//            [comps setHour:5];
//            NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
            
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            NSLocale *twelveHourLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            dateFormatter.locale = twelveHourLocale;
            [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
            
            NSDate *reservationDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ %@",self.notificationUserInfo[@"reservation-date"],self.notificationUserInfo[@"reservation-time"]]];
            
//            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//            
//            NSDateComponents *comps = [[NSDateComponents alloc] init];
            
//            [comps setHour:-1];
//            NSDate *minDate = [calendar dateByAddingComponents:comps toDate:reservationDate options:0];
//            reminder.reservationDateTime = minDate;
            reminder.reservationDateTime = reservationDate;
            
//            if([self.notificationUserInfo[@"title"] rangeOfString:@"order"].location != NSNotFound) {
//                
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"lockOrderListObserver"  object:@""];
//            }
        }
        
        [self.window addSubview:reminder.view];
        [self.window.rootViewController addChildViewController:reminder];
        [reminder didMoveToParentViewController:self.window.rootViewController];
        
        
        //remove notifications
        NSManagedObjectContext *context = self.managedObjectContext;
        
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Notification"];
        [request setPredicate:[NSPredicate predicateWithFormat:@"type == 'reminder' OR type == 'notification'"]];
        
        NSError *error = nil;
        
        NSArray *result = [context executeFetchRequest:request error:&error];
        
        if (result.count) {
            for (Notification *notificationData in result) {
                
                [context deleteObject:notificationData];
                
                error = nil;
                [context save:&error];
            }
            
        }
        
    }
}

- (NSData*)encodeData:(id)object withKey:(NSString*)key {
    NSMutableData *data = [NSMutableData new];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:object forKey:key];
    [archiver finishEncoding];
    return data;
}
@end
