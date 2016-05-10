//
//  CoreViewController.h
//  Yan
//
//  Created by Joshua Jose Pecson on 3/31/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "Config.h"

@interface CoreViewController : UIViewController <AlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *titleBarView;

- (void) showTitleBar:(NSString*)title;
- (void) hideTitleBar;
- (Account*) userLoggedIn;
- (void) logoutUser;
- (void) isFromRegistration:(BOOL)fromRegistration;
- (void)callAPI:(NSString*)method withParameters:(NSDictionary*)parameters completionNotification:(NSString*)notificationName;
- (void)callGETAPI:(NSString*)method withParameters:(NSDictionary*)parameters completionNotification:(NSString*)notificationName;

- (BOOL)saveLoggedInAccount:(NSString*)username :(NSString*)password :(NSString*)fullname :(NSString*)birthday :(NSString*)token;
-(void) openMenu;

- (void) addDoneToolbar:(UITextField*)textfield;

- (void)getImageFromURL:(NSString*)urlPath completionNotification:(NSString*)notificationName;

- (NSData*)encodeData:(id)object withKey:(NSString*)key;

- (id)decodeData:(NSData*)data forKey:(NSString*)key;
@end
