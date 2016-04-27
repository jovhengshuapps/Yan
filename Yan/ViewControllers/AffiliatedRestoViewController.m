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
    
    [self getData];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) getData {
    
    if (_tabBarOption == AffiliatedRestoOptionNearby) {
        if (!_dataListNearby) {
            _dataListNearby = [NSMutableArray new];
        }
    }
    else if (_tabBarOption == AffiliatedRestoOptionRecent) {
        if (!_dataListRecent) {
            _dataListRecent = [NSMutableArray new];
        }
    }
    else {
        if (!_dataListAll) {
            _dataListAll = [NSMutableArray new];
        }
        [_dataListAll setArray:@[@{@"name":@"Restaurant Name 0001", @"area":@"Restaurant Area", @"foodtype":@"Restaurant Food Types"},@{@"name":@"Restaurant Name 0002", @"area":@"Restaurant Area", @"foodtype":@"Restaurant Food Types"},@{@"name":@"Restaurant Name 0003", @"area":@"Restaurant Area", @"foodtype":@"Restaurant Food Types"},@{@"name":@"Restaurant Name 0001", @"area":@"Restaurant Area", @"foodtype":@"Restaurant Food Types"},@{@"name":@"Restaurant Name 0002", @"area":@"Restaurant Area", @"foodtype":@"Restaurant Food Types"},@{@"name":@"Restaurant Name 0003", @"area":@"Restaurant Area", @"foodtype":@"Restaurant Food Types"},@{@"name":@"Restaurant Name 0001", @"area":@"Restaurant Area", @"foodtype":@"Restaurant Food Types"},@{@"name":@"Restaurant Name 0002", @"area":@"Restaurant Area", @"foodtype":@"Restaurant Food Types"},@{@"name":@"Restaurant Name 0003", @"area":@"Restaurant Area", @"foodtype":@"Restaurant Food Types"},@{@"name":@"Restaurant Name 0001", @"area":@"Restaurant Area", @"foodtype":@"Restaurant Food Types"},@{@"name":@"Restaurant Name 0002", @"area":@"Restaurant Area", @"foodtype":@"Restaurant Food Types"},@{@"name":@"Restaurant Name 0003", @"area":@"Restaurant Area", @"foodtype":@"Restaurant Food Types"}]];
    }
    
    
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
        details = [NSString stringWithFormat:@"%@ | %@",[_dataListAll[indexPath.row] objectForKey:@"area"],[_dataListAll[indexPath.row] objectForKey:@"foodtype"]];
    }
    else if (_tabBarOption == AffiliatedRestoOptionRecent) {
        name = [_dataListRecent[indexPath.row] objectForKey:@"name"];
        details = [NSString stringWithFormat:@"%@ | %@",[_dataListRecent[indexPath.row] objectForKey:@"area"],[_dataListRecent[indexPath.row] objectForKey:@"foodtype"]];
        
    }
    else if (_tabBarOption == AffiliatedRestoOptionNearby) {
        name = [_dataListNearby[indexPath.row] objectForKey:@"name"];
        details = [NSString stringWithFormat:@"%@ | %@",[_dataListNearby[indexPath.row] objectForKey:@"area"],[_dataListNearby[indexPath.row] objectForKey:@"foodtype"]];
        
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
    [self.navigationController pushViewController:reserve animated:YES];
    
}

- (IBAction)reloadTableWithButton:(id)sender {
    if ([sender tag] == AffiliatedRestoOptionNearby) {
        _tabBarOption = AffiliatedRestoOptionNearby;
    }
    else if ([sender tag] == AffiliatedRestoOptionRecent) {
        _tabBarOption = AffiliatedRestoOptionRecent;
    }
    else {
        _tabBarOption = AffiliatedRestoOptionAll;
    }
    [self.mainTableView reloadData];
}



@end
