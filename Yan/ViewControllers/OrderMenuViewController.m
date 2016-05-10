//
//  OrderMenuViewController.m
//  Yan
//
//  Created by IOS Developer on 05/04/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "OrderMenuViewController.h"
#import "MenuListViewController.h"
#import "MenuDetailsViewController.h"
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
    
    NSError *error = nil;
    
    NSArray *result = [NSArray arrayWithArray:[context executeFetchRequest:request error:&error]];
    
    _totalOrderPrice = 0.0f;
    for (OrderList *orders in result) {
        NSLog(@"[%@ : %@",orders.itemName, orders.orderSent);
        _totalOrderPrice += [orders.itemPrice floatValue];
    }
    
    [self setTotalPrice:_totalOrderPrice];
    _orderTableButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _orderCostButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _orderCostButton.titleLabel.minimumScaleFactor = -5.0f;
    _orderTableButton.titleLabel.minimumScaleFactor = -5.0f;
    
    _rawData = [self extractMenuContent];
    
    CGFloat hackHeight = self.view.frame.size.height - 64.0f; //nav plus status bar
    
    CGFloat positionY = hackHeight - (_orderCheckoutView.bounds.origin.y +  _orderCheckoutView.bounds.size.height);
    CGFloat sizeHeight = (44.0f * _arrayCategories.count) + 44.0f; /*height of row and section*/
    positionY -= sizeHeight;
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, positionY, self.view.frame.size.width, sizeHeight) style:UITableViewStylePlain];
    _mainTableView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.bounces = NO;
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    [self.view addSubview:_mainTableView];
    _menuShown = YES;
    [_mainTableView reloadData];
    hackFromLoad = YES;
    _categoryString = @"";
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showOrderSentView) name:@"OrderSentNotification" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showTitleBar:_categoryString];
    if (hackFromLoad) {
        
    }
    else {
        [self showMenu];
        hackFromLoad = NO;
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
    [request setPredicate:[NSPredicate predicateWithFormat:@"name == %@", item[@"name"]]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"price == %@", item[@"price"]]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"desc == %@", item[@"desc"]]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"image == %@", item[@"image"]]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", item[@"id"]]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"restaurantID == 5"]];
    NSError *error = nil;
    
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if (result.count) {
        return ((MenuItem*)result[0]);
    }
    
    
    
    //insert
    MenuItem *menuItem = [[MenuItem alloc] initWithEntity:[NSEntityDescription entityForName:@"MenuItem" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
    
    
    menuItem.name = item[@"name"];
    menuItem.price = item[@"price"];
    menuItem.desc = item[@"desc"];
    menuItem.image = item[@"image"];
    menuItem.identifier = item[@"id"];
    menuItem.restaurantID = @5;
    NSDictionary *tempOptions = @{@"Steak":@[@"Well Done", @"Rare", @"Normal"], @"Sauce":@[@"Barbeque",@"Spicy"]};
    menuItem.options = [self encodeData:tempOptions withKey:@"options"];
    
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
    CGFloat positionY = self.view.frame.size.height - _orderCheckoutView.bounds.size.height;
    CGFloat sizeHeight = (44.0f * _arrayCategories.count) + 44.0f; /*height of row and section*/
    positionY -= sizeHeight;
    
    [UIView animateWithDuration:0.2f animations:^{
        _mainTableView.frame = CGRectMake(_mainTableView.frame.origin.x, positionY, _mainTableView.frame.size.width, sizeHeight);
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
        cell.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
    }
    if (_menuShown) {
        cell.textLabel.text = [_arrayCategories[indexPath.row] uppercaseString];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont fontWithName:@"LucidaGrande" size:30.0f];
        cell.textLabel.textColor = [UIColor whiteColor];
        
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
    buttonMenu.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
    
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
    
    itemDetails.view.frame = self.loadedControllerView.bounds;
    [self.loadedControllerView addSubview:itemDetails.view];
    [self addChildViewController:itemDetails];
    [itemDetails didMoveToParentViewController:self];
    
}

- (void)addThisMenuToOrder:(MenuItem *)menu {
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    OrderList *order = [[OrderList alloc] initWithEntity:[NSEntityDescription entityForName:@"OrderList" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
    
    
    order.itemName = menu.name;
    order.itemPrice = menu.price;
    order.itemOptions = menu.options;
    order.itemQuantity = @"1";
    order.orderSent = @NO;
    
    NSError *error = nil;
    if (![context save:&error]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Error %li",(long)[error code]] message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:actionOK];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
    
    _totalOrderPrice += [menu.price floatValue];
    [self setTotalPrice:_totalOrderPrice];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.orderSentView.hidden = YES;
    [self showTitleBar:_categoryString];
    if ([segue.identifier isEqualToString:@"priceConfirmOrder"]) {
        ((ConfirmOrderViewController*)segue.destinationViewController).arrayOrderList = @[];
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

@end
