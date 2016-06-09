//
//  ReminderNotificationViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 09/06/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "ReminderNotificationViewController.h"

@interface ReminderNotificationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelReservationNameTime;

@end

@implementation ReminderNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.reservationTimeTo.length) {
        self.labelReservationNameTime.text = [NSString stringWithFormat:@"%@\n\n%@ - %@",_restaurantName, _reservationTimeFrom, _reservationTimeTo];
    }
    else {
        self.labelReservationNameTime.text = [NSString stringWithFormat:@"%@\n\n%@",_restaurantName, _reservationTimeFrom];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeButton:(id)sender {
    [self.view removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
