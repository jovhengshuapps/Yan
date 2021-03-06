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
@property (strong, nonatomic) NSMutableArray *arrayAvailableDays;
@property (strong, nonatomic) NSMutableArray *arrayAvailableTimes;
@property (strong, nonatomic) FPPopoverController *popover;
@property (weak, nonatomic) IBOutlet UITextView *textViewPolicy;
@property (weak, nonatomic) IBOutlet UIWebView *webViewPolicy;
@property (weak, nonatomic) IBOutlet UIButton *buttonPolicy;
@property (assign, nonatomic) BOOL policyLoaded;

@property (assign, nonatomic) BOOL policyAccepted;

@end

@implementation ReserveRestoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.policyAccepted = NO;
    self.policyLoaded = NO;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
    
    [button addTarget:self action:@selector(showRestaurantDetails) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *detailsItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [[self navigationItem] setRightBarButtonItem:detailsItem];

    [self addDoneToolbar:_textFieldNumberPerson];
    [self addDoneToolbar:_textFieldTableNumber];
    
//    Account *account = [self userLoggedIn];
    
    self.textFieldDate.placeholder = @"Loading Available Dates";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkReservationTimes:) name:@"checkReservationTimes" object:nil];
    [self callGETAPI:API_RESERVATION_CHECKTIME(self.restaurantDetails.identifier) withParameters:@{} completionNotification:@"checkReservationTimes"];
    
    self.textViewPolicy.text = self.restaurantDetails.policy;
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showTitleBar:@"RESERVATION"];
    self.title = self.restaurantDetails.name;
    
    self.policyLoaded = NO;
    
    if ([self.restaurantDetails.policy rangeOfString:@"http://"].location != NSNotFound) {
        self.textViewPolicy.hidden = YES;
        self.webViewPolicy.hidden = NO;
        [self.webViewPolicy loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.restaurantDetails.policy]]];
        
    }
    else {
        self.textViewPolicy.hidden = YES;
        self.webViewPolicy.hidden = NO;
        [self.webViewPolicy loadHTMLString:self.restaurantDetails.policy baseURL:nil];
        
    }
    
//    if ([self.restaurantDetails.policy rangeOfString:@"</p>"].location != NSNotFound || [self.restaurantDetails.policy rangeOfString:@"</div>"].location != NSNotFound || [self.restaurantDetails.policy rangeOfString:@"<br>"].location != NSNotFound || [self.restaurantDetails.policy rangeOfString:@"</br>"].location != NSNotFound) {
//        self.textViewPolicy.hidden = YES;
//        self.webViewPolicy.hidden = NO;
//        [self.webViewPolicy loadHTMLString:self.restaurantDetails.policy baseURL:nil];
//        
//    }
//    else if ([self.restaurantDetails.policy rangeOfString:@"http://"].location != NSNotFound) {
//        self.textViewPolicy.hidden = YES;
//        self.webViewPolicy.hidden = NO;
//        [self.webViewPolicy loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.restaurantDetails.policy]]];
//        
//    }
//    else {
//        self.textViewPolicy.hidden = NO;
//        self.webViewPolicy.hidden = YES;
//        
//        
//        self.policyLoaded = YES;
//    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) checkReservationTimes:(NSNotification*)notification {
//    NSLog(@"Available Times:%@",notification.object);
    
    self.textFieldDate.placeholder = @"DATE";
    NSArray *response = notification.object;
    self.arrayAvailableDays = [NSMutableArray array];
    self.arrayAvailableTimes = [NSMutableArray array];
    if (response.count) {
        for (NSDictionary *dates in response) {
            [self.arrayAvailableDays addObject:dates[@"day"]];
            [self.arrayAvailableTimes addObject:dates/*@{@"from":dates[@"from"],@"to":dates[@"to"]}*/];
        }
    }
}

- (void) completeReservation:(NSNotification*)notification {
    
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"reservationComplete"]){
        if (_textFieldDate.text.length && _textFieldTime.text.length && _textFieldTableNumber.text.length && _textFieldNumberPerson.text.length) {
            
            if (!self.policyAccepted) {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Restaurant Policy" message:@"Please accept the restaurant policy to continue with the reservation." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [alert dismissViewControllerAnimated:YES completion:nil];
                }];
                [alert addAction:actionOK];
                
                [self presentViewController:alert animated:YES completion:^{
                    
                }];
                
                return NO;
            }
            
            Account *account = (Account*)[self userLoggedIn];
            //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completeReservation:) name:@"reservationRequest" object:nil];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy"];
            NSDate *reserveDate = [dateFormatter dateFromString:[_textFieldDate.text componentsSeparatedByString:@" - "][1]];
