//
//  RestaurantDetailsViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 4/20/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "RestaurantDetailsViewController.h"
#import "ShareTableViewController.h"

@interface RestaurantDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelRestaurantAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelRestaurantOpeningHoursDays;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation RestaurantDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.labelRestaurantAddress.text = _restaurantDetails.location;
    self.labelRestaurantOpeningHoursDays.text = _restaurantDetails.operating;
    if ([_restaurantDetails.latitude doubleValue] != 0 && [_restaurantDetails.longitude doubleValue] != 0) {
        
        self.mapView.hidden = NO;
        CLLocationCoordinate2D restaurantLocation = CLLocationCoordinate2DMake([_restaurantDetails.latitude doubleValue], [_restaurantDetails.longitude doubleValue]);
        CLLocationDistance radiusRange = 1000;
        MKCoordinateRegion coordinateRegion = MKCoordinateRegionMakeWithDistance(restaurantLocation, radiusRange * 2.0f, radiusRange * 2.0f);
        [self.mapView setRegion:coordinateRegion];
        [self.mapView setCenterCoordinate:restaurantLocation];
        
    }
    else {
        self.mapView.hidden = YES;
    }
    UITapGestureRecognizer *tapMap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(directionsWaze:)];
    tapMap.numberOfTouchesRequired = 1;
    [self.mapView addGestureRecognizer:tapMap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showTitleBar:@"DETAILS"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"shareTableFacebook"]) {
        ((ShareTableViewController*)segue.destinationViewController).tableNumber = _reservedTableNumber.length?_reservedTableNumber:@"??";
        ((ShareTableViewController*)segue.destinationViewController).restaurant = _restaurantDetails.name;
        ((ShareTableViewController*)segue.destinationViewController).restaurantURL = _restaurantDetails.website;
        
    }
}

- (IBAction)directionsWaze:(id)sender {
    
//    waze://?ll=37.331689,-122.030731&navigate=yes
    
// http://waze.to/?ll=latitude,longitude&navigate=yes
    
    NSString *parameters = [NSString stringWithFormat:@"?ll=%@,%@&navigate=yes",_restaurantDetails.latitude, _restaurantDetails.longitude];
    NSURL *wazeURL = [NSURL URLWithString:[NSString  stringWithFormat:@"http://waze.to/%@",parameters]];
    
    if ([[UIApplication sharedApplication] canOpenURL:wazeURL]) {
        [[UIApplication sharedApplication] openURL:wazeURL];
    } else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Alert"] message:@"Please install the Waze App." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:actionOK];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
}
- (IBAction)callRestaurant:(id)sender {
    NSString *phNo = _restaurantDetails.contact;
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Alert"] message:@"Unable to establish call." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:actionOK];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
}
- (IBAction)shareWithFriends:(id)sender {
}

@end
