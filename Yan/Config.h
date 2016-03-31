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
#import "AFNetworking.h"
#import "LGSideMenuController.h"
#import "DrawerTableViewController.h"
#import "RootViewController.h"

// MACROS

#define UIColorFromRGB(rgbValue)                        [UIColor \
                                                        colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                                        green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                                        blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define TextAttributes(fontName,fontColor, fontSize)    [NSDictionary dictionaryWithObjectsAndKeys: \
                                                        UIColorFromRGB(fontColor), NSForegroundColorAttributeName,\
                                                        [UIFont fontWithName:[NSString stringWithFormat:@"%@",fontName] size:fontSize], NSFontAttributeName,\
                                                        nil]

// CONFIGURATIONS


#endif /* Config_h */
