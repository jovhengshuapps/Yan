//
//  ConfirmOrderViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 28/04/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "ConfirmOrderViewController.h"
#import "PaymentSelectViewController.h"
#import "DiscountViewController.h"
#import "PayScreenViewController.h"

@interface ConfirmOrderViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (assign, nonatomic) BOOL billoutOrder;
@property (assign, nonatomic) CGFloat totalValue;
@property (strong, nonatomic) NSMutableArray *arrayOrderList;
@property (strong, nonatomic) NSMutableArray *arrayBilloutList;
@property (strong, nonatomic) UILabel *labelTotalValue;

@property (strong, nonatomic) NSMutableDictionary *dictionaryOtherOrders;
@property (strong, nonatomic) NSMutableArray *arrayOtherUsers;

@end

@implementation ConfirmOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.billoutOrder = YES;
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
    
    self.labelTotalValue = [[UILabel alloc] initWithFrame:CGRectMake(labelTotal.bounds.origin.x + labelTotal.bounds.size.width, 0.0f, footerView.bounds.size.width - (labelTotal.bounds.size.width  + 20.0f), 44.0f)];
    self.labelTotalValue.backgroundColor = [UIColor clearColor];
    self.labelTotalValue.font = [UIFont fontWithName:@"LucidaGrande" size:20.0f];
    self.labelTotalValue.textColor = UIColorFromRGB(0x666666);
    self.labelTotalValue.textAlignment = NSTextAlignmentRight;
    self.labelTotalValue.text = [NSString stringWithFormat:@"PHP: %.2f",self.totalValue];
    [totalView addSubview:self.labelTotalValue];
    
    [footerView addSubview:totalView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(20.0f, footerView.bounds.size.height - 44.0f - 10.0f, footerView.bounds.size.width - 20.0f - 20.0f, 44.0f)];
    
    if (self.arrayOrderList.count == 0 && self.arrayBilloutList.count == 0) {
        button.enabled = NO;
        [button setBackgroundColor:UIColorFromRGB(0xDFDFDF)];
        [button setTitle:@". . ." forState:UIControlStateNormal];
    }
    else {
        button.enabled = YES;
        [button setBackgroundColor:UIColorFromRGB(0x000000)];
        if (self.billoutOrder) {
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
    Account *userAccount = [self userLoggedIn];
    [request setPredicate:[NSPredicate predicateWithFormat:@"user_id == %@ AND restaurant_id == %@", userAccount.identifier, userAccount.current_restaurantID]];
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
        
        self.arrayOrderList = [NSMutableArray array];
        self.arrayBilloutList = [NSMutableArray array];
        
        if (self.billoutOrder) {
            for (NSDictionary *bundle in storedOrders) {
                [self.arrayBilloutList addObject:bundle];
            }
        }
        else {
            for (NSDictionary *bundle in storedOrders) {
                for (NSDictionary *item in bundle[@"details"]) {
                    [self.arrayOrderList addObject:item];
                }
            }
            
            NSArray *arrayToSort = [NSArray arrayWithArray:self.arrayOrderList];
            NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:nameDescriptor];
            self.arrayOrderList = [[arrayToSort sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
        }
        
        

    }
    
    //get other orders
    
    NSFetchRequest *requestOthers = [[NSFetchRequest alloc] initWithEntityName:@"OrderList"];
    [requestOthers setReturnsObjectsAsFaults:NO];
    
    [requestOthers setPredicate:[NSPredicate predicateWithFormat:@"user_id <> %@ AND restaurant_id == %@", userAccount.identifier, userAccount.current_restaurantID]];
    error = nil;
    
    NSArray *resultOthers = [NSArray arrayWithArray:[context executeFetchRequest:requestOthers error:&error]];
    if (resultOthers.count) {
        
        self.dictionaryOtherOrders = [NSMutableDictionary dictionary];
        self.arrayOtherUsers = [NSMutableArray array];
        
        for (OrderList *otherOrder in resultOthers) {
            NSArray *storedOrders = [self decodeData:otherOrder.items forKey:@"orderItems"];
            
            for (NSDictionary *menuOrder in storedOrders) {
                self.totalValue += [menuOrder[@"total_amount"] floatValue];
            }
            
            NSDictionary *otherList = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",otherOrder.user_name],@"name",storedOrders,@"items", nil];
            
            [self.dictionaryOtherOrders setObject:otherList forKey:otherOrder.user_id];
            
            [self.arrayOtherUsers addObject:otherOrder.user_id];
            
        }
        
        
//        NSArray *arrayToSort = [NSArray arrayWithArray:self.arrayOrderList];
//        NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
//        NSArray *sortDescriptors = [NSArray arrayWithObject:nameDescriptor];
//        self.arrayOrderList = [[arrayToSort sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
        
        
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
    
//    NSLog(@"####orderList:%@",_arrayOrderList);
    
    /*
     {
     "order_date": "4/26/2016",
     "table": "9",
     "notes": "2 extra rice",
     "menus":[{"menu_id": 1,"quantity": 1,"total_amount": 120},{"menu_id": 2,"quantity": 1,"total_amount": 120}]
     }
     */
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    NSString *order_date = [dateFormatter stringFromDate:[NSDate date]];
    NSMutableString *notes = [NSMutableString stringWithString:@""];
    NSMutableArray *menus = [NSMutableArray array];
    
    for (NSDictionary *items in self.arrayOrderList) {
        if (![items[@"option_choices"] isEqualToString:@"Basic"] && ((NSString*)items[@"option_choices"]).length) {
            [notes appendString:[NSString stringWithFormat:@"%@(%@),",items[@"name"],items[@"option_choices"]]];
        }
        
        
        if (menus.count) {
            BOOL isNew = YES;
            for (NSInteger i = 0; i < menus.count; i++) {
                if ([(menus[i][@"menu_id"]) integerValue] == [items[@"identifier"] integerValue]) {
                    isNew = NO;
                    NSInteger qty = [menus[i][@"quantity"] integerValue] + 1;
                    NSInteger total = [items[@"price"] integerValue] * qty;
                    
                    [menus replaceObjectAtIndex:i withObject:@{@"menu_id":items[@"identifier"],@"quantity":[NSNumber numberWithInteger:qty],@"total_amount":[NSNumber numberWithInteger:total]}];
                    
                    break;
                }
            }
            
            if (isNew) {
                [menus addObject:@{@"menu_id":items[@"identifier"],@"quantity":@1,@"total_amount":items[@"price"]}];
            }
        }
        else {
            [menus addObject:@{@"menu_id":items[@"identifier"],@"quantity":@1,@"total_amount":items[@"price"]}];
        }
        
        
        
    }
    
    
    Account *account = [self userLoggedIn];
    
    if (account.current_orderID.length) {
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(submitOrder:) name:@"submitOrder" object:nil];
        [self callAPI:API_SENDORDERUPDATE(account.current_restaurantID, account.identifier,account.current_orderID) withParameters:@{
                                                                                                       @"order_date": order_date,
                                                                                                       @"table": account.current_tableNumber,
                                                                                                       @"notes": notes,
                                                                                                       @"menus":menus
                                                                                                       } completionNotification:@"submitOrder"];
    }
    else {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(submitOrder:) name:@"submitOrder" object:nil];
        [self callAPI:API_SENDORDER(account.current_restaurantID, account.identifier) withParameters:@{
                                                                                                       @"order_date": order_date,
                                                                                                       @"table": account.current_tableNumber,
                                                                                                       @"notes": notes,
                                                                                                       @"menus":menus
                                                                                                       } completionNotification:@"submitOrder"];
    }
    
}

