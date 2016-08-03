//
//  ReserveCompleteViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 4/19/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "ReserveCompleteViewController.h"

@interface ReserveCompleteViewController ()
@property (weak, nonatomic) IBOutlet UILabel *NotificationText;

@end

@implementation ReserveCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    [button setFrame:CGRectMake(0.0f, 0.0f, 45.0f, 30.0f)];
//    
//    [button setImage:[UIImage imageNamed:@"waiter-icon-normal"] forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamed:@"waiter-icon-highlighted"] forState:UIControlStateHighlighted];
//        
//    [button addTarget:self action:@selector(showWaiterView) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *waiterItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    [[self navigationItem] setRightBarButtonItem:waiterItem];
    
    
    // Original Text: You will receive a notification a day before your reservation as a reminder.
    
    
    self.NotificationText.text = @"A Restaurant representative will get back to you on your request.";
    
    
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    Account *account = [self userLoggedIn];
    NSString *recentRestaurants = account.recent_restaurant;
    account.recent_restaurant = [NSString stringWithFormat:@"%@,%@",recentRestaurants, self.restaurantID];
    
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
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showTitleBar:@"CONFIRMATION"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)closeButton:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) showWaiterView {
    
}

@end
