//
//  RestaurantDetailsViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 4/20/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "RestaurantDetailsViewController.h"

@interface RestaurantDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelRestaurantAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelRestaurantOpeningHoursDays;

@end

@implementation RestaurantDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
- (IBAction)directionsWaze:(id)sender {
    
//    waze://?ll=37.331689,-122.030731&navigate=yes
    
// http://waze.to/?ll=latitude,longitude&navigate=yes
    
    NSString *parameters = @"?ll=37.331689,-122.030731&navigate=yes";
    NSURL *wazeURL = [NSURL URLWithString:[NSString  stringWithFormat:@"waze://%@",parameters]];
    
    if ([[UIApplication sharedApplication] canOpenURL:wazeURL]) {
        [[UIApplication sharedApplication] openURL:wazeURL];
    } else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please install the Waze App." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (IBAction)callRestaurant:(id)sender {
    NSString *phNo = @"+919876543210";
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Unable to establish call." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (IBAction)shareWithFriends:(id)sender {
}

@end
