//
//  ConfirmOrderViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 28/04/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "ConfirmOrderViewController.h"
#import "PaymentSelectViewController.h"
#import "OrderListTableViewCell.h"

@interface ConfirmOrderViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (assign, nonatomic) BOOL billoutOrder;
@property (assign, nonatomic) CGFloat totalValue;
@property (strong, nonatomic) NSMutableArray *arrayOrderList;

@end

@implementation ConfirmOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _billoutOrder = YES;
    _mainTable.allowsSelection = NO;
    
    self.totalValue = 0.0f;
    
    [self fetchOrderDataList];
    
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
    labelTotalValue.text = [NSString stringWithFormat:@"PHP: %.2f",_totalValue];
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
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    
    NSArray *result = [NSArray arrayWithArray:[context executeFetchRequest:request error:&error]];
    if (result.count) {
        OrderList *order = (OrderList*)result[0];
        
        //check if billout
        self.billoutOrder = [order.orderSent boolValue];
        
        NSArray *storedOrders = [self decodeData:order.items forKey:@"orderItems"];
        
        for (NSDictionary *bundle in storedOrders) {
            self.totalValue += ([bundle[@"details"][0][@"price"] floatValue] * [bundle[@"quantity"] floatValue]);
        }
        
        _arrayOrderList = [NSMutableArray new];
        
        for (NSDictionary *bundle in storedOrders) {
            [_arrayOrderList addObject:bundle];
        }
    }
    
    
    
}

//- (BOOL) containsMenuItemIdentifier:(NSNumber*)itemIdentifier index:(NSInteger*)index{
//    BOOL result = NO;
//    for (NSInteger i = 0; i < _arrayOrderList.count; i++) {
//        NSDictionary *content = (NSDictionary*)_arrayOrderList[i];
//        if ([content[@"identifier"] integerValue] == [itemIdentifier integerValue]) {
//            result = YES;
//            NSLog(@"index->%li",(long)i);
//            *index = i;
//            break;
//        }
//    }
//    
//    return result;
//}

- (void) orderSentToServer {
    //call api
    
    NSLog(@"####orderList:%@",_arrayOrderList);
    
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OrderList"];
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *result = [NSArray arrayWithArray:[context executeFetchRequest:request error:&error]];
    OrderList *order = (OrderList*)result[0];
    
    order.orderSent = @YES;
    
    error = nil;
    if ([context save:&error]) {
        
        [self.navigationController popToViewController:[self.navigationController viewControllers][2] animated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderSentNotification" object:nil];
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
    
    NSDictionary *bundle = _arrayOrderList[indexPath.row];
    NSArray *details = bundle[@"details"];
    NSDictionary *item = details[0];//doesn't matter which one
    NSString *text = [NSString stringWithFormat:@"%@ PHP%@",[item[@"name"] uppercaseString],item[@"price"]];
    
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
    
    OrderListTableViewCell *cell = (OrderListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"orderListCell"];
    cell.labelItemNamePrice.attributedText = attrString;
    cell.labelItemQuantity.text = [NSString stringWithFormat:@"x%@",bundle[@"quantity"]];
    
    return cell;
    
}


@end
