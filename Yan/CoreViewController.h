//
//  CoreViewController.h
//  Yan
//
//  Created by Joshua Jose Pecson on 3/31/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "Config.h"

@interface CoreViewController : UIViewController <AlertViewDelegate>
@property (strong, nonatomic) UIView *titleBarView;

- (void) showTitleBar:(NSString*)title;
- (void) hideTitleBar;
- (Account*) userLoggedIn;
- (void) isFromRegistration:(BOOL)fromRegistration;
- (void)callAPI:(NSString*)method withParameters:(NSDictionary*)parameters completionNotification:(NSString*)notificationName;
- (NSDictionary*) getMenuForRestaurant:(NSString*)restaurantName;

- (BOOL)saveLoggedInAccount:(NSString*)username :(NSString*)password :(NSString*)fullname :(NSString*)birthday :(NSString*)token;
@end