- (void) submitOrder:(NSNotification*)notification {
    NSDictionary *response = notification.object;
    if (response[@"success"] && response[@"id"]) {
        Account *userAccount = [self userLoggedIn];
        
        NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
        
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OrderList"];
        [request setReturnsObjectsAsFaults:NO];
        
        [request setPredicate:[NSPredicate predicateWithFormat:@"user_id == %@ AND restaurant_id == %@", userAccount.identifier, userAccount.current_restaurantID]];
        
        NSError *error = nil;
        
        NSArray *result = [NSArray arrayWithArray:[context executeFetchRequest:request error:&error]];
        OrderList *order = (OrderList*)result[0];
        
        order.orderSent = @YES;
        order.orderSubmitID = [NSString stringWithFormat:@"%@",response[@"id"]];
        
        error = nil;
        if ([context save:&error]) {
            
            
            userAccount.current_orderID = [NSString stringWithFormat:@"%@",response[@"id"]];
            
            error = nil;
            
            if ([context save:&error]) {
                [self.navigationController popToViewController:[self.navigationController viewControllers][1] animated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderSentNotification" object:nil];
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
}

- (void) callBillout {
//    DiscountViewController *discountView = (DiscountViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"discountView"];
//    discountView.tableNumber = self.tableNumber;
//    [self.navigationController pushViewController:discountView animated:YES];
    
//    PaymentSelectViewController *paymentSelect = (PaymentSelectViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"paymentSelection"];
//    paymentSelect.tableNumber = _tableNumber;
//    [self.navigationController pushViewController:paymentSelect animated:YES];
    
    
    
    
    
    PayScreenViewController *paymentSelect = (PayScreenViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"payScreenView"];
    paymentSelect.tableNumber = _tableNumber;
//    paymentSelect.discountDetails = @{@"senior":self.discountDetails[@"senior"],
//                                      @"gc":self.discountDetails[@"gc"],
//                                      @"diners":self.discountDetails[@"diners"]};
    paymentSelect.paymentType = @"CA";
    [self.navigationController pushViewController:paymentSelect animated:YES];
    
    
}

#pragma mark Table Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.arrayOtherUsers){
        return 1 + [self.arrayOtherUsers count];
    }
        
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.billoutOrder) {
            return self.arrayBilloutList.count;
        }
        return self.arrayOrderList.count;
    }
    else {
        NSString *user_id = self.arrayOtherUsers[section-1];
        return [([self.dictionaryOtherOrders objectForKey:user_id][@"items"]) count];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
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
        if (self.arrayOrderList.count == 0 && self.arrayBilloutList.count == 0) {
            label.text = @"You have no orders yet.";
        }
        else {
            label.text = @"Your Orders";
        }
        
    }
    else {
        NSString *user_id = self.arrayOtherUsers[section-1];
        label.text = [NSString stringWithFormat:@"%@ ordered",[self.dictionaryOtherOrders objectForKey:user_id][@"name"]];
    }
    
    
    [headerView addSubview:label];
    
    return headerView;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if(!self.arrayOtherUsers) {
        return nil;
    }
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.bounds.size.width, 34.0f)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:footerView.frame];
    label.center = footerView.center;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont fontWithName:@"LucidaGrande" size:22.0f];
    label.textColor = [UIColor blackColor];
    
    label.text = @"Sub Total: XX.XX";
    
    
    [footerView addSubview:label];
    
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger section = indexPath.section;
    
    if (section == 0) {
        if (self.billoutOrder) {
            
            OrderListTableViewCell *cell = (OrderListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"billoutListCell"];
            
            NSDictionary *bundle = self.arrayBilloutList[indexPath.row];
            NSArray *details = bundle[@"details"];
            NSDictionary *item = details[0];//doesn't matter which one
            NSString *text = [NSString stringWithFormat:@"%@ PHP%@",[item[@"name"] uppercaseString],item[@"price"]];
            
            CGFloat nameSize = cell.labelItemNamePrice.font.pointSize;
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
            cell.labelItemQuantity.text = [NSString stringWithFormat:@"x%@",bundle[@"quantity"]];
            
            
            return cell;
        }
        else {
            OrderListTableViewCell *cell = (OrderListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"orderListCell"];
            
            NSDictionary *item = self.arrayOrderList[indexPath.row];
            NSString *text = [NSString stringWithFormat:@"%@ PHP%@",[item[@"name"] uppercaseString],item[@"price"]];
            
            CGFloat nameSize = cell.labelItemNamePrice.font.pointSize;
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
            NSString *choices = item[@"option_choices"];
            if ([choices rangeOfString:@","].location != NSNotFound) {
                choices = [choices substringToIndex:choices.length-1];
            }
            cell.labelItemOptions.text = [choices capitalizedString];
            cell.index = indexPath.row;
            cell.delegateCell = self;
            
            
            return cell;
        }
    }
    else {
        
        OrderListTableViewCell *cell = (OrderListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"billoutListCell"];
        
        NSString *user_id = self.arrayOtherUsers[section-1];
        NSArray *itemOrders = [self.dictionaryOtherOrders objectForKey:user_id][@"items"];
        NSDictionary *item = itemOrders[indexPath.row];
        NSString *text = [NSString stringWithFormat:@"%@ PHP%.2f",[item[@"menu_name"] uppercaseString],([item[@"total_amount"] floatValue] / [item[@"quantity"] floatValue])];
        
        CGFloat nameSize = cell.labelItemNamePrice.font.pointSize;
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
        cell.labelItemQuantity.text = [NSString stringWithFormat:@"x%@",item[@"quantity"]];
        
        
        return cell;
    }
    
    
}

