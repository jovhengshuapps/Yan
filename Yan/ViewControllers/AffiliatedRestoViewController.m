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
    }
    else {
        
        self.viewMainBar.hidden = YES;
        self.viewFromDrawerBar.hidden = NO;
    }
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showTitleBar:@"AFFILIATED RESTAURANT"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) setResultsBarText:(NSString*)text {
    _resultsBarLabel.text = text;
}

- (void) getRestaurants:(NSNotification*)notification {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification.name object:nil];
    id response = notification.object;
    if ([response isMemberOfClass:[NSError class]] || ([response isKindOfClass:[NSDictionary class]] && [[response allKeys] containsObject:@"error"])) {
        
        [self showTitleBar:@"AFFILIATED RESTAURANT"];
        return;
    }
//    NSLog(@"response:%@",response);
    _dataListAll = [NSMutableArray arrayWithArray:((NSArray*) response)];
    
    _dataListNearby = [NSMutableArray new];
    _dataListRecent = [NSMutableArray new];
    _dataListFavorites = [NSMutableArray new];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = _showAffiliatedRestaurant;
    [self reloadTableWithButton:button];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CELL";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont fontWithName:@"LucidaGrande" size:16.0f];
        cell.detailTextLabel.font = [UIFont fontWithName:@"LucidaGrande" size:12.0f];
        cell.detailTextLabel.textColor = UIColorFromRGB(0x959595);
    }
    
    NSString *name = @"";
    NSString *details = @"";
    
    if (_tabBarOption == AffiliatedRestoOptionAll) {
        name = [_dataListAll[indexPath.row] objectForKey:@"name"];
        details = [NSString stringWithFormat:@"%@ | %@",[_dataListAll[indexPath.row] objectForKey:@"location"],[_dataListAll[indexPath.row] objectForKey:@"website"]];
    }
    else if (_tabBarOption == AffiliatedRestoOptionRecent) {
        name = [_dataListRecent[indexPath.row] objectForKey:@"name"];
        details = [NSString stringWithFormat:@"%@ | %@",[_dataListRecent[indexPath.row] objectForKey:@"location"],[_dataListRecent[indexPath.row] objectForKey:@"website"]];
        
    }
    else if (_tabBarOption == AffiliatedRestoOptionNearby) {
        name = [_dataListNearby[indexPath.row] objectForKey:@"name"];
        details = [NSString stringWithFormat:@"%@ | %@",[_dataListNearby[indexPath.row] objectForKey:@"location"],[_dataListNearby[indexPath.row] objectForKey:@"website"]];
        
    }
    else if (_tabBarOption == AffiliatedRestoOptionFavorites) {
        name = [_dataListFavorites[indexPath.row] objectForKey:@"name"];
        details = [NSString stringWithFormat:@"%@ | %@",[_dataListFavorites[indexPath.row] objectForKey:@"location"],[_dataListFavorites[indexPath.row] objectForKey:@"website"]];
        
    }
    cell.textLabel.text = name;
    cell.detailTextLabel.text = details;
//    cell.textLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:name attributes:TextAttributes(@"LucidaGrande", (0xFFFFFF), 24.0f)];
//    cell.detailTextLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:details attributes:TextAttributes(@"LucidaGrande", (0xFFFFFF), 24.0f)];
    
    return cell;
    
}

#pragma mark UITable Delegate

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

- (IBAction)reloadTableWithButton:(id)sender {
    if (sender) {
        if ([sender tag] == AffiliatedRestoOptionNearby) {
            _tabBarOption = AffiliatedRestoOptionNearby;
            [_barItemRecents setBackgroundColor:UIColorFromRGB(0xDFDFDF)];
            [_barItemNearby setBackgroundColor:UIColorFromRGB(0xFF7B3C)];
            [_barItemRestaurants setBackgroundColor:UIColorFromRGB(0xDFDFDF)];
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
        }else if ([sender tag] == AffiliatedRestoOptionFavorites) {
            _tabBarOption = AffiliatedRestoOptionFavorites;
                [_drawerBarItemRecents setBackgroundColor:UIColorFromRGB(0xDFDFDF)];
                [_drawerBarItemFavorites setBackgroundColor:UIColorFromRGB(0xFF7B3C)];
            
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



@end
