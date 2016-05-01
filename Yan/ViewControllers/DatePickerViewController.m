//
//  DatePickerViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 30/04/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController()
@property (weak, nonatomic) IBOutlet UIButton *buttonDone;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation DatePickerViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _datePicker.datePickerMode = _datePickerMode;
}
- (IBAction)donePressed:(id)sender {
    NSDate *myDate = self.datePicker.date;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    if (_datePickerMode == UIDatePickerModeDate) {
        [dateFormat setDateFormat:@"MM/dd/YYYY"];
    }
    else if (_datePickerMode == UIDatePickerModeTime) {
        [dateFormat setDateFormat:@"HH:mm"];
    }
    NSString *stringDate = [dateFormat stringFromDate:myDate];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate dateSelected:stringDate mode:_datePickerMode];
    }];
}

@end
