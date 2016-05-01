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
    AffiliatedRestoOptionNearby
} AffiliatedRestoOption;

@interface AffiliatedRestoViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong,nonatomic) IBOutlet UIView *resultsBarView;
@property (strong,nonatomic) IBOutlet UILabel *resultsBarLabel;
@property (strong, nonatomic) NSMutableArray *dataListAll;
@property (strong, nonatomic) NSMutableArray *dataListRecent;
@property (strong, nonatomic) NSMutableArray *dataListNearby;
@property (assign,nonatomic) AffiliatedRestoOption tabBarOption;
@property (weak, nonatomic) IBOutlet UIButton *barItemRecents;
@property (weak, nonatomic) IBOutlet UIButton *barItemRestaurants;
@property (weak, nonatomic) IBOutlet UIButton *barItemNearby;

@end

@implementation AffiliatedRestoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    _resultsBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleBarView.frame.size.height, self.view.bounds.size.width, self.titleBarView.frame.size.height)];
    _resultsBarView.backgroundColor = UIColorFromRGB(0x969696);
//    _resultsBarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _resultsBarView.frame.size.width, _resultsBarView.frame.size.height)];
    
    _resultsBarLabel.font = [UIFont fontWithName:@"LucidaGrande" size:15.0f];
    _resultsBarLabel.textColor = UIColorFromRGB(0xFFFFFF);
    _resultsBarLabel.textAlignment = NSTextAlignmentCenter;
    _resultsBarLabel.backgroundColor = [UIColor clearColor];
    [_resultsBarView addSubview:_resultsBarLabel];
    
    
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRestaurants:) name:@"getRestaurantsObserver" object:nil];
    [self callGETAPI:API_RESTAURANTS withParameters:@{} completionNotification:@"getRestaurantsObserver"];
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
    id response = notification.object;
    if ([response isMemberOfClass:[NSError class]]) {
        
        [self showTitleBar:@"AFFILIATED RESTAURANT"];
        return;
    }
//    NSLog(@"response:%@",response);
    _dataListAll = [NSMutableArray arrayWithArray:((NSArray*) response)];
    
    _dataListNearby = [NSMutableArray new];
    _dataListRecent = [NSMutableArray new];
    
    [self reloadTableWithButton:nil];
}


# pragma mark UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger result = 0;
    if (_tabBarOption == AffiliatedRestoOptionAll) {
        result = _dataListAll.count;
    }
    else if (_tabBarOption == AffiliatedRestoOptionRecent) {
        result = _dataListRecent.count;
    }
    else if (_tabBarOption == AffiliatedRestoOptionNearby) {
        result = _dataListNearby.count;
    }
    
    [self setResultsBarText:[NSString stringWithFormat:@"%li Results Found",(long)result]];
    
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
            [_barItemRecents setBackgroundColor:UIColorFromRGB(0xFF7B3C)];
            [_barItemNearby setBackgroundColor:UIColorFromRGB(0xDFDFDF)];
            [_barItemRestaurants setBackgroundColor:UIColorFromRGB(0xDFDFDF)];
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
