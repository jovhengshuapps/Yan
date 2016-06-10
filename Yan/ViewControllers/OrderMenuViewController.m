//
//  OrderMenuViewController.m
//  Yan
//
//  Created by IOS Developer on 05/04/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "OrderMenuViewController.h"
#import "MenuListViewController.h"
#import "ConfirmOrderViewController.h"
#import "WaiterTableViewController.h"


BOOL hackFromLoad = NO;

@interface OrderMenuViewController()

@property(strong,nonatomic) NSDictionary *rawData;
@property (strong, nonatomic) NSArray *arrayCategories;
@property (weak, nonatomic) IBOutlet UIView *orderCheckoutView;
@property (strong, nonatomic) UITableView *mainTableView;
@property (assign, nonatomic) BOOL menuShown;
@property (weak, nonatomic) IBOutlet UIButton *orderTableButton;
@property (weak, nonatomic) IBOutlet UIButton *orderCostButton;
@property (weak, nonatomic) IBOutlet UIView *loadedControllerView;
@property (strong, nonatomic) NSString *categoryString;
@property (strong, nonatomic) NSString *orderTableNumber;
@property (assign, nonatomic) CGFloat totalOrderPrice;
@property (weak, nonatomic) IBOutlet UIView *orderSentView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (assign, nonatomic) BOOL menuIsLoading;

@end

@implementation OrderMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    
    UIBarButtonItem *waiterBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"waiter-icon-resized.png"] style:UIBarButtonItemStyleDone target:self action:@selector(callWaiter)];
    
    [[self navigationItem] setRightBarButtonItem:waiterBarItem];
    
    
    _orderTableNumber = @"1";
    [self.orderTableButton setTitle:[NSString stringWithFormat:@"Order Table: %@",_orderTableNumber] forState:UIControlStateNormal];
    
    
    
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OrderList"];
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    
    NSArray *result = [NSArray arrayWithArray:[context executeFetchRequest:request error:&error]];
    
    _totalOrderPrice = 0.0f;
    
    if (result.count) {
        OrderList *order = (OrderList*)result[0];
        
        NSArray *storedOrders = [self decodeData:order.items forKey:@"orderItems"];
        
        
        for (NSDictionary *bundle in storedOrders) {
//            NSLog(@"bundle:%@",bundle);
            self.totalOrderPrice += ([bundle[@"details"][0][@"price"] floatValue] * [bundle[@"quantity"] floatValue]);
        }

    }
    
    [self setTotalPrice:_totalOrderPrice];
    _orderTableButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _orderCostButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _orderCostButton.titleLabel.minimumScaleFactor = -5.0f;
    _orderTableButton.titleLabel.minimumScaleFactor = -5.0f;
    
    
    
    Account *loggedUSER = [self userLoggedIn];
    NSInteger restaurantID = [loggedUSER.current_restaurantID integerValue];
    self.tableNumber = loggedUSER.current_tableNumber;
    
    self.mainTableView.userInteractionEnabled = NO;
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    self.menuIsLoading = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuForRestaurant:) name:@"getMenuForRestaurantObserver" object:nil];
    [self callGETAPI:API_MENU(restaurantID) withParameters:@{} completionNotification:@"getMenuForRestaurantObserver"];
    
    
//    CGFloat hackHeight = self.view.frame.size.height - 64.0f; //nav plus status bar
//    
//    CGFloat positionY = hackHeight - (self.orderCheckoutView.bounds.origin.y +  self.orderCheckoutView.bounds.size.height);
//    CGFloat sizeHeight = (44.0f * _arrayCategories.count) + 44.0f; /*height of row and section*/
//    positionY -= sizeHeight;
//    
//    CGFloat maxY = self.loadedControllerView.bounds.origin.y - 10.0f;
//    CGFloat minY = self.navigationController.navigationBar.frame.size.height;
//    CGFloat maxHeight = hackHeight - (self.orderCheckoutView.bounds.origin.y +  self.orderCheckoutView.bounds.size.height);
//    
//    if (positionY < maxY) {
//        positionY = minY;
//        sizeHeight = maxHeight;
//    }
//    
//    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, positionY, self.view.frame.size.width, sizeHeight) style:UITableViewStylePlain];
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _mainTableView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.bounces = NO;
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    [self.view addSubview:_mainTableView];
    _menuShown = NO;
    [_mainTableView reloadData];
    hackFromLoad = YES;
    _categoryString = @"";
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showOrderSentView) name:@"OrderSentNotification" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showTitleBar:_categoryString];
//    if (hackFromLoad) {
//        
//    }
//    else {
        [self showMenu];
        hackFromLoad = NO;
