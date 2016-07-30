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

@property (strong, nonatomic) NSMutableDictionary *dictionaryOtherOrders;
@property (strong, nonatomic) NSMutableArray *arrayOtherUsers;

@property (assign, nonatomic) NSInteger discountSection;

@end

@implementation PayScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    _showSubTotal = NO;
    _mainTable.allowsSelection = NO;
    
    self.totalValue = 0.0f;
    [self fetchOrderDataList];
        
    
//    if (_discountDetails) {
//        _showSubTotal = YES;
//    }
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, KEYWINDOW.frame.size.width+5.0f, 110.0f)];
    footerView.backgroundColor = UIColorFromRGB(0xDFDFDF);
    
    UIView *totalView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, footerView.bounds.size.width, 44.0f)];
    totalView.backgroundColor = UIColorFromRGB(0x333333);
    
    UILabel *labelTotal = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 120.0f, 44.0f)];
    labelTotal.backgroundColor = [UIColor clearColor];
    labelTotal.font = [UIFont fontWithName:@"LucidaGrande" size:16.0f];
    labelTotal.textColor = UIColorFromRGB(0x666666);
    labelTotal.textAlignment = NSTextAlignmentLeft;
    labelTotal.text = @"TOTAL w/ VAT:";
    [totalView addSubview:labelTotal];
    
    UILabel *labelTotalValue = [[UILabel alloc] initWithFrame:CGRectMake(labelTotal.bounds.origin.x + labelTotal.bounds.size.width, 0.0f, footerView.bounds.size.width - (labelTotal.bounds.size.width  + 20.0f), 44.0f)];
    labelTotalValue.backgroundColor = [UIColor clearColor];
    labelTotalValue.font = [UIFont fontWithName:@"LucidaGrande" size:20.0f];
    labelTotalValue.textColor = UIColorFromRGB(0x666666);
    labelTotalValue.textAlignment = NSTextAlignmentRight;
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
    
    CGFloat seniorDiscount = 0.0f;
    CGFloat gcDiscount = 0.0f;
    CGFloat vat = self.totalValue * 0.12;
    if(_discountDetails) {
        if (![_discountDetails[@"senior"] isEqualToString:@"0"]) {
            
            seniorDiscount = (self.totalValue / [_discountDetails[@"diners"] floatValue]) * 0.2;
            seniorDiscount = seniorDiscount * [_discountDetails[@"senior"] floatValue];
            
            
        }
        else if (![_discountDetails[@"gc"] isEqualToString:@"0"]) {
            
            gcDiscount = self.totalValue * ([_discountDetails[@"gc"] floatValue]/100.0f);
            
        }
        
        
    }
    
    self.totalValue = (self.totalValue + vat) - (seniorDiscount + gcDiscount);
    
    labelTotalValue.text = [NSString stringWithFormat:@"PHP: %.2f",self.totalValue];
    
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
    self.totalValue = 0.0f;
    self.dictionaryOtherOrders = [NSMutableDictionary dictionary];
    self.arrayOtherUsers = [NSMutableArray array];
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OrderList"];
    [request setReturnsObjectsAsFaults:NO];
    Account *userAccount = [self userLoggedIn];
    [request setPredicate:[NSPredicate predicateWithFormat:@"restaurant_id == %@", userAccount.current_restaurantID]];
    NSError *error = nil;
    
    NSArray *result = [NSArray arrayWithArray:[context executeFetchRequest:request error:&error]];
    if (result.count) {
        for (OrderList *order in result) {
            
            if ([order.user_id integerValue] == [userAccount.identifier integerValue]) {
                
                //check if billout
//                self.billoutOrder = [order.orderSent boolValue];
                
                NSArray *storedOrders = [self decodeData:order.items forKey:@"orderItems"];
                
                self.arrayOrderList = [NSMutableArray array];
//                NSMutableArray *menus = [NSMutableArray array];
                for (NSDictionary *item in storedOrders) {
                    NSLog(@"item:%@",item);
                    
                    
//                    if (menus.count) {
//                        BOOL isNew = YES;
//                        for (NSInteger i = 0; i < menus.count; i++) {
//                            if ([(menus[i][@"menu_id"]) integerValue] == [item[@"details"][0][@"identifier"] integerValue]) {
//                                isNew = NO;
//                                NSLog(@"menu:%@",menus[i]);
//                                NSInteger qty = [menus[i][@"quantity"] integerValue] + 1;
//                                NSInteger total = [item[@"details"][0][@"price"] integerValue] * qty;
//                                
//                                NSString *options = [NSString stringWithFormat:@"%@, %@(%@);",menus[i][@"options"],item[@"details"][0][@"name"],item[@"details"][0][@"option_choices"]];
//                                [menus replaceObjectAtIndex:i withObject:@{@"menu_id":item[@"details"][0][@"identifier"],@"quantity":[NSNumber numberWithInteger:qty],@"total_amount":[NSNumber numberWithInteger:total],@"options":options}];
//                                
//                                break;
//                            }
//                        }
//                        
//                        if (isNew) {
//                            NSString *options = [NSString stringWithFormat:@"%@(%@);",item[@"details"][0][@"name"],item[@"details"][0][@"option_choices"]];
//                            [menus addObject:@{@"menu_id":item[@"details"][0][@"identifier"],@"quantity":@1,@"total_amount":item[@"details"][0][@"price"], @"options":options}];
//                        }
//                    }
//                    else {
//                        NSString *options = [NSString stringWithFormat:@"%@(%@);",item[@"details"][0][@"name"],item[@"details"][0][@"option_choices"]];
//                        [menus addObject:@{@"menu_id":item[@"details"][0][@"identifier"],@"quantity":@1,@"total_amount":item[@"details"][0][@"price"], @"options":options}];
//                    }
                    
                    self.totalValue += ([item[@"total_amount"] floatValue] * [item[@"quantity"] floatValue]);
                    [self.arrayOrderList addObject:item];
                    
                }
                    NSArray *arrayToSort = [NSArray arrayWithArray:self.arrayOrderList];
                    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"menu_name" ascending:YES];
                    NSArray *sortDescriptors = [NSArray arrayWithObject:nameDescriptor];
                    self.arrayOrderList = [[arrayToSort sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
                
            }
            else {
                
                
                //get other orders
                
                
                
                NSArray *storedOrders = [self decodeData:order.items forKey:@"orderItems"];
                
                for (NSDictionary *menuOrder in storedOrders) {
                    self.totalValue += [menuOrder[@"total_amount"] floatValue];
                }
                
                NSDictionary *otherList = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",order.user_name],@"name",storedOrders,@"items", nil];
                
                [self.dictionaryOtherOrders setObject:otherList forKey:order.user_id];
                //                NSLog(@"others[%@] - %@",order.user_id,otherList);
                [self.arrayOtherUsers addObject:order.user_id];
            }
            
        }
        
        
    }
    
    
    
    
}

