//
//  QRReaderViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 01/06/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "QRReaderViewController.h"
#import "QRCodeReaderViewController.h"
#import "QRCodeReader.h"

@interface QRReaderViewController ()
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButtonItem;
@property (weak, nonatomic) IBOutlet UIView *viewCamera;
@property (weak, nonatomic) IBOutlet UILabel *labelInstruction;
@property (weak, nonatomic) IBOutlet UIButton *buttonContinue;

@property (strong, nonatomic) NSString *restaurantID;
@property (strong, nonatomic) NSString *restaurantName;
@property (strong, nonatomic) NSString *tableNumber;

@end

@implementation QRReaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.labelInstruction.text = @"* The Restaurant logo should be somewhere nearby.";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showTitleBar:@"SCAN LOGO"];
    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
        static QRCodeReaderViewController *vc = nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
            vc                   = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cance" codeReader:reader startScanningAtLoad:NO showSwitchCameraButton:YES showTorchButton:YES];
            vc.modalPresentationStyle = UIModalPresentationFormSheet;
        });
        vc.delegate = self;
        
//        [vc setCompletionWithBlock:^(NSString *resultAsString) {
//            NSLog(@"Completion with result: %@", resultAsString);
//        }];
        
//        [self presentViewController:vc animated:YES completion:NULL];
        
        vc.view.frame = self.viewCamera.bounds;
        [self.viewCamera addSubview:vc.view];
        [self addChildViewController:vc];
        [vc didMoveToParentViewController:self];
        
        [vc startScanning];
    }
    else {
        self.restaurantID = @"5";
        self.restaurantName = @"Artsy Cafe";
        self.tableNumber = @"1";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Reader not supported by the current device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonPressed:(id)sender {
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.3;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromLeft;
//    [self.view.window.layer addAnimation:transition forKey:nil];
    
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}
- (IBAction)buttonContinuePressed:(id)sender {
    
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    Account *loggedUSER = [self userLoggedIn];
    loggedUSER.current_restaurantID = self.restaurantID;
    loggedUSER.current_tableNumber = self.tableNumber;
    loggedUSER.current_restaurantName = self.restaurantName;
    
    NSError *error = nil;
    if (![context save:&error]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Error %li",(long)[error code]] message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:actionOK];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    
}


#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    NSArray *components = [result componentsSeparatedByString:@"|"];
    NSString *crestaurantID = components[0];
    NSString *crestaurantName = components[1];
    NSString *ctableNumber = components[components.count-1];
    self.labelInstruction.text = [NSString stringWithFormat:@"Are you in %@, Table %@?",crestaurantName,ctableNumber];
    
    self.restaurantID = crestaurantID;
    self.restaurantName = crestaurantName;
    self.tableNumber = ctableNumber;
    
    
//    [self dismissViewControllerAnimated:YES completion:^{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QRCodeReader" message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
//    [self dismissViewControllerAnimated:YES completion:NULL];
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