//            NSLog(@"reserve:%@",[dateFormatter stringFromDate:reserveDate]);
            NSString *tableNumberParameter = (self.textFieldTableNumber.text.length)?self.textFieldTableNumber.text:@"X";
            NSDictionary *parameters = @{@"reserve_date":[dateFormatter stringFromDate:reserveDate],
                                         @"reserve_time":_textFieldTime.text,
                                         @"table":tableNumberParameter,
                                         @"persons":_textFieldNumberPerson.text
                                         };
            //        NSDictionary *parameters = @{@"reserve_date":@"05/23/2016",
            //                                     @"reserve_time":@"10:33 PM",
            //                                     @"table":@"9",
            //                                     @"persons":@"12"
            //                                     };
            self.buttonReserve.enabled = NO;
            [self.buttonReserve setTitle:@"SENDING RESERVATION" forState:UIControlStateNormal];
            [self callPOSTAPI:API_RESERVATION(_restaurantDetails.identifier, account.identifier) withParameters:parameters completionHandler:^(id  _Nullable response) {
                self.buttonReserve.enabled = YES;
                [self.buttonReserve setTitle:@"RESERVE" forState:UIControlStateNormal];
                [self performSegueWithIdentifier:@"reservationComplete" sender:sender];
            }];
        }
        else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Incomplete Details" message:@"All fields are required." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:actionOK];
            
            [self presentViewController:alert animated:YES completion:^{
                
            }];

        }
        return NO;
    }
    else if ([identifier isEqualToString:@"reserveDatePicker"]) {
        return YES;
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    [_textFieldTableNumber resignFirstResponder];
    [_textFieldNumberPerson resignFirstResponder];
    
    if ([segue.identifier isEqualToString:@"reserveDatePicker"]) {
//        DatePickerViewController *destNav = segue.destinationViewController;
//        destNav.delegate = self;
//        destNav.datePickerMode = UIDatePickerModeDate;
//        destNav.todayValidation = YES;
////        destNav.disabledDates = self.arrayDisabledDates;
//        
//        // This is the important part
//        UIPopoverPresentationController *popPC = destNav.popoverPresentationController;
//        popPC.delegate = self;
        
        
        
    }
    else if ([segue.identifier isEqualToString:@"reserveTimePicker"]) {
        DatePickerViewController *destNav = segue.destinationViewController;
        destNav.delegate = self;
        destNav.datePickerMode = UIDatePickerModeTime;
        
        destNav.todayValidation = YES;
        NSString *daySelected = [self.textFieldDate.text componentsSeparatedByString:@" - "][0];
//        NSLog(@"selected:%@",daySelected);
        for (NSDictionary *dateAndTimes in self.arrayAvailableTimes) {
            if ([daySelected isEqualToString:dateAndTimes[@"day"]]) {
                destNav.dateRange = @{@"from":dateAndTimes[@"from"], @"to":dateAndTimes[@"to"]};
                destNav.dateSelected = [self.textFieldDate.text componentsSeparatedByString:@" - "][1];
                break;
            }
        }
        
        
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
- (IBAction)showRestaurantPolicy:(id)sender {

//    if ([self.restaurantDetails.policy rangeOfString:@"</p>"].location != NSNotFound || [self.restaurantDetails.policy rangeOfString:@"</div>"].location != NSNotFound || [self.restaurantDetails.policy rangeOfString:@"<br>"].location != NSNotFound || [self.restaurantDetails.policy rangeOfString:@"</br>"].location != NSNotFound) {
        AlertView *alert = [[AlertView alloc] initAlertWithWebURL:self.restaurantDetails.policy delegate:self buttons:@[@"ACCEPT",@"DECLINE"]];

//    }
//    else {
//        AlertView *alert = [[AlertView alloc] initAlertWithMessage:self.restaurantDetails.policy delegate:self buttons:@[@"ACCEPT",@"DECLINE"]];
//        [alert showAlertView];
//    }
    
    
}

- (IBAction)selectDate:(id)sender {
    [self.textFieldDate resignFirstResponder];
    [self.textFieldTime resignFirstResponder];
    [self.textFieldTableNumber resignFirstResponder];
    [self.textFieldNumberPerson resignFirstResponder];
    
    DayTableViewController * dayPicker = (DayTableViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"dayPicker"];
    dayPicker.delegatePicker = self;
    dayPicker.availableDays = self.arrayAvailableDays;
    
    self.popover = [[FPPopoverController alloc] initWithViewController:dayPicker];
    
    self.popover.tint = FPPopoverRedTint;
    self.popover.border = YES;
    self.popover.delegate = self;
    self.popover.contentSize = CGSizeMake(300, 500);
    self.popover.arrowDirection = FPPopoverArrowDirectionUp;
    
    //sender is the UIButton view
    [self.popover presentPopoverFromView:sender];
}

- (void)selectedDay:(NSDictionary *)day {
    self.textFieldDate.text = [NSString stringWithFormat:@"%@ - %@",day[@"day"],day[@"date"]];
    self.textFieldTime.text = @"";
    [self.popover dismissPopoverAnimated:YES];
}


- (void)alertView:(AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.policyLoaded = YES;
    if (buttonIndex == 0) {
        [self.buttonPolicy setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        self.policyAccepted = YES;
    }
    else {
        [self.buttonPolicy setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        self.policyAccepted = NO;
    }
    
    [alertView dismissAlertView];
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"start");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"finish");
    self.policyLoaded = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"error:%@",[error description]);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

@end
