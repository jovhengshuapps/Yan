//
//  ProfileTextFieldViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 17/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "ProfileTextFieldViewController.h"

@interface ProfileTextFieldViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ProfileTextFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.textField.placeholder = _currentValue;
    
    self.title = @"Settings";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showTitleBar:[NSString stringWithFormat:@"EDIT %@",_titleText]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveProfile:(id)sender {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfile:) name:@"updateProfileObserver" object:nil];
    
    NSString * fullname = @"";
    NSString * username = @"";
    if ([[_titleText lowercaseString] isEqualToString:@"fullname"]) {
        fullname = _textField.text;
    }
    else if ([[_titleText lowercaseString] isEqualToString:@"email"]) {
        username = _textField.text;
        
    }
    
    
    Account *account = (Account*)[self userLoggedIn];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/YYYY"];
    
    NSDate *formattedDate = [dateFormatter dateFromString:account.birthday];
    
    [self callAPI:API_USER_UPDATE_PROFILE withParameters:@{
                                                           @"user_email": username,
                                                           @"user_password": @"",
                                                           @"full_name": fullname,
                                                           @"birthday": [dateFormatter stringFromDate:formattedDate]
                                                           } completionNotification:@"updateProfileObserver"];
    
    
    
    
}

- (void) updateProfile:(NSNotification*)notification {
    if (_textField.text.length) {
        
        Account *account = (Account*)[self userLoggedIn];
        
        NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
        if ([[_titleText lowercaseString] isEqualToString:@"fullname"]) {
            account.fullname = _textField.text;
        }
        else if ([[_titleText lowercaseString] isEqualToString:@"email"]) {
            account.username = _textField.text;
            
        }
        
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
    
}
- (IBAction)cancelPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
