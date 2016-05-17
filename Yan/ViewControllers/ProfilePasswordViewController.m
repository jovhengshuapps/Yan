//
//  ProfilePasswordViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 17/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "ProfilePasswordViewController.h"

@interface ProfilePasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textFieldOldPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNewPassword;

@end

@implementation ProfilePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.title = @"Settings";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showTitleBar:@"EDIT PASSWORD"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveProfile:(id)sender {
    if ([_textFieldOldPassword.text isEqualToString:_currentPassword]) {
        
        if ([_textFieldOldPassword.text isEqualToString:_textFieldNewPassword.text]) {
            Account *account = (Account*)[self userLoggedIn];
            
            NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
            account.password = _textFieldNewPassword.text;
            
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
        else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Wrong Password" message:@"Old Password and New Password Field should be the same." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:actionOK];
            
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }
        
    }
    else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Wrong Password" message:@"Please input your current password on Old Password Field" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:actionOK];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
    
}
- (IBAction)cancelPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
