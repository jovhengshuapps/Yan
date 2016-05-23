//
//  ReserveRestoViewController.h
//  Yan
//
//  Created by Joshua Jose Pecson on 4/19/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "CoreViewController.h"
#import "DatePickerViewController.h"

@interface ReserveRestoViewController : CoreViewController <UIPopoverPresentationControllerDelegate, UITextFieldDelegate, DatePickerViewControllerDelegate>

@property (strong,nonatomic) Restaurant *restaurantDetails;

@end
