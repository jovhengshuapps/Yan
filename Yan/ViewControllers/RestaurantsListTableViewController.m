//
//  RestaurantsListTableViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 13/08/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "RestaurantsListTableViewController.h"
#import "RestaurantDetailsViewController.h"

@interface RestaurantsListTableViewController()

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) NSMutableArray *dataListAll;
@property (strong, nonatomic) NSMutableArray *dataListFavorites;

@end

@implementation RestaurantsListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRestaurants:) name:@"getRestaurantsObserver" object:nil];
    [self callGETAPI:API_RESTAURANTS withParameters:@{} completionNotification:@"getRestaurantsObserver"];
    
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hideTitleBar];
//    [self showTitleBar:(self.showFavoritesOnly)?@"FAVORITES":@"RESTAURANTS"];
    self.title = (self.showFavoritesOnly)?@"FAVORITES":@"RESTAURANTS";
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getRestaurantsObserver" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) getRestaurants:(NSNotification*)notification {
    
    id response = notification.object;
    if ([response isKindOfClass:[NSError class]] || ([response isKindOfClass:[NSDictionary class]] && [[response allKeys] containsObject:@"error"])) {
        
        [self showTitleBar:(self.showFavoritesOnly)?@"FAVORITES":@"RESTAURANTS"];
        return;
    }
    //    NSLog(@"response:%@",response);
    //    _dataListAll = [NSMutableArray arrayWithArray:((NSArray*) response)];
    
    _dataListAll = [NSMutableArray new];
    _dataListFavorites = [NSMutableArray new];
    
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Restaurant"];
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    
    NSArray *result = [NSArray arrayWithArray:[context executeFetchRequest:request error:&error]];
    
    Account *account = [self userLoggedIn];
    
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
            
            if (!self.showFavoritesOnly) {
                    [_dataListAll addObject:restaurant];                
            }
            else {
                
                
                for (NSString *restaurantID in [account.favorite_restaurant componentsSeparatedByString:@","]) {
                    if ([restaurant.identifier isEqualToString:restaurantID]) {
                        [self.dataListFavorites addObject:restaurant];
                    }
                }
            }
            
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
    
    [self.mainTableView reloadData];
    
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
    
    if (self.showFavoritesOnly) {
        restaurantID = ((Restaurant*)_dataListFavorites[indexPath.row]).identifier;
        [self.dataListFavorites removeObjectAtIndex:indexPath.row];
    }
    else {
        restaurantID = ((Restaurant*)_dataListAll[indexPath.row]).identifier;
        
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
    
    
    if (self.showFavoritesOnly) {
        result = _dataListFavorites.count;
    }
    else {
        result = _dataListAll.count;
        
    }
    
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
    
    if (!self.showFavoritesOnly) {
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
    else {
        name = ((Restaurant*)_dataListFavorites[indexPath.row]).name;
        details = [NSString stringWithFormat:@"%@ | %@",((Restaurant*)_dataListFavorites[indexPath.row]).location,((Restaurant*)_dataListFavorites[indexPath.row]).website];
        dataList = _dataListFavorites;
        if (((Restaurant*)_dataListFavorites[indexPath.row]).imageData) {
            imageData = ((Restaurant*)_dataListFavorites[indexPath.row]).imageData;
        }
    }
    
    cell.textLabel.text = name;
    cell.detailTextLabel.text = details;
    
    if (imageData) {
        ((UIImageView*)[cell.contentView viewWithTag:45]).image = [UIImage imageWithData:imageData];
    }
    
    ((UIButton*)[cell.accessoryView viewWithTag:46]).selected = NO;
    
    Account *account = [self userLoggedIn];
    for (NSString *restaurantID in [account.favorite_restaurant componentsSeparatedByString:@","]) {
        if ([((Restaurant*)dataList[indexPath.row]).identifier isEqualToString:restaurantID]) {
            ((UIButton*)[cell.accessoryView viewWithTag:46]).selected = YES;
            break;
        }
    }
    return cell;
    
}


#pragma mark UITable Delegate

- (void)saveToFavorites:(id)sender {
    
    RestaurantCell *cell = (RestaurantCell *)((UIButton*)sender).superview;
    
    NSIndexPath *indexPath = [self.mainTableView indexPathForCell:cell];
    
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    Account *account = [self userLoggedIn];
    NSString *favoriteRestaurants = isNIL(account.favorite_restaurant);
    
    NSArray *dataList = nil;
    
    if (!self.showFavoritesOnly) {
        dataList = _dataListAll;
    }
    else {
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
    
    RestaurantDetailsViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"restaurantDetails"];
    if (!self.showFavoritesOnly) {
        details.restaurantDetails = _dataListAll[indexPath.row];
    }
    else {
        details.restaurantDetails = _dataListFavorites[indexPath.row];
    }
    [self.navigationController pushViewController:details animated:YES];
    
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

@end
