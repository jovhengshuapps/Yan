//
//  PaymentSelectViewController.h
//  Yan
//
//  Created by Joshua Jose Pecson on 10/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "CoreViewController.h"
#import "CustomPickerViewController.h"

@interface PaymentSelectViewController : CoreViewController <UITableViewDataSource, UITableViewDelegate, CustomPickerViewControllerDelegate, FPPopoverControllerDelegate, UIScrollViewDelegate, UITextFieldDelegate>
@property (strong,nonatomic) NSString *tableNumber;
@end
