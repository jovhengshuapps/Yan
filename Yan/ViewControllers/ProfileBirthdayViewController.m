//
//  ProfileBirthdayViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 17/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "ProfileBirthdayViewController.h"

@interface ProfileBirthdayViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textFieldBirthday;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation ProfileBirthdayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-1];
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.maximumDate = maxDate;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *birthdate = [NSDate date];
    if (_birthday.length) {
        birthdate = [dateFormatter dateFromString:_birthday];
    }
    
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    self.textFieldBirthday.text = [dateFormatter stringFromDate:birthdate];
    
    [_datePicker setDate:birthdate animated:YES];
    
    self.title = @"Settings";
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showTitleBar:@"EDIT BIRTHDAY"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changeDate:(id)sender {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, YYYY"];
    
    self.textFieldBirthday.text = [dateFormatter stringFromDate:_datePicker.date];
}
- (IBAction)saveProfile:(id)sender {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfile:) name:@"updateProfileObserver" object:nil];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/YYYY"];
    
    //    NSLog(@"formattedDate:%@",[dateFormatter stringFromDate:formattedDate]);
    [self callAPI:API_USER_UPDATE_PROFILE withParameters:@{
                                                     @"user_email": @"",
                                                     @"user_password": @"",
                                                     @"full_name": @"",
                                                     @"birthday": [dateFormatter stringFromDate:self.datePicker.date]
                                                     } completionNotification:@"updateProfileObserver"];
    
    
    
    
}

- (void) updateProfile:(NSNotification*)notification {
    
    Account *account = (Account*)[self userLoggedIn];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/YYYY"];
    
    NSString *selectedBirthday = [dateFormatter stringFromDate:_datePicker.date];
    
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    account.birthday = selectedBirthday;
    
    NSError *error = nil;
    if (![context save:&error]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Error Saving Profile [%li]",(long)[error code]] message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:actionOK];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
    else {
        
        
        
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}



- (IBAction)cancelPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
