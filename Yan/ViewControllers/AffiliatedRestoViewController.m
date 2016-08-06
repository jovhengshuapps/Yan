//
//  AffiliatedRestoViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 4/18/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "AffiliatedRestoViewController.h"
#import "ReserveRestoViewController.h"

typedef enum {
    AffiliatedRestoOptionAll,
    AffiliatedRestoOptionRecent,
    AffiliatedRestoOptionFavorites,
    AffiliatedRestoOptionNearby
} AffiliatedRestoOption;

@interface AffiliatedRestoViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong,nonatomic) IBOutlet UIView *resultsBarView;
@property (strong,nonatomic) IBOutlet UILabel *resultsBarLabel;
@property (strong, nonatomic) NSMutableArray *dataListAll;
@property (strong, nonatomic) NSMutableArray *dataListRecent;
@property (strong, nonatomic) NSMutableArray *dataListNearby;
@property (strong, nonatomic) NSMutableArray *dataListFavorites;

@property (assign,nonatomic) AffiliatedRestoOption tabBarOption;
@property (weak, nonatomic) IBOutlet UIButton *barItemRecents;
@property (weak, nonatomic) IBOutlet UIButton *barItemRestaurants;
@property (weak, nonatomic) IBOutlet UIButton *barItemNearby;
@property (weak, nonatomic) IBOutlet UIView *viewMainBar;
@property (weak, nonatomic) IBOutlet UIView *viewFromDrawerBar;
@property (weak, nonatomic) IBOutlet UIButton *drawerBarItemRecents;
@property (weak, nonatomic) IBOutlet UIButton *drawerBarItemFavorites;

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation AffiliatedRestoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRestaurants:) name:@"getRestaurantsObserver" object:nil];
    [self callGETAPI:API_RESTAURANTS withParameters:@{} completionNotification:@"getRestaurantsObserver"];
    
    _resultsBarView.backgroundColor = UIColorFromRGB(0x969696);
    _resultsBarLabel.font = [UIFont fontWithName:@"LucidaGrande" size:15.0f];
    _resultsBarLabel.textColor = UIColorFromRGB(0xFFFFFF);
    _resultsBarLabel.textAlignment = NSTextAlignmentCenter;
    _resultsBarLabel.backgroundColor = [UIColor clearColor];
    [_resultsBarView addSubview:_resultsBarLabel];
    

    CGFloat defaultTableHeight = self.mainTableView.frame.size.height;
    if (_showAffiliatedRestaurant == AffiliatedRestaurantsAll) {
        
        [_barItemRestaurants setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 5.0f)];
        _barItemRestaurants.titleLabel.minimumScaleFactor = -5.0f;
        _barItemRestaurants.titleLabel.adjustsFontSizeToFitWidth = YES;
        NSString *fontName = _barItemRestaurants.titleLabel.font.fontName;
        
        CGSize sizeOneLine = [_barItemRestaurants.titleLabel.text sizeWithFont:_barItemRestaurants.titleLabel.font];
        
        CGSize sizeOneLineConstrained = [_barItemRestaurants.titleLabel.text sizeWithFont:_barItemRestaurants.titleLabel.font constrainedToSize:_barItemRestaurants.titleLabel.frame.size];
        
        CGFloat approxScaleFactor = sizeOneLineConstrained.width / sizeOneLine.width;
        
        NSInteger approxScaledPointSize = approxScaleFactor * _barItemRestaurants.titleLabel.font.pointSize;
        
        _barItemNearby.titleLabel.font = [UIFont fontWithName:fontName size:approxScaledPointSize-2];
        _barItemRecents.titleLabel.font = [UIFont fontWithName:fontName size:approxScaledPointSize-2];
        
        self.viewMainBar.hidden = NO;
        self.viewFromDrawerBar.hidden = YES;
        
        CGRect frame = self.mainTableView.frame;
        frame.size.height = defaultTableHeight;
        self.mainTableView.frame = frame;
        
    }
    else {
        
        self.viewMainBar.hidden = YES;
        self.viewFromDrawerBar.hidden = YES;
        CGRect frame = self.mainTableView.frame;
        frame.size.height = defaultTableHeight + 44.0f;
        self.mainTableView.frame = frame;
    }
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showTitleBar:@"RESTAURANTS"];
    
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getRestaurantsObserver" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) setResultsBarText:(NSString*)text {
    _resultsBarLabel.text = text;
}

