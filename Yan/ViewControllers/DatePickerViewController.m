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
- (IBAction)donePressed:(id)sender {
    NSDate *myDate = self.datePicker.date;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/YYYY"];
    NSString *stringDate = [dateFormat stringFromDate:myDate];
    [self.delegate dateSelected:stringDate];
}

@end
