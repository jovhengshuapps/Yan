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
    
    Account *account = [self userLoggedIn];
    NSString *favoriteRestaurant = isNIL(account.favorite_restaurant);
    
    if ([favoriteRestaurant rangeOfString:self.restaurantDetails.identifier].location == NSNotFound) {
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"favorite-off-resize"] style:UIBarButtonItemStylePlain target:self action:nil];
    }
    else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"favorite-on-resize"] style:UIBarButtonItemStylePlain target:self action:nil];
    }
    
    
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    style.firstLineHeadIndent = 10.0f;
    style.headIndent = 10.0f;
    style.tailIndent = -10.0f;
    
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:_restaurantDetails.location attributes:@{ NSParagraphStyleAttributeName : style}];
    
    self.labelRestaurantAddress.numberOfLines = 0;
    self.labelRestaurantAddress.attributedText = attrText;
    self.labelRestaurantAddress.minimumScaleFactor = -5.0f;
    self.labelRestaurantAddress.adjustsFontSizeToFitWidth = YES;
    
//    self.labelRestaurantAddress.text = _restaurantDetails.location;
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
    
    self.title = self.restaurantDetails.name;
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
        ((ShareTableViewController*)segue.destinationViewController).imageLogoURL = _restaurantDetails.imageURL;
        ((ShareTableViewController*)segue.destinationViewController).imageLogo = [UIImage imageWithData:_restaurantDetails.imageData];
        
        
    }
}

- (IBAction)directionsWaze:(id)sender {
    
//    waze://?ll=37.331689,-122.030731&navigate=yes
    
// http://waze.to/?ll=latitude,longitude&navigate=yes
    
    NSString *parameters = [NSString stringWithFormat:@"?ll=%@,%@&navigate=yes",_restaurantDetails.latitude, _restaurantDetails.longitude];
//    NSURL *wazeURL = [NSURL URLWithString:[NSString  stringWithFormat:@"http://waze.to/%@",parameters]];
    NSURL *wazeURL = [NSURL URLWithString:[NSString  stringWithFormat:@"waze://%@",parameters]];
    
    if ([[UIApplication sharedApplication] canOpenURL:wazeURL]) {
        [[UIApplication sharedApplication] openURL:wazeURL];
    } else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Alert"] message:@"Please install the Waze App." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
            // Waze is not installed. Launch AppStore to install Waze app
            [[UIApplication sharedApplication] openURL:[NSURL
                                                        URLWithString:@"http://itunes.apple.com/us/app/id323229106"]];
        }];
        [alert addAction:actionOK];
        
        UIAlertAction *actionNO = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:actionNO];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
}
- (IBAction)callRestaurant:(id)sender {
    NSString *phNo = _restaurantDetails.contact;
    phNo = [phNo stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"tel://%@",phNo]];
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