- (void) getRestaurants:(NSNotification*)notification {
    
    id response = notification.object;
    if ([response isKindOfClass:[NSError class]] || ([response isKindOfClass:[NSDictionary class]] && [[response allKeys] containsObject:@"error"])) {
        
        [self showTitleBar:@"RESTAURANTS"];
        return;
    }
//    NSLog(@"response:%@",response);
//    _dataListAll = [NSMutableArray arrayWithArray:((NSArray*) response)];

    _dataListAll = [NSMutableArray new];
    _dataListNearby = [NSMutableArray new];
    _dataListRecent = [NSMutableArray new];
    _dataListFavorites = [NSMutableArray new];
    
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Restaurant"];
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    
    NSArray *result = [NSArray arrayWithArray:[context executeFetchRequest:request error:&error]];
    
    
    for (NSDictionary *restaurantDetails in ((NSArray*) response)) {
        
        
        BOOL isNew = YES;
        Restaurant *restaurant = nil;
        
        for (Restaurant *resto in result) {
            if ([resto.identifier isEqualToString:[NSString stringWithFormat:@"%@",isNIL(restaurantDetails[@"id"])]]) {
                isNew = NO;
                restaurant = (Restaurant*)resto;
                break;
            }
        }
        
        if (isNew) {
            restaurant = [[Restaurant alloc] initWithEntity:[NSEntityDescription entityForName:@"Restaurant" inManagedObjectContext:context]  insertIntoManagedObjectContext:context];
        }
        
        
//        Restaurant *restaurant = [[Restaurant alloc] initWithEntity:[NSEntityDescription entityForName:@"Restaurant" inManagedObjectContext:context]  insertIntoManagedObjectContext:context];
        
        restaurant.contact = isNIL(restaurantDetails[@"contact"]);
        restaurant.identifier = [NSString stringWithFormat:@"%@",isNIL(restaurantDetails[@"id"])];
        restaurant.imageURL = isNIL(restaurantDetails[@"image"]);
//        restaurant.imageData;
        restaurant.latitude = isNIL(restaurantDetails[@"lat"]);
        restaurant.longitude = isNIL(restaurantDetails[@"lng"]);
        restaurant.location = isNIL(restaurantDetails[@"location"]);
        restaurant.name = isNIL(restaurantDetails[@"name"]);
        restaurant.payment_options = isNIL(restaurantDetails[@"payment_options"]);
        restaurant.website = isNIL(restaurantDetails[@"website"]);
        restaurant.logo_model = isNIL(restaurantDetails[@"logo_model"]);
        restaurant.operating = isNIL(restaurantDetails[@"operating"]);
        restaurant.policy = isNIL(restaurantDetails[@"policy"]);
        
        
        NSError *error = nil;
        if ([context save:&error]) {
//            NSManagedObjectContext *context1 = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
//            
//            NSFetchRequest *request1 = [[NSFetchRequest alloc] initWithEntityName:@"Restaurant"];
//            [request1 setReturnsObjectsAsFaults:NO];
//            NSError *error1 = nil;
//            
//            NSArray *result1 = [NSArray arrayWithArray:[context1 executeFetchRequest:request1 error:&error1]];
            
//            [_dataListAll addObject:restaurant];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = _showAffiliatedRestaurant;
            [self reloadTableWithButton:button];
            
        }
        else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Error %li",(long)[error code]] message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:actionOK];
            
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }
    }
    
//    [self.mainTableView reloadData];
}