//    }
    
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OrderList"];
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    
    NSArray *result = [NSArray arrayWithArray:[context executeFetchRequest:request error:&error]];
    if (result.count) {
        OrderList *order = (OrderList*)result[0];
                
        NSArray *storedOrders = [self decodeData:order.items forKey:@"orderItems"];
        
        self.totalOrderPrice = 0.0f;
        for (NSDictionary *bundle in storedOrders) {
            self.totalOrderPrice += ([bundle[@"details"][0][@"price"] floatValue] * [bundle[@"quantity"] floatValue]);
        }
    }
    
    [self setTotalPrice:self.totalOrderPrice];
    
}

- (void) menuForRestaurant:(NSNotification*)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification.name object:nil];
    
    if ([notification.object isKindOfClass:[NSError class]] || ([notification.object isKindOfClass:[NSDictionary class]] && [[((NSDictionary*)notification.object) allKeys] containsObject:@"error"])) {
        return;
    }
    else {
        
        NSDictionary *response = (NSDictionary*)notification.object;
        self.categories = response[@"categories"];
        
        //    NSLog(@"self.categories:%@",self.categories);
        
        _rawData = [self extractMenuContent];
        _menuShown = YES;
        self.mainTableView.userInteractionEnabled = YES;
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
        self.menuIsLoading = NO;
        [self.mainTableView reloadData];
        [self showMenu];
    }
}

- (void) showOrderSentView {
    self.orderSentView.hidden = NO;
    [self showTitleBar:@""];
}

- (void) callWaiter {
    WaiterTableViewController *waiter = (WaiterTableViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"waiterOptions"];
    [self.navigationController pushViewController:waiter animated:YES];
}

- (void) setTotalPrice:(CGFloat)price {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_PH"];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyISOCodeStyle];
    
    NSString *string = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:price]];
    [self.orderCostButton setTitle:string forState:UIControlStateNormal];
}

- (NSDictionary*) extractMenuContent {
    NSMutableDictionary *data = [NSMutableDictionary new];
    NSMutableArray *categories = [NSMutableArray new];
    
    for (NSDictionary *category in self.categories) {
        NSString *categoryName = [category objectForKey:@"name"];
        [categories addObject:categoryName];
        NSMutableArray *categoryItems = [NSMutableArray new];
        for (NSDictionary *item in [category objectForKey:@"menu"]) {
            MenuItem *menuItem = [self insertMenuToDatabase:item];
//            NSLog(@"item:%@ | menu:%@",item[@"name"],menuItem.name);
            [categoryItems addObject:menuItem];
        }
        [data setObject:(NSArray*)categoryItems forKey:categoryName];
    }
    
    _arrayCategories = [NSArray arrayWithArray:categories];
    
    return data;
}