//- (void) fetchOrderDataList {
//    
//    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
//    
//    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OrderList"];
//    [request setReturnsObjectsAsFaults:NO];
//    Account *userAccount = [self userLoggedIn];
//    [request setPredicate:[NSPredicate predicateWithFormat:@"user_id == %@ AND restaurant_id == %@", userAccount.identifier, userAccount.current_restaurantID]];
//    NSError *error = nil;
//    
//    NSArray *result = [NSArray arrayWithArray:[context executeFetchRequest:request error:&error]];
//    if (result.count) {
//        OrderList *order = (OrderList*)result[0];
//        
//        NSArray *storedOrders = [self decodeData:order.items forKey:@"orderItems"];
//        
//        for (NSDictionary *bundle in storedOrders) {
//            self.totalValue += ([bundle[@"details"][0][@"price"] floatValue] * [bundle[@"quantity"] floatValue]);
//        }
//        
//        _arrayOrderList = [NSMutableArray new];
//
//        
//        for (NSDictionary *item in storedOrders) {
////            NSLog(@"storedITEM:%@",item);
//            [_arrayOrderList addObject:item];
//        }
//        
//
//    }
//    
//    
//    
//    //get other orders
//    
//    NSFetchRequest *requestOthers = [[NSFetchRequest alloc] initWithEntityName:@"OrderList"];
//    [requestOthers setReturnsObjectsAsFaults:NO];
//    
//    [requestOthers setPredicate:[NSPredicate predicateWithFormat:@"user_id != %@ AND restaurant_id == %@", userAccount.identifier, userAccount.current_restaurantID]];
//    error = nil;
//    
//    NSArray *resultOthers = [NSArray arrayWithArray:[context executeFetchRequest:requestOthers error:&error]];
//    if (resultOthers.count) {
//        
//        self.dictionaryOtherOrders = [NSMutableDictionary dictionary];
//        self.arrayOtherUsers = [NSMutableArray array];
//        
//        for (OrderList *otherOrder in resultOthers) {
//            NSArray *storedOrders = [self decodeData:otherOrder.items forKey:@"orderItems"];
//            
//            for (NSDictionary *menuOrder in storedOrders) {
//                self.totalValue += [menuOrder[@"total_amount"] floatValue];
//            }
//            
//            NSDictionary *otherList = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",otherOrder.user_name],@"name",storedOrders,@"items", nil];
//            
//            [self.dictionaryOtherOrders setObject:otherList forKey:otherOrder.user_id];
//            
//            [self.arrayOtherUsers addObject:otherOrder.user_id];
//            
//        }
//        
//        
//        //        NSArray *arrayToSort = [NSArray arrayWithArray:self.arrayOrderList];
//        //        NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
//        //        NSArray *sortDescriptors = [NSArray arrayWithObject:nameDescriptor];
//        //        self.arrayOrderList = [[arrayToSort sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
//        
//        
//    }
//    
//}