- (NSInteger)newItemNumber:(NSInteger)identifier {
    NSInteger newItemNumber = 0;
    for (NSDictionary *item in _arrayOrderList) {
        if ([item[@"identifier"] integerValue] == identifier) {
            newItemNumber++;
        }
    }
    
    return newItemNumber + 1;
}

- (void)duplicateSelectedIndex:(NSInteger)index {
    NSMutableDictionary *itemToDuplicate = [[_arrayOrderList objectAtIndex:index] mutableCopy];
//    NSNumber *itemNumber = [NSNumber numberWithInteger:[self newItemNumber:[itemToDuplicate[@"identifier"] integerValue]]];
//    [itemToDuplicate setObject:itemNumber forKey:@"itemnumber"];
//    NSLog(@"DUPLICATE:%@",itemToDuplicate);
    
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OrderList"];
    [request setReturnsObjectsAsFaults:NO];
    Account *userAccount = [self userLoggedIn];
    [request setPredicate:[NSPredicate predicateWithFormat:@"user_id == %@ AND restaurant_id == %@", userAccount.identifier, userAccount.current_restaurantID]];
    NSError *error = nil;
    
    NSArray *result = [NSArray arrayWithArray:[context executeFetchRequest:request error:&error]];
    
    if (result.count) {
        OrderList *order = (OrderList*)result[0];
        NSMutableArray *newOrderList = [NSMutableArray new];
        NSArray *decodedList = (NSArray*)[self decodeData:order.items forKey:@"orderItems"];
        
        
        [newOrderList addObjectsFromArray:decodedList];
        
        for (NSInteger index = 0; index < decodedList.count; index++) {
            NSMutableDictionary *bundle = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)decodedList[index]];
            if ([bundle[@"identifier"] integerValue] == [itemToDuplicate[@"identifier"] integerValue]) {
               
                NSInteger sum = [bundle[@"quantity"] integerValue] + 1;
                
                NSMutableArray *itemDetails = [NSMutableArray arrayWithArray:(NSArray*)bundle[@"details"]];
                
                NSNumber *itemNumber = [NSNumber numberWithInteger:sum];
                [itemToDuplicate setObject:itemNumber forKey:@"itemnumber"];
                
                NSDictionary *item = itemToDuplicate;
                [itemDetails addObject:item];
                
                [bundle setObject:itemDetails forKey:@"details"];
                
                NSNumber *quantity = [NSNumber numberWithInteger:sum];
                [bundle setObject:quantity forKey:@"quantity"];
                
                [newOrderList replaceObjectAtIndex:index withObject:bundle];
            }
        }
        
        
        order.items = [self encodeData:newOrderList withKey:@"orderItems"];
        order.orderSent = @NO;
        order.tableNumber = self.tableNumber;
        
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
            
            [self.arrayOrderList addObject:itemToDuplicate];
            
            NSArray *arrayToSort = [NSArray arrayWithArray:self.arrayOrderList];
            NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:nameDescriptor];
            self.arrayOrderList = [[arrayToSort sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
            
            [_mainTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }

    }
    
    self.totalValue += [itemToDuplicate[@"price"] floatValue];
    
    self.labelTotalValue.text = [NSString stringWithFormat:@"PHP: %.2f",self.totalValue];
    
    
}

