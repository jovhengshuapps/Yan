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

@end

@implementation OrderMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    
    UIBarButtonItem *waiterBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"waiter-icon-resized.png"] style:UIBarButtonItemStyleDone target:self action:@selector(callWaiter)];
    
    [[self navigationItem] setRightBarButtonItem:waiterBarItem];
    
    
    _orderTableNumber = @"1";
    [self.orderTableButton setTitle:[NSString stringWithFormat:@"Order Table: %@",_orderTableNumber] forState:UIControlStateNormal];
    _orderTableButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _orderCostButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _orderCostButton.titleLabel.minimumScaleFactor = -5.0f;
    _orderTableButton.titleLabel.minimumScaleFactor = -5.0f;
    
    _rawData = [self extractMenuContent];
    
    CGFloat positionY = self.view.frame.size.height - _orderCheckoutView.bounds.size.height;
    CGFloat sizeHeight = (44.0f * _arrayCategories.count) + 44.0f; /*height of row and section*/
    positionY -= sizeHeight;
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, positionY, self.view.frame.size.width, sizeHeight) style:UITableViewStylePlain];
    _mainTableView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.bounces = NO;
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    [self.view addSubview:_mainTableView];
    
    
    [self showMenu];
    _categoryString = @"";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showTitleBar:_categoryString];
}

- (void) callWaiter {
    WaiterTableViewController *waiter = (WaiterTableViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"waiterOptions"];
    [self.navigationController pushViewController:waiter animated:YES];
}

- (NSDictionary*) extractMenuContent {
    NSMutableDictionary *data = [NSMutableDictionary new];
    NSMutableArray *categories = [NSMutableArray new];
    
    for (NSDictionary *category in self.categories) {
        NSString *categoryName = [category objectForKey:@"name"];
        [categories addObject:categoryName];
        NSMutableArray *categoryItems = [NSMutableArray new];
        for (NSDictionary *item in [category objectForKey:@"menu"]) {
            [categoryItems addObject:item];
        }
        [data setObject:(NSArray*)categoryItems forKey:categoryName];
    }
    
    _arrayCategories = [NSArray arrayWithArray:categories];
    
    return data;
}
//- (void)selectedIndex:(NSInteger)index {
//    NSLog(@"SELECTED:%li",(long)index);
//}
//
//- (void)collapsedMenuShown:(BOOL)shown {
//    
//}

- (void) hideMenu {
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
- (void) selectedItem:(NSDictionary *)item {
    
    MenuDetailsViewController *itemDetails = [self.storyboard instantiateViewControllerWithIdentifier:@"menuDetails"];
    itemDetails.item = item;
    
    itemDetails.view.frame = self.loadedControllerView.bounds;
    [self.loadedControllerView addSubview:itemDetails.view];
    [self addChildViewController:itemDetails];
    [itemDetails didMoveToParentViewController:self];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"priceConfirmOrder"]) {
        ((ConfirmOrderViewController*)segue.destinationViewController).arrayOrderList = @[];
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