//- (BOOL) containsMenuItem:(MenuItem*)item index:(NSInteger*)index{
//    BOOL result = NO;
//    for (NSInteger i = 0; i < _arrayOrderList.count; i++) {
//        NSDictionary *content = (NSDictionary*)_arrayOrderList[i];
//        if ([content[@"identifier"] isEqualToNumber:item.identifier]) {
//            result = YES;
//            index = &i;
//            break;
//        }
//    }
//    
//    return result;
//}

- (void) submitPayment {
    
    
    Account *account = [self userLoggedIn];
    
    
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OrderList"];
    [request setReturnsObjectsAsFaults:NO];
    Account *userAccount = [self userLoggedIn];
    [request setPredicate:[NSPredicate predicateWithFormat:@"user_id == %@ AND restaurant_id == %@", userAccount.identifier, userAccount.current_restaurantID]];
    
    NSError *error = nil;
    
    NSArray *result = [NSArray arrayWithArray:[context executeFetchRequest:request error:&error]];
    OrderList *order = (OrderList*)result[0];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendPaymentToCounter:) name:@"sendPaymentToCounter" object:nil];
    [self callAPI:API_BILLOUT(account.current_restaurantID, order.orderSubmitID) withParameters:@{ @"pay_type": self.paymentType, @"total_amount": [NSNumber numberWithFloat:self.totalValue] }completionNotification:@"sendPaymentToCounter"];
    
    
}

- (void) sendPaymentToCounter:(NSNotification*)notification {
    NSLog(@"response:%@",notification.object);
    AlertView *alert = [[AlertView alloc] initAlertWithMessage:@"Our restaurant representative will see you to receive payment.\n\n Thank you!" delegate:self buttons:@[@"CLOSE"]];
    [alert showAlertView];
}

