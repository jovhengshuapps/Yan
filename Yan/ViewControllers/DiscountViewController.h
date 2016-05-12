//
//  DiscountViewController.h
//  Yan
//
//  Created by Joshua Jose Pecson on 12/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "CoreViewController.h"
#import "CustomPickerViewController.h"

@interface DiscountViewController : CoreViewController <UITableViewDataSource, UITableViewDelegate, CustomPickerViewControllerDelegate, FPPopoverControllerDelegate>
@property (strong, nonnull) NSString *tableNumber;
@end
