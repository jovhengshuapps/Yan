//
//  ReminderNotificationViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 09/06/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "ReminderNotificationViewController.h"
#import <EventKit/EventKit.h>

@interface ReminderNotificationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelReservationNameTime;
@property (weak, nonatomic) IBOutlet UILabel *labelMainTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelText1;
@property (weak, nonatomic) IBOutlet UILabel *labelText2;
@property (weak, nonatomic) IBOutlet UILabel *labelThankYou;

@property (strong, nonatomic) EKEventStore *eventStore;
@property (nonatomic) BOOL isAccessToEventStoreGranted;
@property (strong, nonatomic) EKCalendar *calendar;
@property (weak, nonatomic) IBOutlet CustomButton *buttonClose;

@end

@implementation ReminderNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self.type isEqualToString:@"reminder"]) {
        if (self.reservationTimeTo && self.reservationTimeTo.length) {
            self.labelReservationNameTime.text = [NSString stringWithFormat:@"%@\n%@ - %@",_restaurantName, _reservationTimeFrom, _reservationTimeTo];
        }
        else {
            self.labelReservationNameTime.text = [NSString stringWithFormat:@"%@\n%@",_restaurantName, _reservationTimeFrom];
        }
        self.labelMainTitle.text = @"REMINDER !";
        self.labelText1.text = @"You have a reservation today at";
        self.labelText2.text = @"Please be there on time";
        self.labelThankYou.text = @"Thank You!";
    }
    else if ([self.type isEqualToString:@"notification"]) {
        
        self.labelMainTitle.text = self.notificationTitle;
        self.labelText1.text = @"";
        self.labelReservationNameTime.text = self.bodyText;
        self.labelText2.text = @"";
        self.labelThankYou.text = @"";
        
        if (self.notificationTitle && [self.notificationTitle rangeOfString:@"Accepted"].location != NSNotFound) {
            
            [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                // handle access here
                //            [self updateAuthorizationStatusToAccessEventStore];
                
                if(!granted) {
                    self.isAccessToEventStoreGranted = NO;
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Access Denied"
                                                                        message:@"This app doesn't have access to your Reminders." delegate:nil
                                                              cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                    [alertView show];
                }
                else {
                    self.isAccessToEventStoreGranted = YES;
                }
                
            }];
            
        }
    }
    
    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeButton:)];