- (MenuItem*) insertMenuToDatabase:(NSDictionary*)item {
    
    
    //checkDB
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"MenuItem"];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"name == %@ AND price == %@ AND  desc == %@ AND image == %@ AND identifier == %@ AND restaurantID == 5", item[@"name"], item[@"price"], item[@"desc"], item[@"image"], item[@"id"]]];
    NSError *error = nil;
    
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if (result.count) {
        return ((MenuItem*)result[0]);
    }
    
    
    
    //insert
    MenuItem *menuItem = [[MenuItem alloc] initWithEntity:[NSEntityDescription entityForName:@"MenuItem" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
    
    
    menuItem.name = isNIL(item[@"name"]);
    menuItem.price = isNIL(item[@"price"]);
    menuItem.desc = isNIL(item[@"desc"]);
    menuItem.image = isNIL(item[@"image"]);
    menuItem.identifier = isNIL(item[@"id"]);
    menuItem.restaurantID = @5;
//    NSArray *tempOptions = @[@{@"name":@"Steak",@"options":@[@"Well Done", @"Rare", @"Normal"]}, @{@"name":@"Sauce",@"options":@[@"Barbeque",@"Spicy"]}];
//    menuItem.options = [self encodeData:tempOptions withKey:@"options"];

    menuItem.options = [self encodeData:item[@"options"] withKey:@"options"];
    
    error = nil;
    if([context save:&error])
        return menuItem;
    
    return nil;
}

- (void) hideMenu {
    self.orderSentView.hidden = YES;
    [self showTitleBar:_categoryString];
    CGFloat positionY = self.view.frame.size.height - _orderCheckoutView.bounds.size.height;
    CGFloat sizeHeight = 44.0f; /*height of section*/
    positionY -= sizeHeight;
    
    
    [UIView animateWithDuration:0.2f animations:^{
        _mainTableView.frame = CGRectMake(_mainTableView.frame.origin.x, positionY, _mainTableView.frame.size.width, sizeHeight);
    } completion:^(BOOL finished) {
        _menuShown = NO;
        [_mainTableView reloadData];
    }];
}

- (void) showMenu {
    self.orderSentView.hidden = YES;
    [self showTitleBar:_categoryString];
    
    CGFloat hackHeight = self.view.frame.size.height - 64.0f; //nav plus status bar
    
    CGFloat positionY = hackHeight - (self.orderCheckoutView.bounds.origin.y +  self.orderCheckoutView.bounds.size.height);
    CGFloat sizeHeight = (44.0f * self.arrayCategories.count) + 44.0f; /*height of row and section*/
    positionY -= sizeHeight;
    
    CGFloat maxY = self.loadedControllerView.bounds.origin.y - 10.0f;
    CGFloat maxHeight = hackHeight - (44.0f + (hackFromLoad?20.0f:-44.0f));
    
    if (positionY < maxY) {
        positionY = maxY + 10.0f;
        sizeHeight = maxHeight + 20.0f;
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        _mainTableView.frame = CGRectMake(0.0f, positionY,  self.view.frame.size.width, sizeHeight);
    } completion:^(BOOL finished) {
        _menuShown = YES;
        [_mainTableView reloadData];
    }];
}

#pragma mark UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayCategories.count;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_menuShown) {
        return 0;
    }
    return 44.0f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor colorWithWhite:0.5f alpha:0.2f];
    }
    if (_menuShown) {
        cell.textLabel.text = [_arrayCategories[indexPath.row] uppercaseString];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont fontWithName:@"LucidaGrande" size:30.0f];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.minimumScaleFactor = -5.0f;
        
        cell.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.contentView.layer.borderWidth = 0.5f;
    }
    else {
        cell.hidden = YES;
    }
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIButton *buttonMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonMenu.frame = CGRectMake(0.0f, 0.0f, _mainTableView.bounds.size.width, [self tableView:tableView heightForHeaderInSection:section]);
    buttonMenu.backgroundColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
    
    [buttonMenu setTitle:@"MAIN MENU" forState:UIControlStateNormal];
    [buttonMenu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonMenu setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    buttonMenu.titleLabel.textAlignment = NSTextAlignmentCenter;
    buttonMenu.titleLabel.font = [UIFont fontWithName:@"LucidaGrande" size:16.0f];
    buttonMenu.titleLabel.textColor = [UIColor whiteColor];
    
    if (_menuShown) {
        [buttonMenu addTarget:self action:@selector(hideMenu) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [buttonMenu addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    }
    
//    if (!self.activityIndicator) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.activityIndicator.frame = CGRectMake(buttonMenu.bounds.size.width - 40.0f, 8.0f, 25.0f, 25.0f);
        self.activityIndicator.hidden = NO;
        [self.activityIndicator startAnimating];
        [buttonMenu addSubview: self.activityIndicator];
        
//    }
    
    if (self.menuIsLoading == YES) {
        self.activityIndicator.hidden = NO;
        [self.activityIndicator startAnimating];
    }
    else {
        self.activityIndicator.hidden = YES;
        [self.activityIndicator stopAnimating];
    }
    
    return buttonMenu;
}


#pragma mark UITable Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    for (UIView *subviews in self.loadedControllerView.subviews) {
        [subviews removeFromSuperview];
    }
    
    for (UIViewController *viewControllers in self.childViewControllers) {
        [viewControllers removeFromParentViewController];
    }
    
    NSString *category = _arrayCategories[indexPath.row];
    _categoryString = category;
    [self showTitleBar:category];
    MenuListViewController *menuListView = [self.storyboard instantiateViewControllerWithIdentifier:@"menuList"];
    menuListView.category = category;
    menuListView.menuList = _rawData[category];
    menuListView.delegate = self;
    
    menuListView.view.frame = self.loadedControllerView.bounds;
    [self.loadedControllerView addSubview:menuListView.view];
    [self addChildViewController:menuListView];
    [menuListView didMoveToParentViewController:self];
                             
    [self hideMenu];
    
    
}