- (void)removeSelectedIndex:(NSInteger)index {
    NSDictionary *itemToRemove = [_arrayOrderList objectAtIndex:index];
//    NSLog(@"item:%@",itemToRemove);
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OrderList"];
    [request setReturnsObjectsAsFaults:NO];
    Account *userAccount = [self userLoggedIn];
    [request setPredicate:[NSPredicate predicateWithFormat:@"user_id == %@ AND restaurant_id == %@", userAccount.identifier, userAccount.current_restaurantID]];
    NSError *error = nil;
    
    NSArray *result = [NSArray arrayWithArray:[context executeFetchRequest:request error:&error]];
    if (result.count) {
        OrderList *order = (OrderList*)result[0];
        NSMutableArray *newOrderList = [NSMutableArray new];
        NSArray *decodedList = (NSArray*)[self decodeData:order.items forKey:@"orderItems"];
        
        
        [newOrderList addObjectsFromArray:decodedList];
        
        for (NSInteger index = 0; index < decodedList.count; index++) {
            NSMutableDictionary *bundle = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)decodedList[index]];
            
            if ([bundle[@"identifier"] integerValue] == [itemToRemove[@"identifier"] integerValue]) {
                
                NSMutableArray *itemDetails = [NSMutableArray arrayWithArray:(NSArray*)bundle[@"details"]];
                
                [itemDetails removeObject:itemToRemove];
                
                [bundle setObject:itemDetails forKey:@"details"];
                
                NSInteger diff = [bundle[@"quantity"] integerValue] - 1;
                if (diff > 0) {
                    NSNumber *quantity = [NSNumber numberWithInteger:diff];
                    [bundle setObject:quantity forKey:@"quantity"];
                    
                    [newOrderList replaceObjectAtIndex:index withObject:bundle];
                }
                else {
                    [newOrderList removeObjectAtIndex:index];
                }
                break;
            }
        }
        
        
        order.items = [self encodeData:newOrderList withKey:@"orderItems"];
        
        order.orderSent = @NO;
        order.tableNumber = _tableNumber;
        
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
            
            [_arrayOrderList removeObjectAtIndex:index];
            
            [_mainTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            
        }
    }
    
    self.totalValue -= [itemToRemove[@"price"] floatValue];
    
    self.labelTotalValue.text = [NSString stringWithFormat:@"PHP: %.2f",self.totalValue];
    
}


@end
