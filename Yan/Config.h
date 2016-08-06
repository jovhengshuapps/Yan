//
//  Config.h
//  Yan
//
//  Created by Joshua Jose Pecson on 3/31/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#ifndef Config_h
#define Config_h


// IMPORTS

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AFNetworking.h"

#import "REFrostedViewController.h"
#import "NavigationController.h"
#import "AlertView.h"
#import "CustomButton.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <CoreLocation/CoreLocation.h>
#import "UIImage+animatedGIF.h"
#import "FPPopoverController.h"
#import "ReminderNotificationViewController.h"

#import "AppDelegate.h"
#import "Account.h"
#import "Reservation.h"
#import "MenuItem.h"
#import "OrderList.h"
#import "Restaurant.h"
#import "Notification.h"

// MACROS

#define UIColorFromRGB(rgbValue)                                        [UIColor \
                                                                        colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                                                        green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                                                        blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define TextAttributes(fontName, fontColor, fontSize)                   [NSDictionary dictionaryWithObjectsAndKeys: \
                                                                        UIColorFromRGB(fontColor), NSForegroundColorAttributeName,\
                                                                        [UIFont fontWithName:[NSString stringWithFormat:@"%@",fontName] size:fontSize], NSFontAttributeName,\
                                                                        \
                                                                        nil]
#define KEYWINDOW                                                       [UIApplication sharedApplication].keyWindow

#define APPINFO(key)                                                    [[NSBundle mainBundle] objectForInfoDictionaryKey:key];

#define NETWORK_INDICATOR(bool)                                         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:bool];

#define isNIL(key)                                                      (key && ![key isKindOfClass:[NSNull class]])?key:@""

// NOTIFICATION OBSERVER NAME

#define ChangeHomeViewToShow                                            @"ChangeHomeViewToShow"

// CONFIGURATIONS

#define GOOGLE_CLIENT_ID                                                @"668953075234-bf7f3vasveo0dj919fp75aj0saoa4vc9.apps.googleusercontent.com"


//#define ARTSY_LOGO_URL                                                  @"/yan-uploads/yan_uploads/J9TN1GDYYN8U/image_JABGsi1.jpeg"

// API CALLS
#define BASE_URL                                                        @"http://yan.bilinear.ph"

#define BASE_API_URL                                                    [NSString stringWithFormat:@"%@%@",BASE_URL,@"/api_v1/"]

#define API_USER_REGISTER                                               @"user/register"

#define API_USER_LOGIN                                                  @"user/login"

#define API_USER_LOGOUT(USER_ID)                                        [NSString stringWithFormat:@"user/logout/%@",USER_ID]

#define API_RESTAURANTS                                                 @"restaurant"

#define API_MENU(RESTAURANT_ID)                                                 [NSString stringWithFormat:@"restaurant/menus/%li",(long)RESTAURANT_ID]

#define API_RESERVATION(RESTAURANT_ID,USER_ID)                          [NSString stringWithFormat:@"reservation/%@/user/%@",RESTAURANT_ID,USER_ID]

#define API_RESERVATION_CHECKTIME(RESTAURANT_ID)                          [NSString stringWithFormat:@"reservation/%@",RESTAURANT_ID]

#define API_WAITER(RESTAURANT_ID)                                                 [NSString stringWithFormat:@"call_waiter/%li",(long)RESTAURANT_ID]


#define API_SENDORDER(RESTAURANT_ID,USER_ID)                          [NSString stringWithFormat:@"order/%@/user/%@",RESTAURANT_ID,USER_ID]

#define API_SENDORDERUPDATE(RESTAURANT_ID,USER_ID,ORDER_ID)                          [NSString stringWithFormat:@"order_update/%@/user/%@/update/%@",RESTAURANT_ID,USER_ID,ORDER_ID]

#define API_BILLOUT(RESTAURANT_ID,ORDER_ID)                          [NSString stringWithFormat:@"bill_out/%@/order/%@",RESTAURANT_ID,ORDER_ID]

#define API_RESTAURANT_DETAILS(RESTAURANT_ID)                           [NSString stringWithFormat:@"restaurant/details/%@",RESTAURANT_ID]

#define API_GETTABLEORDERS(RESTAURANT_ID,TABLE_NUMBER)                          [NSString stringWithFormat:@"table_orders/%@/table/%@",RESTAURANT_ID,TABLE_NUMBER]


#define API_GETBACKGROUND_IMAGE                                         [NSString stringWithFormat:@"admin/background/image"]

#endif /* Config_h */
