//
//  ReminderNotificationViewController.h
//  Yan
//
//  Created by Joshua Jose Pecson on 09/06/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminderNotificationViewController : UIViewController

@property (strong, nonatomic) NSString *restaurantName;
@property (strong, nonatomic) NSString *reservationTimeFrom;
@property (strong, nonatomic) NSString *reservationTimeTo;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *bodyText;

@end