- (void)alertView:(AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OrderList"];
    NSError *error = nil;
    Account *loggedUSER = [self userLoggedIn];
    [request setPredicate:[NSPredicate predicateWithFormat:@"user_id == %@ AND restaurant_id == %@", loggedUSER.identifier, loggedUSER.current_restaurantID]];
    
    NSArray *result = [NSArray arrayWithArray:[context executeFetchRequest:request error:&error]];
    if (result.count) {
        OrderList *order = (OrderList*)result[0];
        [context deleteObject:order];
    }
    
    error = nil;
    if ([context save:&error]) {
        
        NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
        
        loggedUSER.current_restaurantID = @"";
        loggedUSER.current_tableNumber = @"";
        loggedUSER.current_restaurantName = @"";
        
        error = nil;
        if (![context save:&error]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Error %li",(long)[error code]] message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:actionOK];
            
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }
        else {
            
            [self.navigationController popToRootViewControllerAnimated:YES];
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

#pragma mark Table Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger otherUserCount = 0;
    if (self.arrayOtherUsers) {
        otherUserCount = [self.arrayOtherUsers count];
    }
    self.discountSection = -1;
    if (_discountDetails && (![_discountDetails[@"senior"] isEqualToString:@"0"] || ![_discountDetails[@"gc"] isEqualToString:@"0"])) {
        self.discountSection = 2 + otherUserCount;
        return 2 + otherUserCount;
    }
    return 1 + otherUserCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == self.discountSection) {
        NSInteger count = 0;
        if (_discountDetails[@"senior"] && ![_discountDetails[@"senior"] isEqualToString:@"0"]) {
            count = count + 1;
        }
        
        if (_discountDetails[@"gc"] && ![_discountDetails[@"gc"] isEqualToString:@"0"]) {
            count = count + 1;
        }
        return count;
    }
    else if (section == 0) {
//        NSLog(@"orderList:%@",self.arrayOrderList);
        return self.arrayOrderList.count;
    }
    else {
        NSString *user_id = self.arrayOtherUsers[section-1];
        return [([self.dictionaryOtherOrders objectForKey:user_id][@"items"]) count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (/*!self.discountDetails &&*/!self.arrayOtherUsers || [self.arrayOtherUsers count] == 0) {
        return 0;
    }
    return 34.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 34.0f;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.bounds.size.width, 34.0f)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:headerView.frame];
    label.center = headerView.center;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"LucidaGrande" size:22.0f];
    label.textColor = [UIColor blackColor];
    
    if(section == 0) {
            label.text = @"Your Orders";
        
        
    }
    else {
        NSString *user_id = self.arrayOtherUsers[section-1];
        label.text = [NSString stringWithFormat:@"%@ ordered",[self.dictionaryOtherOrders objectForKey:user_id][@"name"]];
    }
    
    
    [headerView addSubview:label];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (/*!self.discountDetails && */!self.arrayOtherUsers || [self.arrayOtherUsers count] == 0) {
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
//    labelPrice.text = [NSString stringWithFormat:@"%.2f",self.totalValue];
    
    [headerView addSubview:labelPrice];
    
    
    
    CGFloat subTotal = 0.0f;
    
    if (section == 0) {
        
        for (NSDictionary *item in self.arrayOrderList) {
            
            subTotal += ([item[@"total_amount"] floatValue] * [item[@"quantity"] floatValue]);
        }
    }
    else {
        
        NSString *user_id = self.arrayOtherUsers[section-1];
        NSArray *items = [self.dictionaryOtherOrders objectForKey:user_id][@"items"];
        
        for (NSDictionary *menuItem in items) {
            subTotal += [menuItem[@"total_amount"] floatValue];
        }
    }
    
    
    labelPrice.text = [NSString stringWithFormat:@"PHP %.2f",subTotal];
    
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section != self.discountSection) {
        
        OrderListTableViewCell *cell = (OrderListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"orderListCell"];
        
        NSDictionary *item = nil;
//        NSDictionary *bundle = nil;
        NSString *text = @"";
        
        if (indexPath.section == 0) {
            item = self.arrayOrderList[indexPath.row];
            text = [NSString stringWithFormat:@"%@ PHP%@",[item[@"menu_name"] uppercaseString],item[@"total_amount"]];
            
        }
        else {
            NSString *user_id = self.arrayOtherUsers[indexPath.section-1];
            NSArray *itemOrders = [self.dictionaryOtherOrders objectForKey:user_id][@"items"];
            item = itemOrders[indexPath.row];
            text = [NSString stringWithFormat:@"%@ PHP%.2f",[item[@"menu_name"] uppercaseString],([item[@"total_amount"] floatValue] / [item[@"quantity"] floatValue])];
        }
        
        
        CGFloat nameSize = cell.labelItemNamePrice.font.pointSize; //[self tableView:tableView heightForRowAtIndexPath:indexPath] - 20.0f;
        CGFloat priceSize = nameSize / 2.0f;
        
        NSArray *components = [text componentsSeparatedByString:@" PHP"];
        NSRange nameRange = [text rangeOfString:[components objectAtIndex:0]];
        NSRange priceRange = [text rangeOfString:[components objectAtIndex:1]];
        
        nameRange = NSMakeRange(nameRange.location, nameRange.length - 3);
        priceRange = NSMakeRange(priceRange.location-3, priceRange.length+3);
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
        
        [attrString beginEditing];
        [attrString addAttribute: NSFontAttributeName
                           value:[UIFont fontWithName:@"LucidaGrande" size:nameSize]
                           range:nameRange];
        
        [attrString addAttribute: NSFontAttributeName
                           value:[UIFont fontWithName:@"LucidaGrande" size:priceSize]
                           range:priceRange];
        
        [attrString endEditing];
        
        cell.labelItemNamePrice.attributedText = attrString;
        if (indexPath.section == 0) {
            cell.labelItemQuantity.text = [NSString stringWithFormat:@"x%@",item[@"quantity"]];
            
        }
        else {
            cell.labelItemQuantity.text = [NSString stringWithFormat:@"x%@",item[@"quantity"]];
            
        }
        
        
        return cell;
    }
    else {

        DiscountListTableViewCell *cell = (DiscountListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"discountListCell"];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_PH"];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyISOCodeStyle];
        
        NSString *string = @"";
        CGFloat seniorDiscount = 0.0f;
        CGFloat gcDiscount = 0.0f;
        if (![_discountDetails[@"senior"] isEqualToString:@"0"] && indexPath.row == 0) {
            cell.labelDiscountTitle.text = [NSString stringWithFormat:@"Senior Citizen: x%@",_discountDetails[@"senior"]];
            
            seniorDiscount = (self.totalValue / [_discountDetails[@"diners"] floatValue]) * 0.2;
            seniorDiscount = seniorDiscount * [_discountDetails[@"senior"] floatValue];
            
            
            string = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:seniorDiscount]];
        }
        else if (![_discountDetails[@"gc"] isEqualToString:@"0%"]) {
            cell.labelDiscountTitle.text = [NSString stringWithFormat:@"Gift Certificate: %@%%",_discountDetails[@"gc"]];
            
            gcDiscount = self.totalValue * ([_discountDetails[@"gc"] floatValue]/100.0f);
            
            string = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:gcDiscount]];
        }
        
        cell.labelDiscountValue.text = [NSString stringWithFormat:@"-%@",string];
        return cell;
    }
    
}

@end
