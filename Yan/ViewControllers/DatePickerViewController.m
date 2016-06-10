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
//        [comps setDay:1];
        [comps setHour:1];
        NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        
        [_datePicker setMinimumDate:minDate];
    }
    
    if (_dateRange) {
        NSString *from = _dateRange[@"from"];
        NSString *to = _dateRange[@"to"];
        
        NSInteger startHour = [self hourFromString:from];
        NSInteger endHour = [self hourFromString:to];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *currentDate = [NSDate date];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        //        [comps setDay:1];
        
        NSInteger currentHour = [calendar component:NSCalendarUnitHour fromDate:currentDate];
//        if (minHour > currentHour) {
//            [comps setHour: (currentHour - minHour)];
//        }
//        
//        NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
//       
//        
//        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//        comps = [[NSDateComponents alloc] init];
//        if (maxHour < currentHour) {
//            [comps setHour: (maxHour - currentHour)];
//        }
//        else {
//            [comps setHour: (currentHour - maxHour)];
//        }
//        NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
//        self.datePicker.minimumDate = minDate;
//        self.datePicker.maximumDate = maxDate;
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorian components: NSCalendarUnitHour fromDate: currentDate];
        if (startHour < currentHour) {
            [components setHour:currentHour];
        }
        else {
            [components setHour: startHour];
        }
        [components setMinute: 0];
        [components setSecond: 0];
        NSDate *startDate = [gregorian dateFromComponents: components];
        
        
        [components setHour: endHour];
        [components setMinute: 0];
        [components setSecond: 0];
        NSDate *endDate = [gregorian dateFromComponents: components];
//        NSLog(@"s:%@ e:%@",startDate,endDate);
        [self.datePicker setDatePickerMode:UIDatePickerModeTime];
        [self.datePicker setMinimumDate:startDate];
        [self.datePicker setMaximumDate:endDate];
        [self.datePicker setDate:startDate animated:YES];
        [self.datePicker reloadInputViews];
    }
}

- (NSInteger) hourFromString:(NSString*)string {
    if ([string rangeOfString:@"AM"].location != NSNotFound) {
        return [[string componentsSeparatedByString:@":"][0] integerValue];
    }
    else if ([string rangeOfString:@"PM"].location != NSNotFound) {
        return [[string componentsSeparatedByString:@":"][0] integerValue] + 12;
    }
    return 0;
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

@end
