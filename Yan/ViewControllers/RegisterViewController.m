//
//  RegisterViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 4/7/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "RegisterViewController.h"
#import "HomeViewController.h"

@interface RegisterViewController()
@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldBirthday;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showTitleBar:@"REGISTRATION"];
}

- (IBAction)viewTermsOfUse:(id)sender {
    
    AlertView *alert = [[AlertView alloc] initAlertWithMessage:@"SampleSource Incorporated welcomes Canadian visitors and SampleSource USA Incorporated welcomes US visitors to the SampleSource website located at www.samplesource.com and www.samplesource.ca (the \"Website\"). SampleSource Incorporated and SampleSource USA Incorporated are collectively referred to as (\"SampleSource\", \"we\", \"us\", \"our\"). Please read the following Website terms of use (\"Terms of Use\") before using the Website. By accessing and using the Website, you agree to be bound by all the Terms of Use set forth herein. If you do not agree with these Terms of Use, your sole recourse is to leave the Website immediately. A copy of these Terms of Use may be downloaded, saved and printed for your reference.\n\nThe Website is owned and operated by SampleSource. Any and all content, data, graphics, photographs, images, audio, video, software, systems, processes, trademarks, service marks, trade names and other information including, without limitation, the \"look and feel\" of the Website (collectively, the \"Content\") contained in this Website are proprietary to SampleSource, its affiliates and/or third-party licensors. The Content is protected by Canadian, United States and international copyright and trademark laws.\n\n Except as set forth herein, you may not modify, copy, reproduce, publish, post, transmit, distribute, display, perform, create derivative works from, transfer or sell any Content without the express prior written consent of SampleSource. You may download, print and reproduce the Content for your own non-commercial, informational purposes provided you agree to maintain any and all copyright or other proprietary notices contained in such Content, and to cite the URL Source of such Content. Reproduction of multiple copies of the Content, in whole or in part, for resale or distribution is strictly prohibited except with the prior written permission of SampleSource. To obtain written consent for such reproduction, please contact us at info@samplesource.com" delegate:self buttons:nil];
    [alert showAlertView];
}
- (IBAction)completeRegistration:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerCompletedMethod:) name:@"registerCompletedObserver" object:nil];
    [self callAPI:API_USER_REGISTER withParameters:@{
                                                     @"user_email": self.textFieldEmail.text,
                                                     @"user_password": self.textFieldPassword.text,
                                                     @"full_name": self.textFieldName.text,
                                                     @"birthday": self.textFieldBirthday.text
                                                     } completionNotification:@"registerCompletedObserver"];
    
    
}

- (void)registerCompletedMethod:(NSNotification*)notification {
    id response = notification.object;
    if ([self saveLoggedInAccount:self.textFieldEmail.text :self.textFieldPassword.text :self.textFieldName.text :self.textFieldBirthday.text :response[@"token"]]) {
        
        AlertView *alert = [[AlertView alloc] initVideoAd:@"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4" delegate:self];
        alert.tag = 1;
        [alert showAlertView];
    }
}

- (void)alertView:(AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
        [notification postNotificationName:ChangeHomeViewToShow object:@"HomeViewRegistrationComplete"];
    }
}

- (void)alertViewDismissed:(AlertView *)alertView {
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification postNotificationName:ChangeHomeViewToShow object:@"HomeViewRegistrationComplete"];
}

- (void)videoAdPlayer:(AVPlayer *)player controller:(AVPlayerViewController *)controller {
    
}
@end
