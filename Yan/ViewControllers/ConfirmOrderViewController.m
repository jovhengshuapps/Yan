//
//  ConfirmOrderViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 28/04/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "ConfirmOrderViewController.h"
#import "PaymentSelectViewController.h"

@interface ConfirmOrderViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (assign, nonatomic) BOOL billoutOrder;

@end

@implementation ConfirmOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _billoutOrder = YES;
    _mainTable.allowsSelection = NO;
    
    [self fetchOrderDataList];
    
    CGFloat totalValue = 0.0f;
    
    for (OrderList *item in _arrayOrderList) {
        totalValue += ([item.itemPrice floatValue] * [item.itemQuantity floatValue]);
    }
    
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, KEYWINDOW.frame.size.width+5.0f, 110.0f)];
    footerView.backgroundColor = UIColorFromRGB(0xDFDFDF);
    
    UIView *totalView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, footerView.bounds.size.width, 44.0f)];
    totalView.backgroundColor = UIColorFromRGB(0x333333);
    
    UILabel *labelTotal = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 120.0f, 44.0f)];
    labelTotal.backgroundColor = [UIColor clearColor];
    labelTotal.font = [UIFont fontWithName:@"LucidaGrande" size:20.0f];
    labelTotal.textColor = UIColorFromRGB(0x666666);
    labelTotal.textAlignment = NSTextAlignmentLeft;
    labelTotal.text = @"TOTAL:";
    [totalView addSubview:labelTotal];
    
    UILabel *labelTotalValue = [[UILabel alloc] initWithFrame:CGRectMake(labelTotal.bounds.origin.x + labelTotal.bounds.size.width, 0.0f, footerView.bounds.size.width - (labelTotal.bounds.size.width  + 20.0f), 44.0f)];
    labelTotalValue.backgroundColor = [UIColor clearColor];
    labelTotalValue.font = [UIFont fontWithName:@"LucidaGrande" size:20.0f];
    labelTotalValue.textColor = UIColorFromRGB(0x666666);
    labelTotalValue.textAlignment = NSTextAlignmentRight;
    labelTotalValue.text = [NSString stringWithFormat:@"PHP: %.2f",totalValue];
    [totalView addSubview:labelTotalValue];
    
    [footerView addSubview:totalView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(20.0f, footerView.bounds.size.height - 44.0f - 10.0f, footerView.bounds.size.width - 20.0f - 20.0f, 44.0f)];
    if (!_arrayOrderList.count) {
        button.enabled = NO;
        [button setBackgroundColor:UIColorFromRGB(0xDFDFDF)];
        [button setTitle:@". . ." forState:UIControlStateNormal];
    }
    else {
        button.enabled = YES;
        [button setBackgroundColor:UIColorFromRGB(0x000000)];
        if (_billoutOrder) {
            [button setTitle:@"Billout" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(callBillout) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            [button setTitle:@"Confirm Orders" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(orderSentToServer) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    button.titleLabel.font = [UIFont fontWithName:@"LucidaGrande" size:20.0f];
    button.titleLabel.textColor = UIColorFromRGB(0xFFFFFF);
    
    [footerView addSubview:button];
    
    
    [_mainTable setTableFooterView:footerView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showTitleBar:[NSString stringWithFormat:@"Orders: Table %@",_tableNumber]];
}

- (void) fetchOrderDataList {
    
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OrderList"];
    
    NSError *error = nil;
    
    _arrayOrderList = [NSArray arrayWithArray:[context executeFetchRequest:request error:&error]];
    
    //check if billout
    for (OrderList *item in _arrayOrderList) {
        if ([item.orderSent boolValue] == NO) {
            _billoutOrder = NO;
            break;
        }
    }
    
}

- (void) orderSentToServer {
    //call api
    
    
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    //update orders
    for (OrderList *item in _arrayOrderList) {
        item.orderSent = @YES;
    }
    
    NSError *error = nil;
    [context save:&error];
    
    [self.navigationController popToViewController:[self.navigationController viewControllers][2] animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderSentNotification" object:nil];
}

- (void) callBillout {
    PaymentSelectViewController *paymentSelect = (PaymentSelectViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"paymentSelection"];
    paymentSelect.tableNumber = _tableNumber;
    [self.navigationController pushViewController:paymentSelect animated:YES];
}

#pragma mark Table Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayOrderList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 64.0f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.bounds.size.width, 64.0f)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:headerView.frame];
    label.center = headerView.center;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"LucidaGrande" size:22.0f];
    label.textColor = [UIColor blackColor];
    if (!_arrayOrderList.count) {
        label.text = @"You have no orders yet.";
    }
    else {
        label.text = @"Your Orders";
    }
    
    [headerView addSubview:label];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.contentView.bounds.size.width - 35.0f, 0.0f, 32.0f, 32.0f)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"LucidaGrande" size:22.0f];
        label.textColor = [UIColor blackColor];
        label.tag = 1;
        cell.accessoryView = label;
    }
    
    OrderList *item = _arrayOrderList[indexPath.row];
    NSString *text = [NSString stringWithFormat:@"%@ PHP%@",[item.itemName uppercaseString],item.itemPrice];
    
    CGFloat nameSize = [self tableView:tableView heightForRowAtIndexPath:indexPath] - 20.0f;
    CGFloat priceSize = nameSize / 2.0f;
    
    NSArray *components = [text componentsSeparatedByString:@" PHP"];
    NSRange nameRange = [text rangeOfString:[components objectAtIndex:0]];
    NSRange priceRange = [text rangeOfString:[components objectAtIndex:1]];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attrString beginEditing];
    [attrString addAttribute: NSFontAttributeName
                       value:[UIFont fontWithName:@"LucidaGrande" size:nameSize]
                       range:nameRange];
    
    [attrString addAttribute: NSFontAttributeName
                       value:[UIFont fontWithName:@"LucidaGrande" size:priceSize]
                       range:priceRange];
    
    [attrString endEditing];
    
    cell.textLabel.attributedText = attrString;
    ((UILabel*)cell.accessoryView).text = [NSString stringWithFormat:@"x%@",item.itemQuantity];
    
    return cell;
}


@end
