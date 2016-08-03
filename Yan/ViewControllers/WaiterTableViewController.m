//
//  WaiterTableViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 07/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "WaiterTableViewController.h"
#import "Config.h"

@interface WaiterTableViewController ()
@property (strong, nonatomic) NSMutableDictionary *waiterOptions;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) NSArray *sections;
@end

@implementation WaiterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.waiterOptions = [[NSMutableDictionary alloc] initWithDictionary:@{@"Toothpick":@0,
                                                                      @"Table Napkin":@0,
                                                                      @"Extra Utensils":@0,
                                                                      @"Water":@0,
                                                                      @"Call Waiter":@0
                                                                      }];
    
    self.sections = [_waiterOptions allKeys];
    
    self.mainTableView.backgroundColor = UIColorFromRGB(0xDFDFDF);
//    self.mainTableView.allowsSelection = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showTitleBar:@"WAITER"];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WaiterOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"waiterOptionCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.labelText.text = _sections[indexPath.row];
    cell.isChecked = [[_waiterOptions objectForKey:_sections[indexPath.row]] boolValue];
    cell.delegateOption = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 66.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.bounds.size.width, 66.0f)];
    view.backgroundColor = [UIColor clearColor];
    CustomButton *button = [CustomButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(30.0f, 5.0f, view.frame.size.width - 60.0f, view.frame.size.height - 10.0f)];
    [button setTitle:@"Continue" forState:UIControlStateNormal];
    [button  addTarget:self action:@selector(sendWaiterRequestAndDismiss) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:UIColorFromRGB(0x000000)];
    [view addSubview:button];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.bounds.size.width, 44.0f)];
    view.backgroundColor = UIColorFromRGB(0xDFDFDF);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 5.0f, view.frame.size.width - 20.0f, view.frame.size.height - 10.0f)];
    label.text = @"Choose your options:";
    label.font = [UIFont fontWithName:@"LucidaGrande" size:20.0f];
    label.textColor = UIColorFromRGB(0x363636);
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WaiterOptionTableViewCell *cell = (WaiterOptionTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell selectThisItem];
    
}

- (void) sendWaiterRequestAndDismiss {
    
    Account *account = [self userLoggedIn];
    NSInteger restaurantID = [account.current_restaurantID integerValue];
    
    NSMutableString *message = [NSMutableString stringWithString:@""];
    for (NSString *key in self.sections) {
        if ([self.waiterOptions[key] boolValue] == YES) {
            [message appendFormat:@"%@,",key];
        }
    }
    
    NSString *messageToWaiter = message;
    if ([message rangeOfString:@","].location != NSNotFound) {
        messageToWaiter = [message substringToIndex:message.length-1];
    }
    
//    NSLog(@"request WAITER:%@",messageToWaiter);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(waiterRequestSent:) name:@"sendWaiterRequest" object:nil];
    [self callAPI:API_WAITER(restaurantID) withParameters:@{ @"uid": account.identifier, @"table": account.current_tableNumber, @"message": messageToWaiter} completionNotification:@"sendWaiterRequest"];

    
}

- (void) waiterRequestSent:(NSNotification*)notification {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)optionKey:(NSString *)key checked:(BOOL)isChecked {
    [_waiterOptions setValue:[NSNumber numberWithBool:isChecked] forKey:key];
    [self.mainTableView reloadData];
}


@end
