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
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *buttonPrivacy;
@property (weak, nonatomic) IBOutlet UIButton *buttonTerms;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addDoneToolbar:_textFieldName];
    [self addDoneToolbar:_textFieldEmail];
    [self addDoneToolbar:_textFieldPassword];
    
    self.buttonPrivacy.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.buttonTerms.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.buttonPrivacy.titleLabel.minimumScaleFactor = -5.0f;
    self.buttonTerms.titleLabel.minimumScaleFactor = -5.0f;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://mavenhive.net/privacy-policy.html"]]];
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
    
//    AlertView *alert = [[AlertView alloc] initVideoAd:@"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4" delegate:self];
//    alert.tag = 1;
//    [alert showAlertView];
    if (self.textFieldName.text.length /*&& self.textFieldBirthday.text.length*/ && self.textFieldEmail.text.length && self.textFieldPassword.text.length) {
//        
//        NSURL *url = [[NSBundle mainBundle] URLForResource:@"apple" withExtension:@"mp4"];
//        AlertView *alert = [[AlertView alloc] initVideoAd:url delegate:self];
//        alert.tag = 1;
//        [alert showAlertView];

        self.view.userInteractionEnabled = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerCompletedMethod:) name:@"registerCompletedObserver" object:nil];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/YYYY"];
        NSString *bday = self.textFieldBirthday.text;
        if (self.textFieldBirthday.text.length < 1) {
            bday = @"01/01/1970";
        }
        NSDate *formattedDate = [dateFormatter dateFromString:bday];
        //    NSLog(@"formattedDate:%@",[dateFormatter stringFromDate:formattedDate]);
        [self callAPI:API_USER_REGISTER withParameters:@{
                                                         @"user_email": self.textFieldEmail.text,
                                                         @"user_password": self.textFieldPassword.text,
                                                         @"full_name": self.textFieldName.text,
                                                         @"birthday": [dateFormatter stringFromDate:formattedDate]
                                                         } completionNotification:@"registerCompletedObserver"];
        
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Incomplete Details" message:@"Please complete all information" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:actionOK];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
    
}

- (void)registerCompletedMethod:(NSNotification*)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification.name object:nil];
    id response = notification.object;
    self.view.userInteractionEnabled = YES;
    if ([response isKindOfClass:[NSError class]] || ([response isKindOfClass:[NSDictionary class]] && [[response allKeys] containsObject:@"error"])) {
        
        [self showTitleBar:@"REGISTRATION"];
        return;
    }
    if ([self saveLoggedInAccount:self.textFieldEmail.text :self.textFieldPassword.text :self.textFieldName.text :self.textFieldBirthday.text :response[@"token"] :response[@"uid"]]) {
        
//        
//        NSURL *url = [[NSBundle mainBundle] URLForResource:@"apple" withExtension:@"mp4"];
//        AlertView *alert = [[AlertView alloc] initVideoAd:url delegate:self];
//        alert.tag = 1;
//        [alert showAlertView];
//
        [[NSNotificationCenter defaultCenter] postNotificationName:ChangeHomeViewToShow object:@"HomeViewRegistrationComplete"];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
    }
}

- (void)alertView:(AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}

- (void)alertViewDismissed:(AlertView *)alertView {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerCompletedMethod:) name:@"registerCompletedObserver" object:nil];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"MM/dd/YYYY"];
//    NSDate *formattedDate = [dateFormatter dateFromString:self.textFieldBirthday.text];
//    //    NSLog(@"formattedDate:%@",[dateFormatter stringFromDate:formattedDate]);
//    [self callAPI:API_USER_REGISTER withParameters:@{
//                                                     @"user_email": self.textFieldEmail.text,
//                                                     @"user_password": self.textFieldPassword.text,
//                                                     @"full_name": self.textFieldName.text,
//                                                     @"birthday": [dateFormatter stringFromDate:formattedDate]
//                                                     } completionNotification:@"registerCompletedObserver"];
    
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:ChangeHomeViewToShow object:@"HomeViewRegistrationComplete"];
//    
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)videoAdPlayer:(AlertView *)alertView{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerCompletedMethod:) name:@"registerCompletedObserver" object:nil];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"MM/dd/YYYY"];
//    NSDate *formattedDate = [dateFormatter dateFromString:self.textFieldBirthday.text];
////    NSLog(@"formattedDate:%@",[dateFormatter stringFromDate:formattedDate]);
//    [self callAPI:API_USER_REGISTER withParameters:@{
//                                                     @"user_email": self.textFieldEmail.text,
//                                                     @"user_password": self.textFieldPassword.text,
//                                                     @"full_name": self.textFieldName.text,
//                                                     @"birthday": [dateFormatter stringFromDate:formattedDate]
//                                                     } completionNotification:@"registerCompletedObserver"];
//    [alertView dismissAlertView];
}

//- (void)imageGIFEnded:(AlertView *)alertView {
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerCompletedMethod:) name:@"registerCompletedObserver" object:nil];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"MM/dd/YYYY"];
//    NSDate *formattedDate = [dateFormatter dateFromString:[self.textFieldBirthday.text substringToIndex:[self.textFieldBirthday.text rangeOfString:@","].location-1]];
//    NSLog(@"formattedDate:%@",[dateFormatter stringFromDate:formattedDate]);
//    [self callAPI:API_USER_REGISTER withParameters:@{
//                                                     @"user_email": self.textFieldEmail.text,
//                                                     @"user_password": self.textFieldPassword.text,
//                                                     @"full_name": self.textFieldName.text,
//                                                     @"birthday": [dateFormatter stringFromDate:formattedDate]
//                                                     } completionNotification:@"registerCompletedObserver"];
//    [alertView dismissAlertView];
//}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [_textFieldName resignFirstResponder];
    [_textFieldEmail resignFirstResponder];
    [_textFieldPassword resignFirstResponder];
    if ([segue.identifier isEqualToString:@"registerDatePicker"]) {
        DatePickerViewController *destNav = segue.destinationViewController;
        destNav.delegate = self;
        destNav.datePickerMode = UIDatePickerModeDate;
        destNav.birthdayValidation = YES;
        
        // This is the important part
        UIPopoverPresentationController *popPC = destNav.popoverPresentationController;
        popPC.delegate = self;
    }
}
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

-(void)dateSelected:(NSString*)dateString mode:(UIDatePickerMode)mode {
    if (mode == UIDatePickerModeDate) {
        self.textFieldBirthday.text = dateString;
    }
}
- (IBAction)loadWebViewFromSelected:(id)sender {
    [self.webView stopLoading];
    if (sender == self.buttonPrivacy) {
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://mavenhive.net/privacy-policy.html"]]];
    }
    else {
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://mavenhive.net/yan/terms-conditions.html"]]];
    }
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.webView.bounds.size.width, self.webView.bounds.size.height)];
    view.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
    view.tag = 1199;
    UIActivityIndicatorView *av = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [view addSubview:av];
    [av startAnimating];
    
    [self.webView addSubview:view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[self.webView viewWithTag:1199] removeFromSuperview];
}
@end