#pragma mark MenuListDelegate
- (void) selectedItem:(MenuItem *)item {
    
    MenuDetailsViewController *itemDetails = [self.storyboard instantiateViewControllerWithIdentifier:@"menuDetails"];
    itemDetails.item = item;
    itemDetails.tableNumber = _orderTableNumber;
    itemDetails.delegate = self;
    
    itemDetails.view.frame = self.loadedControllerView.bounds;
    [self.loadedControllerView addSubview:itemDetails.view];
    [self addChildViewController:itemDetails];
    [itemDetails didMoveToParentViewController:self];
    
}

- (void)addThisMenuToOrder:(MenuItem *)menu {
    
//    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
//    
//    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OrderList"];
//    [request setReturnsObjectsAsFaults:NO];
//    NSError *error = nil;
//    
//    NSArray *result = [NSArray arrayWithArray:[context executeFetchRequest:request error:&error]];
//    if (result.count) {
//        OrderList *order = (OrderList*)result[0];
//        
//        NSMutableArray *storedOrders = [NSMutableArray new];
//        
//        NSArray *decodedList = (NSArray*)[self decodeData:order.items forKey:@"orderItems"];
//        
//        for (NSDictionary *item in decodedList) {
//            [storedOrders addObject:item];
//        }
//        
//        [storedOrders addObject:[self menuItemToDictionary:menu]];
//        
//        NSLog(@"stored:%@",storedOrders);
//        order.items = [self encodeData:storedOrders withKey:@"orderItems"];
//        order.orderSent = @NO;
//        
//        error = nil;
//        if (![context save:&error]) {
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Error %li",(long)[error code]] message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                [alert dismissViewControllerAnimated:YES completion:nil];
//            }];
//            [alert addAction:actionOK];
//            
//            [self presentViewController:alert animated:YES completion:^{
//                
//            }];
//        }
//    }
//    else {
//        OrderList *order = [[OrderList alloc] initWithEntity:[NSEntityDescription entityForName:@"OrderList" inManagedObjectContext:context]  insertIntoManagedObjectContext:context];
//        NSDictionary *menuItem = [self menuItemToDictionary:menu];
//        NSArray *items = @[menuItem];
//        order.items = [self encodeData:items withKey:@"orderItems"];
//        order.orderSent = @NO;
//        order.tableNumber = _orderTableNumber;
//    }
//    
//    [context save:&error];
    
    
    
    [self addMenuItem:menu tableNumber:_orderTableNumber];
    
    
    _totalOrderPrice += [menu.price floatValue];
    [self setTotalPrice:_totalOrderPrice];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.orderSentView.hidden = YES;
    [self showTitleBar:_categoryString];
    if ([segue.identifier isEqualToString:@"priceConfirmOrder"]) {
        ((ConfirmOrderViewController*)segue.destinationViewController).tableNumber = _orderTableNumber;
    }
    else if ([segue.identifier isEqualToString:@"showTableNumber"]) {
        ((TableNumberViewController*)segue.destinationViewController).delegate = self;
        ((TableNumberViewController*)segue.destinationViewController).tableNumber = _orderTableNumber;
    }
}


- (void)setTableNumber:(NSString *)tableNumber {
    [self.orderTableButton setTitle:[NSString stringWithFormat:@"Order Table: %@",tableNumber] forState:UIControlStateNormal];
    
    self.orderTableNumber = tableNumber;
}


- (void)resolveTotalPrice:(NSInteger)price {
    _totalOrderPrice += price;
    [self setTotalPrice:_totalOrderPrice];
}

@end
