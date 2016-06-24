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
@property (weak, nonatomic) IBOutlet UILabel *labelMainTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelText1;
@property (weak, nonatomic) IBOutlet UILabel *labelText2;
@property (weak, nonatomic) IBOutlet UILabel *labelThankYou;

@end

@implementation ReminderNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self.type isEqualToString:@"reminder"]) {
        if (self.reservationTimeTo && self.reservationTimeTo.length) {
            self.labelReservationNameTime.text = [NSString stringWithFormat:@"%@\n%@ - %@",_restaurantName, _reservationTimeFrom, _reservationTimeTo];
        }
        else {
            self.labelReservationNameTime.text = [NSString stringWithFormat:@"%@\n%@",_restaurantName, _reservationTimeFrom];
        }
        self.labelMainTitle.text = @"REMINDER !";
        self.labelText1.text = @"You have a reservation today at";
        self.labelText2.text = @"Please be there on time";
        self.labelThankYou.text = @"Thank You!";
    }
    else if ([self.type isEqualToString:@"notification"]) {
        
        self.labelMainTitle.text = self.title;
        self.labelText1.text = @"";
        self.labelReservationNameTime.text = self.bodyText;
        self.labelText2.text = @"";
        self.labelThankYou.text = @"";
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(removeFromSuperview)];
    [self.view addGestureRecognizer:tapGesture];
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