//    [self.buttonClose addGestureRecognizer:tapGesture];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeButton:(id)sender {
    //not called.
    
    if (self.notificationTitle && [self.notificationTitle rangeOfString:@"Accepted"].location != NSNotFound) {
        if (!self.isAccessToEventStoreGranted)
            return;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *twelveHourLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.locale = twelveHourLocale;
        [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
        NSString *message = [NSString stringWithFormat:@"Reservation at %@ for %@.\n%@\n\nDetails:\nAddress:%@\nContacts:%@\nOperation Hours:%@",self.restaurantName,self.numberOfPerson,[dateFormatter stringFromDate:self.reservationDateTime],self.restaurantAddress,self.restaurantContact,self.restaurantOperation];
//        AlertView *alert = [[AlertView alloc] initAlertWithMessage:message delegate:self buttons:nil];        
//        [alert showAlertView];
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Would you like to save the date on your calendar?" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionYES = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            EKEvent *event = [EKEvent eventWithEventStore:self.eventStore];
            event.title = [NSString stringWithFormat:@"%@ Reservation for %@",self.restaurantName, self.numberOfPerson];
            event.startDate = self.reservationDateTime;
            event.endDate = [event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
            event.calendar = [self.eventStore defaultCalendarForNewEvents];
            event.notes = [NSString stringWithFormat:@"Restaurant Details:\nAddress:%@\nContacts:%@\nOperation Hours:%@",self.restaurantAddress,self.restaurantContact,self.restaurantOperation];
            NSTimeInterval aInterval = -1 * 60 * 60;
            EKAlarm *alaram = [EKAlarm alarmWithRelativeOffset:aInterval];
            [event addAlarm:alaram];

            NSError *err = nil;
            BOOL success = [self.eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
            
            
//            switch (evetReminder) {   //set alaram for 5mins, 15mins ,20mins etc
//                case 0:
//                    self.selectedAlertSetting = @"None";
//                    break;
//                    
//                case 1:
//                {
//                    EKAlarm *alaram = [[EKAlarm alloc]init];
//                    [alaram setAbsoluteDate:eventStartDate];
//                    [event addAlarm:alaram];
//                    [alaram release];
//                    break;
//                }
//                    
//                    
//                case 2:
//                {
//                    NSTimeInterval aInterval = -5 *60;
//                    EKAlarm *alaram = [EKAlarm alarmWithRelativeOffset:aInterval];
//                    [event addAlarm:alaram];
//                    break;
//                }
//                case 3:
//                {
//                    NSTimeInterval aInterval = -15 * 60;
//                    EKAlarm *alaram = [EKAlarm alarmWithRelativeOffset:aInterval];
//                    [event addAlarm:alaram];
//                    break;
//                }
//                case 4:
//                {
//                    NSTimeInterval aInterval = -30 * 60;
//                    EKAlarm *alaram = [EKAlarm alarmWithRelativeOffset:aInterval];
//                    [event addAlarm:alaram];
//                    break;
//                }
//                case 5:
//                {
//                    NSTimeInterval aInterval = -1 * 60 * 60;
//                    EKAlarm *alaram = [EKAlarm alarmWithRelativeOffset:aInterval];
//                    [event addAlarm:alaram];
//                    break;
//                }
//                case 6:
//                {
//                    NSTimeInterval aInterval = -2 * 60 * 60;
//                    EKAlarm *alaram = [EKAlarm alarmWithRelativeOffset:aInterval];
//                    [event addAlarm:alaram];
//                    break;
//                }
//                    
//                case 7:
//                {
//                    NSTimeInterval aInterval = -1 * 24 * 60 * 60;
//                    EKAlarm *alaram = [EKAlarm alarmWithRelativeOffset:aInterval];
//                    [event addAlarm:alaram];
//                    break;
//                }
//                case 8:
//                {
//                    NSTimeInterval aInterval = -2 * 24 * 60 * 60;
//                    EKAlarm *alaram = [EKAlarm alarmWithRelativeOffset:aInterval];
//                    [event addAlarm:alaram];
//                    break;
//                }
//                default:
//                    break;
            
            
            
            //        EKReminder *reminder = [EKReminder reminderWithEventStore:self.eventStore];
            //        reminder.title = @"Yan! App Reminder!";
            //        reminder.calendar = self.calendar;
            //        reminder.startDateComponents = self.reservationDateTime;
            //
            //        NSError *error = nil;
            //        BOOL success = [self.eventStore saveReminder:reminder commit:YES error:&error];
            //        if (!success) {
            //            // Handle error.
            //        }
            
            NSString *message = (success) ? @"Event was successfully added!" : [NSString stringWithFormat:@"Failed to add Calendar Event!\n\n%@",[err description]];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
            [alertView show];
        }];
        [alert addAction:actionYES];
        UIAlertAction *actionNO = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:actionNO];
        [self presentViewController:alert animated:YES completion:^{
            NSLog(@"ALERT CONTROLLER PRESENTED");
        }];

        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Would you like to save the date on your calendar?"
//                                                            message:message delegate:self
//                                                  cancelButtonTitle:@"NO" otherButtonTitles:@"YES"];
//        [alertView show];
        
    }
    [self.view removeFromSuperview];
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        EKEvent *event = [EKEvent eventWithEventStore:self.eventStore];
        event.title = [NSString stringWithFormat:@"%@ Reservation for %@",self.restaurantName, self.numberOfPerson];
        event.startDate = self.reservationDateTime;
        event.endDate = [event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
        event.calendar = [self.eventStore defaultCalendarForNewEvents];
        event.notes = [NSString stringWithFormat:@"Restaurant Details:\nAddress:%@\nContacts:%@\nOperation Hours:%@",self.restaurantAddress,self.restaurantContact,self.restaurantOperation];
        NSError *err = nil;
        BOOL success = [self.eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        
        //        EKReminder *reminder = [EKReminder reminderWithEventStore:self.eventStore];
        //        reminder.title = @"Yan! App Reminder!";
        //        reminder.calendar = self.calendar;
        //        reminder.startDateComponents = self.reservationDateTime;
        //
        //        NSError *error = nil;
        //        BOOL success = [self.eventStore saveReminder:reminder commit:YES error:&error];
        //        if (!success) {
        //            // Handle error.
        //        }
        
        NSString *message = (success) ? @"Event was successfully added!" : [NSString stringWithFormat:@"Failed to add Calendar Event!\n\n%@",[err description]];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
        [alertView show];
    }
}

