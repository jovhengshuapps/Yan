//
//  CoreViewController.h
//  Yan
//
//  Created by Joshua Jose Pecson on 3/31/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "Config.h"

@interface CoreViewController : UIViewController <AlertViewDelegate>
@property (strong, nonatomic, nullable) IBOutlet UIView *titleBarView;

- (void) showTitleBar:( nullable NSString*)title;
- (void) hideTitleBar;
- ( nonnull Account*) userLoggedIn;
- (void) logoutUser;
- (void) isFromRegistration:(BOOL)fromRegistration;
- (void)callAPI:( nullable NSString*)method withParameters:( nullable NSDictionary*)parameters completionNotification:( nullable NSString*)notificationName;
- (void)callGETAPI:( nullable NSString*)method withParameters:( nullable NSDictionary*)parameters completionNotification:( nullable NSString*)notificationName;

- (void)callPOSTAPI:( nullable NSString*)method withParameters:( nullable NSDictionary*)parameters completionHandler:(void  (^_Nullable)(id _Nullable response))completion;

- (BOOL)saveSocialLoggedInAccount:( nullable NSString*)username :( nullable NSString*)password :( nullable NSString*)fullname :( nullable NSString*)birthday :( nullable NSString*)token :( nullable NSNumber*)identifier;

- (BOOL)saveLoggedInAccount:( nullable NSString*)username :( nullable NSString*)password :( nullable NSString*)fullname :( nullable NSString*)birthday :( nullable NSString*)token :( nullable NSNumber*)identifier;
-(void) openMenu;

- (void) addDoneToolbar:( nullable UITextField*)textfield;

- (void)getImageFromURL:( nullable NSString*)urlPath updateImageView:(nullable UIImageView*)imageView completionNotification:( nullable NSString*)notificationName;

- (void)getImageFromURL:( nullable NSString*)urlPath  completionHandler:(nullable void (^)(NSURLResponse * _Nullable response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler andProgress:(nullable void (^)(NSInteger expectedBytesToReceive, NSInteger receivedBytes))progress;

- ( nullable NSData*)encodeData:( nullable id)object withKey:( nullable NSString*)key;

- ( nullable id)decodeData:( nullable NSData*)data forKey:( nullable NSString*)key;

- (NSArray*) orderListFromUser:(Account*)userAccount onContext:(NSManagedObjectContext *)context;

//- (NSData*)encodeMenuList:(NSArray*)list withKey:(NSString*)key;
//- (NSArray*)decodeMenuList:(NSData*)data forKey:(NSString*)key;

- (void) addMenuItem:( nullable MenuItem*)menu tableNumber:( nullable NSString*)tableNumber;

- ( nullable NSDictionary*)menuItemToDictionary:( nullable MenuItem*)menuItem itemNumber:(NSInteger)itemNumber;

- (void) billoutRequestedOrdersCleared;

@end
