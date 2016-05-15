//
//  PayScreenViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 10/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "PayScreenViewController.h"
#import "OrderListTableViewCell.h"
#import "DiscountListTableViewCell.h"

@interface PayScreenViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (strong, nonatomic) NSMutableArray *arrayOrderList;
@property (assign, nonatomic) BOOL showSubTotal;
@property (assign, nonatomic) CGFloat totalValue;

@end

@implementation PayScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _showSubTotal = NO;
    _mainTable.allowsSelection = NO;
    
    self.totalValue = 0.0f;
    [self fetchOrderDataList];
    
    
    
    
    
    
    if (_discountDetails) {
        _showSubTotal = YES;
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
    labelTotalValue.text = [NSString stringWithFormat:@"PHP: %.2f",_totalValue];
    [totalView addSubview:labelTotalValue];
    
    [footerView addSubview:totalView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(20.0f, footerView.bounds.size.height - 44.0f - 10.0f, footerView.bounds.size.width - 20.0f - 20.0f, 44.0f)];
        [button setTitle:@"Pay" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(submitPayment) forControlEvents:UIControlEventTouchUpInside];
    
    
    button.titleLabel.font = [UIFont fontWithName:@"LucidaGrande" size:20.0f];
    button.titleLabel.textColor = UIColorFromRGB(0xFFFFFF);
    
    [button setBackgroundColor:UIColorFromRGB(0x000000)];
    [footerView addSubview:button];
    
    [_mainTable setTableFooterView:footerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showTitleBar:[NSString stringWithFormat:@"Bill: Table %@",_tableNumber]];
}


- (void) fetchOrderDataList {
    
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OrderList"];
    
    NSError *error = nil;
    
    NSArray *result = [NSArray arrayWithArray:[context executeFetchRequest:request error:&error]];
    if (result.count) {
        OrderList *order = (OrderList*)result[0];
        
        NSArray *storedOrders = [self decodeMenuList:order.items forKey:@"orderItems"];
        
        for (MenuItem *items in storedOrders) {
            self.totalValue += [items.price floatValue];
        }
        
        _arrayOrderList = [NSMutableArray new];
        
        for (MenuItem *item in storedOrders) {
            NSInteger index = 0;
            if ([self containsMenuItem:item index:&index]) {
                NSMutableDictionary *content = _arrayOrderList[index];
                NSNumber *quantity = @([content[@"quantity"] integerValue] + 1);
                content[@"quantity"] = quantity;
                [_arrayOrderList replaceObjectAtIndex:index withObject:content];
            }
            else {
                NSDictionary *content = @{@"identifier":item.identifier,
                                          @"details":item,
                                          @"quantity":@1
                                          };
                [_arrayOrderList addObject:content];
            }
        }

    }
    
    
}

- (BOOL) containsMenuItem:(MenuItem*)item index:(NSInteger*)index{
    BOOL result = NO;
    for (NSInteger i = 0; i < _arrayOrderList.count; i++) {
        NSDictionary *content = (NSDictionary*)_arrayOrderList[i];
        if ([content[@"identifier"] isEqualToNumber:item.identifier]) {
            result = YES;
            index = &i;
            break;
        }
    }
    
    return result;
}

- (void) submitPayment {
    AlertView *alert = [[AlertView alloc] initAlertWithMessage:@"Our restaurant representative will see you to receive payment.\n\n Thank you!" delegate:self buttons:@[@"CLOSE"]];
    [alert showAlertView];
}


- (void)alertView:(AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    for (OrderList *item in _arrayOrderList) {
        [context deleteObject:item];
    }
    
    NSError *error = nil;
    if ([context save:&error]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Technical Data Error" message:@"Please try again." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:actionOK];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
}

#pragma mark Table Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_discountDetails) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_discountDetails) {
        NSInteger count = 0;
        if (_discountDetails[@"senior"]) {
            count+=1;
        }
        else if (_discountDetails[@"gc"]) {
            count+=1;
        }
        return count;
    }
    return _arrayOrderList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 34.0f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.bounds.size.width, 34.0f)];
    headerView.backgroundColor = UIColorFromRGB(0xDFDFDF);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 0.0f, 100.0f, headerView.frame.size.height)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont fontWithName:@"LucidaGrande" size:16.0f];
    label.textColor = UIColorFromRGB(0x363636);
        label.text = @"Sub-total:";
    
    [headerView addSubview:label];
    
    
    UILabel *labelPrice = [[UILabel alloc] initWithFrame:CGRectMake(label.bounds.origin.x + label.bounds.size.width + 15.0f, 0.0f, headerView.frame.size.width - 30.0f - label.bounds.size.width, headerView.frame.size.height)];
    labelPrice.backgroundColor = [UIColor clearColor];
    labelPrice.textAlignment = NSTextAlignmentRight;
    labelPrice.font = [UIFont fontWithName:@"LucidaGrande" size:16.0f];
    labelPrice.textColor = UIColorFromRGB(0x363636);
    labelPrice.text = [NSString stringWithFormat:@"%.2f",self.totalValue];
    
    [headerView addSubview:labelPrice];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        
        NSDictionary *content = _arrayOrderList[indexPath.row];
        MenuItem *item = content[@"details"];
        NSString *text = [NSString stringWithFormat:@"%@ PHP%@",[item.name uppercaseString],item.price];
        
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
        cell.labelItemQuantity.text = [NSString stringWithFormat:@"x%@",content[@"quantity"]];
        
        return cell;
    }
    else {

        DiscountListTableViewCell *cell = (DiscountListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"discountListCell"];
        cell.labelDiscountTitle.text = [NSString stringWithFormat:@"Senior Citizen: x%@",_discountDetails[@"senior"]];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_PH"];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyISOCodeStyle];
        
        NSString *string = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:(self.totalValue * 0.2)]];
        cell.labelDiscountValue.text = [NSString stringWithFormat:@"-%@",string];
        
        return cell;
    }
    
}

@end