//- (void)alertView:(AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 0) {
//        
//        EKEvent *event = [EKEvent eventWithEventStore:self.eventStore];
//        event.title = [NSString stringWithFormat:@"%@ Reservation for %@",self.restaurantName, self.numberOfPerson];
//        event.startDate = self.reservationDateTime;
//        event.endDate = [event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
//        event.calendar = [self.eventStore defaultCalendarForNewEvents];
//        event.notes = [NSString stringWithFormat:@"Restaurant Details:\nAddress:%@\nContacts:%@\nOperation Hours:%@",self.restaurantAddress,self.restaurantContact,self.restaurantOperation];
//        NSError *err = nil;
//        BOOL success = [self.eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
//        
//        //        EKReminder *reminder = [EKReminder reminderWithEventStore:self.eventStore];
//        //        reminder.title = @"Yan! App Reminder!";
//        //        reminder.calendar = self.calendar;
//        //        reminder.startDateComponents = self.reservationDateTime;
//        //
//        //        NSError *error = nil;
//        //        BOOL success = [self.eventStore saveReminder:reminder commit:YES error:&error];
//        //        if (!success) {
//        //            // Handle error.
//        //        }
//        
//        NSString *message = (success) ? @"Event was successfully added!" : [NSString stringWithFormat:@"Failed to add Calendar Event!\n\n%@",[err description]];
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
//        [alertView show];
//    }
//}

- (EKEventStore *)eventStore {
    if (!_eventStore) {
        _eventStore = [[EKEventStore alloc] init];
    }
    return _eventStore;
}

- (EKCalendar *)calendar {
    if (!_calendar) {
        NSArray *calendars = [self.eventStore calendarsForEntityType:EKEntityTypeEvent];
        
        NSString *calendarTitle = @"Yan! Reservation!";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title matches %@", calendarTitle];
        NSArray *filtered = [calendars filteredArrayUsingPredicate:predicate];
        
        if ([filtered count]) {
            _calendar = [filtered firstObject];
        } else {
            
            // 3
            _calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:self.eventStore];
            _calendar.title = @"Yan! Reservation!";
            _calendar.source = self.eventStore.defaultCalendarForNewEvents.source;
            
            // 4
            NSError *calendarErr = nil;
            BOOL calendarSuccess = [self.eventStore saveCalendar:_calendar commit:YES error:&calendarErr];
            if (!calendarSuccess) {
                // Handle error
            }
        }
    }
    return _calendar;
}

- (void)updateAuthorizationStatusToAccessEventStore {
    EKAuthorizationStatus authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    
    switch (authorizationStatus) {
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted: {
            self.isAccessToEventStoreGranted = NO;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Access Denied"
                                                                message:@"This app doesn't have access to your Reminders." delegate:nil
                                                      cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alertView show];
            
            
            break;
        }
            
            // 4
        case EKAuthorizationStatusAuthorized:
            self.isAccessToEventStoreGranted = YES;
            
            break;
            
            // 5
        case EKAuthorizationStatusNotDetermined: {
            __weak ReminderNotificationViewController *weakSelf = self;
            [self.eventStore requestAccessToEntityType:EKEntityTypeEvent
                                            completion:^(BOOL granted, NSError *error) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    weakSelf.isAccessToEventStoreGranted = granted;
                                                    
                                                });
                                            }];
            break;
        }
    }
}

@end
