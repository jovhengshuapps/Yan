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
    if (_birthdayValidation) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *currentDate = [NSDate date];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setYear:-1];
        NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        
        [_datePicker setMaximumDate:maxDate];
    }
    
    if (_todayValidation) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *currentDate = [NSDate date];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setDay:1];
        [comps setHour:1];
        NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        
        [_datePicker setMinimumDate:minDate];
    }
}

- (IBAction)donePressed:(id)sender {
    NSDate *myDate = self.datePicker.date;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    if (_datePickerMode == UIDatePickerModeDate) {
        [dateFormat setDateFormat:@"MM/dd/YYYY"];
    }
    else if (_datePickerMode == UIDatePickerModeTime) {
        [dateFormat setDateFormat:@"hh:mm aa"];
        
    }
    NSString *stringDate = [dateFormat stringFromDate:myDate];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate dateSelected:stringDate mode:_datePickerMode];
    }];
}

-(void)disableDate{
    
    NSDate *pickedDate = self.datePicker.date;  // Get current Date
    
    for (NSDate *disabledDate in self.disabledDates) {
        if([pickedDate compare:disabledDate] == NSOrderedSame){
//            [self.datePicker setDate:[self someOtherDate] animated:YES];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Schedule Unavailable"] message:@"The selected date and time is unavailable, please select another one." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:actionOK];
            
            [self presentViewController:alert animated:YES completion:^{
                
            }];
            
        }
    }
    
}

@end
