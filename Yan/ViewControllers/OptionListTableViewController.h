//
//  OptionListTableViewController.h
//  Yan
//
//  Created by Joshua Jose Pecson on 05/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "CoreViewController.h"
#import "CustomPickerViewController.h"

@interface OptionListTableViewController : CoreViewController <UITableViewDelegate, UITableViewDataSource, CustomPickerViewControllerDelegate>

@property (strong, nonatomic) NSString *menuName;
@property (strong,nonatomic) NSDictionary *optionList;

@end
