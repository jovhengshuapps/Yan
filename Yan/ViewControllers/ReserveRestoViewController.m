//
//  ReserveRestoViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 4/19/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "ReserveRestoViewController.h"
#import "RestaurantDetailsViewController.h"
#import "ReserveCompleteViewController.h"

@interface ReserveRestoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textFieldDate;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTime;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNumberPerson;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTableNumber;
@property (weak, nonatomic) IBOutlet CustomButton *buttonReserve;
@property (strong, nonatomic) NSMutableArray *arrayDisabledDates;

@end

@implementation ReserveRestoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
    
    [button addTarget:self action:@selector(showRestaurantDetails) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *detailsItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [[self navigationItem] setRightBarButtonItem:detailsItem];

    [self addDoneToolbar:_textFieldNumberPerson];
    [self addDoneToolbar:_textFieldTableNumber];
    
//    Account *account = [self userLoggedIn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkReservationTimes:) name:@"checkReservationTimes" object:nil];
    [self callGETAPI:API_RESERVATION_CHECKTIME(self.restaurantDetails.identifier) withParameters:@{} completionNotification:@"checkReservationTimes"];
    

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showTitleBar:@"RESERVATION"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) checkReservationTimes:(NSNotification*)notification {
    NSLog(@"Available Times:%@",notification.object);
}

- (void) completeReservation:(NSNotification*)notification {
    
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"reservationComplete"]){
        Account *account = (Account*)[self userLoggedIn];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completeReservation:) name:@"reservationRequest" object:nil];
        NSDictionary *parameters = @{@"reserve_date":_textFieldDate.text,
                                     @"reserve_time":_textFieldTime.text,
                                     @"table":_textFieldTableNumber.text,
                                     @"persons":_textFieldNumberPerson.text
                                     };
//        NSDictionary *parameters = @{@"reserve_date":@"05/23/2016",
//                                     @"reserve_time":@"10:33 PM",
//                                     @"table":@"9",
//                                     @"persons":@"12"
//                                     };
        self.buttonReserve.enabled = NO;
        [self.buttonReserve setTitle:@"Sending Reservation" forState:UIControlStateNormal];
        [self callPOSTAPI:API_RESERVATION(_restaurantDetails.identifier, account.identifier) withParameters:parameters completionHandler:^(id  _Nullable response) {
            self.buttonReserve.enabled = YES;
            [self.buttonReserve setTitle:@"RESERVE" forState:UIControlStateNormal];
            [self performSegueWithIdentifier:@"reservationComplete" sender:sender];
        }];
        return NO;
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    [_textFieldTableNumber resignFirstResponder];
    [_textFieldNumberPerson resignFirstResponder];
    
    if ([segue.identifier isEqualToString:@"reserveDatePicker"]) {
        DatePickerViewController *destNav = segue.destinationViewController;
        destNav.delegate = self;
        destNav.datePickerMode = UIDatePickerModeDate;
        destNav.todayValidation = YES;
        destNav.disabledDates = self.arrayDisabledDates;
        
        // This is the important part
        UIPopoverPresentationController *popPC = destNav.popoverPresentationController;
        popPC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"reserveTimePicker"]) {
        DatePickerViewController *destNav = segue.destinationViewController;
        destNav.delegate = self;
        destNav.datePickerMode = UIDatePickerModeTime;
        destNav.todayValidation = YES;
        destNav.disabledDates = self.arrayDisabledDates;
        
        // This is the important part
        UIPopoverPresentationController *popPC = destNav.popoverPresentationController;
        popPC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"reservationComplete"]) {
        ReserveCompleteViewController *destNav = segue.destinationViewController;
        destNav.restaurantID = self.restaurantDetails.identifier;
    }
    
}
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

-(void)dateSelected:(NSString*)dateString mode:(UIDatePickerMode)mode {
    if (mode == UIDatePickerModeDate) {
        self.textFieldDate.text = dateString;
    }
    else if (mode == UIDatePickerModeTime) {
        self.textFieldTime.text = dateString;
    }
}

- (void) showRestaurantDetails {
    
    RestaurantDetailsViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"restaurantDetails"];
    details.restaurantDetails = _restaurantDetails;
    details.reservedTableNumber = _textFieldTableNumber.text;
    [self.navigationController pushViewController:details animated:YES];
}



@end
