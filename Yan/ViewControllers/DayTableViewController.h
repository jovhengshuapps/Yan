//
//  DayTableViewController.h
//  Yan
//
//  Created by Joshua Jose Pecson on 09/06/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"

@protocol  DayTableViewControllerDelegate <NSObject>

-(void)selectedDay:(NSDictionary*)day;

@end
@interface DayTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *availableDays;
@property (assign,nonatomic) id<DayTableViewControllerDelegate> delegatePicker;

@end