- (void) detailButtonTapped: (UIControl *) button withEvent: (UIEvent *) event
{
    NSIndexPath * indexPath = [self.mainTableView indexPathForRowAtPoint: [[[event touchesForView: button] anyObject] locationInView: self.mainTableView]];
    if ( indexPath == nil )
        return;
    
    [self.mainTableView.delegate tableView: self.mainTableView accessoryButtonTappedForRowWithIndexPath: indexPath];
}

# pragma mark Delegate
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    //add to order list
    
//    NSLog(@"accessory:[%li / %li]",(long)indexPath.section, (long)indexPath.row);
    
    UITableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:indexPath];
    UIButton *accessoryButton = [(UIButton*)cell.contentView viewWithTag:46];
    [accessoryButton setSelected:!accessoryButton.selected];
    
    NSString *restaurantID = @"";
    if (_tabBarOption == AffiliatedRestoOptionAll) {
        restaurantID = ((Restaurant*)_dataListAll[indexPath.row]).identifier;
    }
    else if (_tabBarOption == AffiliatedRestoOptionRecent) {
        restaurantID = ((Restaurant*)_dataListRecent[indexPath.row]).identifier;
    }
    else if (_tabBarOption == AffiliatedRestoOptionNearby) {
        restaurantID = ((Restaurant*)_dataListNearby[indexPath.row]).identifier;
    }
    else if (_tabBarOption == AffiliatedRestoOptionFavorites) {
        restaurantID = ((Restaurant*)_dataListFavorites[indexPath.row]).identifier;
        [self.dataListFavorites removeObjectAtIndex:indexPath.row];
    }
    
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    Account *account = [self userLoggedIn];
    NSString *favoriteRestaurant = isNIL(account.favorite_restaurant);
    
    if ([favoriteRestaurant rangeOfString:restaurantID].location == NSNotFound) {
        account.favorite_restaurant = [NSString stringWithFormat:@"%@,%@",favoriteRestaurant, restaurantID];
    }
    else {
        account.favorite_restaurant = [favoriteRestaurant stringByReplacingOccurrencesOfString:restaurantID withString:@""];
    }
    
    
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
    
    
    [self.mainTableView reloadData];
}

