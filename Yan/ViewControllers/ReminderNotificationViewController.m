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
    [self.view removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

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
