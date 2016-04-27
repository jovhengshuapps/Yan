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
#import "AFNetworking.h"
#import "REFrostedViewController.h"
#import "NavigationController.h"
#import "AlertView.h"
#import "CustomButton.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <GoogleSignIn/GoogleSignIn.h>

#import "Account.h"

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

// NOTIFICATION OBSERVER NAME

#define ChangeHomeViewToShow                                            @"ChangeHomeViewToShow"

// CONFIGURATIONS

#define GOOGLE_CLIENT_ID                                                @"668953075234-bf7f3vasveo0dj919fp75aj0saoa4vc9.apps.googleusercontent.com"




// API CALLS
#define BASE_API_URL                                                    @"http://yan.cybernetics-it.info/api_v1/"

#define API_USER_REGISTER                                               @"user/register"

#define API_USER_LOGIN                                                  @"user/login"

#endif /* Config_h */