# pragma mark UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger result = 0;
    
    NSString *appendedType = @"";
    
    if (_tabBarOption == AffiliatedRestoOptionAll) {
        result = _dataListAll.count;
        appendedType = @"";
    }
    else if (_tabBarOption == AffiliatedRestoOptionRecent) {
        result = _dataListRecent.count;
        appendedType = @" (RECENT)";
    }
    else if (_tabBarOption == AffiliatedRestoOptionNearby) {
        result = _dataListNearby.count;
        appendedType = @" NEARBY";
    }
    else if (_tabBarOption == AffiliatedRestoOptionFavorites) {
        result = _dataListFavorites.count;
        appendedType = @" (FAVORITES)";
    }
    
    [self setResultsBarText:[NSString stringWithFormat:@"%li RESTAURANT AVAILABLE%@",(long)result, appendedType]];
    
    return result;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:indexPath];
    if ([cell.contentView viewWithTag:45]) {
        return 0;
    }
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    
//    RestaurantCell *cell = [tableView dequeueReusableCellWithIdentifier:@"restaurantCell"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont fontWithName:@"LucidaGrande" size:16.0f];
        cell.detailTextLabel.font = [UIFont fontWithName:@"LucidaGrande" size:12.0f];
        cell.detailTextLabel.textColor = UIColorFromRGB(0x959595);
    
        UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 40, 40)];
        imgView.image = [UIImage imageNamed:@"yan-new-logo"];
        imgView.backgroundColor=[UIColor clearColor];
        imgView.tag = 45;
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:imgView];
        
        UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [detailButton addTarget:self action:@selector(detailButtonTapped:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        detailButton.tag = 46;
        [detailButton setImage:[UIImage imageNamed:@"favorite-off"] forState:UIControlStateNormal];
        [detailButton setImage:[UIImage imageNamed:@"favorite-on"] forState:UIControlStateSelected];
        [detailButton setFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
        cell.accessoryView = detailButton;
        
    }
    
    NSString *name = @"";
    NSString *details = @"";
    NSData *imageData = nil;
    NSArray *dataList = nil;
    
    if (_tabBarOption == AffiliatedRestoOptionAll) {
        name = ((Restaurant*)_dataListAll[indexPath.row]).name;
        details = [NSString stringWithFormat:@"%@ | %@",((Restaurant*)_dataListAll[indexPath.row]).location,((Restaurant*)_dataListAll[indexPath.row]).website];
        dataList = _dataListAll;
        if (((Restaurant*)_dataListAll[indexPath.row]).imageData) {
            imageData = ((Restaurant*)_dataListAll[indexPath.row]).imageData;
        }
        else {
            if (((Restaurant*)_dataListAll[indexPath.row]).imageURL.length) {
                UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
                
                progressView.frame = CGRectMake(0.0f, 0.0f, cell.contentView.frame.size.width, 5.0f);
                [progressView setProgress:0.0f];
                progressView.tag = 12345;
                
                CABasicAnimation *theAnimation;
                
                theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
                theAnimation.duration=1.0;
                theAnimation.repeatCount=HUGE_VALF;
                theAnimation.autoreverses=YES;
                theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
                theAnimation.toValue=[NSNumber numberWithFloat:0.0];
                
                [((UIImageView*)[cell.contentView viewWithTag:45]).layer addAnimation:theAnimation forKey:@"animateOpacity"];
                
                [self getImageFromURL:((Restaurant*)_dataListAll[indexPath.row]).imageURL onIndex:indexPath.row];
            }
        }
    }
    else if (_tabBarOption == AffiliatedRestoOptionRecent) {
        name = ((Restaurant*)_dataListRecent[indexPath.row]).name;
        details = [NSString stringWithFormat:@"%@ | %@",((Restaurant*)_dataListRecent[indexPath.row]).location,((Restaurant*)_dataListRecent[indexPath.row]).website];
        dataList = _dataListRecent;
        if (((Restaurant*)_dataListRecent[indexPath.row]).imageData) {
            imageData = ((Restaurant*)_dataListRecent[indexPath.row]).imageData;
        }
        
    }
    else if (_tabBarOption == AffiliatedRestoOptionNearby) {
        name = ((Restaurant*)_dataListNearby[indexPath.row]).name;
        details = [NSString stringWithFormat:@"%@ | %@",((Restaurant*)_dataListNearby[indexPath.row]).location,((Restaurant*)_dataListNearby[indexPath.row]).website];
        dataList = _dataListNearby;
        if (((Restaurant*)_dataListNearby[indexPath.row]).imageData) {
            imageData = ((Restaurant*)_dataListNearby[indexPath.row]).imageData;
        }
        
    }
    else if (_tabBarOption == AffiliatedRestoOptionFavorites) {
        name = ((Restaurant*)_dataListFavorites[indexPath.row]).name;
        details = [NSString stringWithFormat:@"%@ | %@",((Restaurant*)_dataListFavorites[indexPath.row]).location,((Restaurant*)_dataListFavorites[indexPath.row]).website];
        dataList = _dataListFavorites;
        if (((Restaurant*)_dataListFavorites[indexPath.row]).imageData) {
            imageData = ((Restaurant*)_dataListFavorites[indexPath.row]).imageData;
        }
    }
//    cell.restaurantName = name;
//    cell.restaurantDetails = details;
    
    cell.textLabel.text = name;
    cell.detailTextLabel.text = details;
    
    if (imageData) {
        ((UIImageView*)[cell.contentView viewWithTag:45]).image = [UIImage imageWithData:imageData];
//        cell.imageView.image = [UIImage imageWithData:imageData];
    }
    
    ((UIButton*)[cell.accessoryView viewWithTag:46]).selected = NO;
    
    Account *account = [self userLoggedIn];
    for (NSString *restaurantID in [account.favorite_restaurant componentsSeparatedByString:@","]) {
        if ([((Restaurant*)dataList[indexPath.row]).identifier isEqualToString:restaurantID]) {
            ((UIButton*)[cell.accessoryView viewWithTag:46]).selected = YES;
            break;
        }
    }
//
//    cell.textLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:name attributes:TextAttributes(@"LucidaGrande", (0xFFFFFF), 24.0f)];
//    cell.detailTextLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:details attributes:TextAttributes(@"LucidaGrande", (0xFFFFFF), 24.0f)];
    
    return cell;
    
}


#pragma mark UITable Delegate

- (void)saveToFavorites:(id)sender {
    
    RestaurantCell *cell = (RestaurantCell *)((UIButton*)sender).superview;
    
    NSIndexPath *indexPath = [self.mainTableView indexPathForCell:cell];
    
    
    UIButton *accessoryButton = [(UIButton*)cell.accessoryView viewWithTag:46];
    //    [accessoryButton setSelected:!accessoryButton.selected];
    
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    Account *account = [self userLoggedIn];
    NSString *favoriteRestaurants = isNIL(account.favorite_restaurant);
    
    NSArray *dataList = nil;
    
    if (_tabBarOption == AffiliatedRestoOptionAll) {
        dataList = _dataListAll;
    }
    else if (_tabBarOption == AffiliatedRestoOptionRecent) {
        dataList = _dataListRecent;
    }
    else if (_tabBarOption == AffiliatedRestoOptionNearby) {
        dataList = _dataListNearby;
    }
    else if (_tabBarOption == AffiliatedRestoOptionFavorites) {
        dataList = _dataListFavorites;
    }
    
    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:cell.textLabel.text message:(cell.tag==0)?@"SHOULD ADD":@"SHOULD REMOVE" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
    //    [alertView show];
    
    
    if (cell.tag == 0) {
        cell.tag = 1;
        account.favorite_restaurant = [NSString stringWithFormat:@"%@,%@",favoriteRestaurants, ((Restaurant*)dataList[indexPath.row]).identifier];
    }
    else {
        cell.tag = 0;
        account.favorite_restaurant = [account.favorite_restaurant stringByReplacingOccurrencesOfString:((Restaurant*)dataList[indexPath.row]).identifier withString:@""];
    }
    
    
    
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
    
    [self.mainTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ReserveRestoViewController *reserve = [self.storyboard instantiateViewControllerWithIdentifier:@"reserveResto"];
    if (_tabBarOption == AffiliatedRestoOptionAll) {
        reserve.restaurantDetails = _dataListAll[indexPath.row];
    }
    else if (_tabBarOption == AffiliatedRestoOptionRecent) {
        reserve.restaurantDetails = _dataListRecent[indexPath.row];
        
    }
    else if (_tabBarOption == AffiliatedRestoOptionNearby) {
        reserve.restaurantDetails = _dataListNearby[indexPath.row];
        
    }
    else if (_tabBarOption == AffiliatedRestoOptionFavorites) {
        reserve.restaurantDetails = _dataListFavorites[indexPath.row];
        
    }
    [self.navigationController pushViewController:reserve animated:YES];
    
}

- (void) getImageFromURL:(NSString*)urlPath onIndex:(NSInteger)index {
    [self getImageFromURL:urlPath completionHandler:^(NSURLResponse * _Nullable response, id  _Nullable responseObject, NSError * _Nullable error) {
        if(!error) {
            UIImage *image = (UIImage*)responseObject;
            
            
            NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
            
            NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Restaurant"];
            [request setReturnsObjectsAsFaults:NO];
            NSError *error = nil;
            
            NSArray *result = [NSArray arrayWithArray:[context executeFetchRequest:request error:&error]];
            
            id restaurant = nil;
            
            for (Restaurant *resto in result) {
                if ([resto.identifier isEqualToString:((Restaurant*)_dataListAll[index]).identifier]) {
                    restaurant = resto;
                    break;
                }
            }
            
            ((Restaurant*)restaurant).imageData = UIImageJPEGRepresentation(image, 100.0f);
            
            NSError *saveError = nil;
            
            if([context save:&saveError]) {
                
                UITableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                
//                cell.imageView.image = image;
//                [cell.imageView.layer removeAllAnimations];
                
                 ((UIImageView*)[cell.contentView viewWithTag:45]).image = image;
                 [((UIImageView*)[cell.contentView viewWithTag:45]).layer removeAllAnimations];
                 [((UIProgressView*)[cell.contentView viewWithTag:12345]) removeFromSuperview];
                
                
            }
        }
    } andProgress:^(NSInteger expectedBytesToReceive, NSInteger receivedBytes) {
        UITableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        
        [((UIProgressView*)[cell.contentView viewWithTag:12345]) setProgress:((CGFloat)receivedBytes / (CGFloat)expectedBytesToReceive) animated:YES];
        
    }];
}

- (IBAction)reloadTableWithButton:(id)sender {
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Restaurant"];
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    
    NSArray *result = [NSArray arrayWithArray:[context executeFetchRequest:request error:&error]];
    _dataListAll = nil;
    _dataListAll = [NSMutableArray array];
    for (Restaurant *restaurant in result) {
        [_dataListAll addObject:restaurant];
    }
    
    if (sender) {
        if ([sender tag] == AffiliatedRestoOptionNearby) {
            _tabBarOption = AffiliatedRestoOptionNearby;
            [_barItemRecents setBackgroundColor:UIColorFromRGB(0xDFDFDF)];
            [_barItemNearby setBackgroundColor:UIColorFromRGB(0xFF7B3C)];
            [_barItemRestaurants setBackgroundColor:UIColorFromRGB(0xDFDFDF)];
            
            
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            self.locationManager.distanceFilter = kCLDistanceFilterNone;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
                [self.locationManager requestWhenInUseAuthorization];
            
            [self.locationManager startUpdatingLocation];            
            
            
        }
        else if ([sender tag] == AffiliatedRestoOptionRecent) {
            _tabBarOption = AffiliatedRestoOptionRecent;
            if (_showAffiliatedRestaurant == AffiliatedRestaurantsRecents || _showAffiliatedRestaurant == AffiliatedRestaurantsFavorites) {
                [_drawerBarItemRecents setBackgroundColor:UIColorFromRGB(0xFF7B3C)];
                [_drawerBarItemFavorites setBackgroundColor:UIColorFromRGB(0xDFDFDF)];
            }
            else {[_barItemRecents setBackgroundColor:UIColorFromRGB(0xFF7B3C)];
                [_barItemNearby setBackgroundColor:UIColorFromRGB(0xDFDFDF)];
                [_barItemRestaurants setBackgroundColor:UIColorFromRGB(0xDFDFDF)];
            }
            
            if (self.dataListRecent.count == 0) {
                
                Account *account = [self userLoggedIn];
                
//                if ([account.recent_restaurant rangeOfString:@","].location == NSNotFound) {
//                    for (id restaurant in self.dataListAll) {
//                        if ([((Restaurant*)restaurant).identifier isEqualToString:account.recent_restaurant]) {
//                            [self.dataListRecent addObject:restaurant];
//                        }
//                    }
//                }
//                else {
                    for (NSString *restaurantID in [account.recent_restaurant componentsSeparatedByString:@","]) {
                        for (id restaurant in self.dataListAll) {
                            if ([((Restaurant*)restaurant).identifier isEqualToString:restaurantID]) {
                                [self.dataListRecent addObject:restaurant];
                            }
                        }
                    }
//                }
            }
            
            
        }else if ([sender tag] == AffiliatedRestoOptionFavorites) {
            _tabBarOption = AffiliatedRestoOptionFavorites;
            _drawerBarItemRecents.frame = CGRectZero;
            _drawerBarItemFavorites.frame = CGRectMake(0.0f, _drawerBarItemFavorites.frame.origin.y, self.mainTableView.frame.size.width, _drawerBarItemFavorites.frame.size.height);
                [_drawerBarItemRecents setBackgroundColor:UIColorFromRGB(0xDFDFDF)];
                [_drawerBarItemFavorites setBackgroundColor:UIColorFromRGB(0xFF7B3C)];
            
            
            if (self.dataListFavorites.count == 0) {
                
                Account *account = [self userLoggedIn];
                
                for (NSString *restaurantID in [account.favorite_restaurant componentsSeparatedByString:@","]) {
                    for (id restaurant in self.dataListAll) {
                        if ([((Restaurant*)restaurant).identifier isEqualToString:restaurantID]) {
                            [self.dataListFavorites addObject:restaurant];
                        }
                    }
                }
            }
            
        }
        else {
            _tabBarOption = AffiliatedRestoOptionAll;
            [_barItemRecents setBackgroundColor:UIColorFromRGB(0xDFDFDF)];
            [_barItemNearby setBackgroundColor:UIColorFromRGB(0xDFDFDF)];
            [_barItemRestaurants setBackgroundColor:UIColorFromRGB(0xFF7B3C)];
        }
    }
    else {
        _tabBarOption = AffiliatedRestoOptionAll;
        [_barItemRecents setBackgroundColor:UIColorFromRGB(0xDFDFDF)];
        [_barItemNearby setBackgroundColor:UIColorFromRGB(0xDFDFDF)];
        [_barItemRestaurants setBackgroundColor:UIColorFromRGB(0xFF7B3C)];
    }
    
    [self.mainTableView reloadData];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
//    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
//    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *currentLocation = [locations objectAtIndex:0];
//    CGFloat userLatitude = currentLocation.coordinate.latitude;
//    CGFloat userLongitude = currentLocation.coordinate.longitude;
    
    __block NSArray *userCurrentAddressLine = [NSArray array];
    
    
    [manager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
//             NSLog(@"\nCurrent Location Detected\n");
//             NSLog(@"placemark %@",placemark);
//             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
//             NSString *Address = [[NSString alloc]initWithString:locatedAt];
//             NSString *Area = [[NSString alloc]initWithString:placemark.locality];
//             NSString *Country = [[NSString alloc]initWithString:placemark.country];
//             NSString *CountryArea = [NSString stringWithFormat:@"%@, %@", Area,Country];
//             NSLog(@"%@",CountryArea);
             userCurrentAddressLine = [placemark.addressDictionary valueForKey:@"FormattedAddressLines"];
             
             
             for (id restaurant in self.dataListAll) {
                 CGFloat restaurantLatitude = [((Restaurant*)restaurant).latitude floatValue];
                 CGFloat restaurantLongitude = [((Restaurant*)restaurant).longitude floatValue];
                 //        NSLog(@"location:%@",((Restaurant*)restaurant).location);
                 
                 if (restaurantLatitude != 0.0f && restaurantLongitude != 0.0f) {
                     //use longitude and latitude as basis
                     CLLocation *restaurantLocation = [[CLLocation alloc] initWithLatitude:restaurantLatitude longitude:restaurantLongitude];
                     CLLocationDistance meters = [restaurantLocation distanceFromLocation:currentLocation];
                     //            NSLog(@"meters: %f",meters);
                     if (meters <= 5000) {
                         [self.dataListNearby addObject:restaurant];
                     }
                     
                 }
                 else {
                     //use location
                     for (NSString *location in userCurrentAddressLine) {
                         if ([[location lowercaseString] isEqualToString:[((Restaurant*)restaurant).location lowercaseString]]) {
                             [self.dataListNearby addObject:restaurant];
                         }
                     }
                 }
             }
             
//             NSLog(@"nearby:%@",self.dataListNearby);
             
             [self.mainTableView reloadData];
             
             
         }
         else
         {
//             NSLog(@"Geocode failed with error %@", error);
//             NSLog(@"\nCurrent Location Not Detected\n");
             //return;
         }
         /*---- For more results
          placemark.region);
          placemark.country);
          placemark.locality);
          placemark.name);
          placemark.ocean);
          placemark.postalCode);
          placemark.subLocality);
          placemark.location);
          ------*/
     }];

    
    
}

@end
