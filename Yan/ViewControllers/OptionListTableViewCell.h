//
//  OptionListTableViewCell.h
//  Yan
//
//  Created by Joshua Jose Pecson on 05/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPickerViewController.h"

@interface OptionListTableViewCell : UITableViewCell<UIPopoverPresentationControllerDelegate, CustomPickerViewControllerDelegate>
@property (strong, nonatomic) NSString *optionLabel;
@property (strong, nonatomic) NSArray *optionChoices;
@end
