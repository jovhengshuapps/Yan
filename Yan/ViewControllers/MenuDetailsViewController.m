//
//  MenuDetailsViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 26/04/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "MenuDetailsViewController.h"

#import "OptionListTableViewController.h"

@interface MenuDetailsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *detailsTable;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;

@property (strong, nonatomic) NSMutableArray *arrayOrders;

@end

@implementation MenuDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSData *imageData = _item.imageData;
    if (imageData) {
        
        self.itemImage.image = [UIImage imageWithData:imageData];
    }
    else {
        self.itemImage.image = [UIImage imageNamed:@"yan-logo"];
        
        if (_item.image.length) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImage:) name:@"MenuImageFromURL" object:nil];
            
            [self getImageFromURL:_item.image completionNotification:@"MenuImageFromURL"];
            
        }
        

    }
    
    [self.itemImage setFrame:CGRectMake(0.0f, 0.0f, _detailsTable.bounds.size.width, 330.0f)];
    
    [_detailsTable setTableHeaderView:self.itemImage];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, KEYWINDOW.frame.size.width, 40.0f)];
    footerView.backgroundColor = [UIColor clearColor];
    [_detailsTable setTableFooterView:footerView];
    
    _detailsTable.scrollsToTop = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) updateImage:(NSNotification*)notification {
    self.itemImage.image = notification.object;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self fetchOrderData];
}

- (void) fetchOrderData {
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OrderList"];
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    
    NSArray *result = [NSArray arrayWithArray:[context executeFetchRequest:request error:&error]];
    
    if (result.count) {
        OrderList *order = (OrderList*)result[0];
        
        NSArray *storedOrders = [self decodeData:order.items forKey:@"orderItems"];
        
        _arrayOrders = [NSMutableArray new];
        
        for (NSDictionary *bundle in storedOrders) {
            for (NSDictionary *item in bundle[@"details"]) {
                if([self.item.identifier isEqualToNumber:item[@"identifier"]]){
                    [_arrayOrders addObject:item];                    
                }
            }
        }
    }
    
    
    
    
    [_detailsTable reloadData];
//    [_detailsTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    
//    _detailsTable.contentSize = CGSizeMake(_detailsTable.contentSize.width, _detailsTable.contentSize.height + 110.0f); //allowance for the menu and checkout
    
}


# pragma mark Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayOrders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"menuOptionCell";
    
    MenuOptionTableViewCell *cell = (MenuOptionTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    cell.delegateOptionCell = self;
    NSDictionary *item = (NSDictionary*)_arrayOrders[indexPath.row];
//    NSLog(@"items:%@",item);
    cell.labelMenuName.text = [item[@"name"] uppercaseString];
    NSString *choices = [item[@"option_choices"] substringToIndex:[item[@"option_choices"] length]-1];
    cell.labelMenuOptions.text = [choices capitalizedString];
    cell.index = indexPath.row;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 160.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _detailsTable.bounds.size.width, [self tableView:tableView heightForHeaderInSection:section])];
    
    UIView *nameHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, contentView.bounds.size.width, 55.0f)];
    nameHeaderView.backgroundColor = UIColorFromRGB(0xDFDFDF);
    nameHeaderView.layer.borderColor = [UIColor whiteColor].CGColor;
    nameHeaderView.layer.borderWidth = 1.0f;
    
    UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 5.0f, nameHeaderView.bounds.size.width - 15.0f - 40.0f, 44.0f)];
    labelName.adjustsFontSizeToFitWidth = YES;
    labelName.minimumScaleFactor = -15.0f;
    NSString *text = [NSString stringWithFormat:@"%@ PHP%@",[_item.name uppercaseString],_item.price];
    
    CGFloat nameSize = 20.0f;//labelName.frame.size.height - 10.0f;
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
    
    labelName.attributedText = attrString;
    
    UIButton *addMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addMoreButton addTarget:self action:@selector(addMoreMenu) forControlEvents:UIControlEventTouchUpInside];
    [addMoreButton setImage:[UIImage imageNamed:@"plus-icon-resized"] forState:UIControlStateNormal];
    [addMoreButton setFrame:CGRectMake(labelName.bounds.origin.y + labelName.bounds.size.width + 15.0f, 11.0f, 32.0f, 32.0f)];
    
    [nameHeaderView addSubview:labelName];
    [nameHeaderView addSubview:addMoreButton];
    
    [contentView addSubview:nameHeaderView];
    
    UIView *descriptionView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, nameHeaderView.bounds.size.height + 3.0f, contentView.bounds.size.width, 110.0f)];
    descriptionView.backgroundColor = UIColorFromRGB(0xDFDFDF);
    descriptionView.layer.borderColor = [UIColor whiteColor].CGColor;
    descriptionView.layer.borderWidth = 1.0f;
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(35.0f, 0.0f, descriptionView.bounds.size.width - 35.0f - 10.0f, 80.0f)];
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.text = _item.desc.length?_item.desc:@"Placeholder Text Description.";
    descriptionLabel.font = [UIFont fontWithName:@"LucidaGrande" size:18.0f];
    descriptionLabel.textColor = UIColorFromRGB(0x333333);
    
    UILabel *orderLabels = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, descriptionLabel.frame.size.height, descriptionView.bounds.size.width - 5.0f - 10.0f, 30.0f)];
    orderLabels.text = (_arrayOrders.count)?@"Your Orders:":@"";
    orderLabels.font = [UIFont fontWithName:@"LucidaGrande" size:18.0f];
    orderLabels.textColor = UIColorFromRGB(0x333333);
    
    [descriptionView addSubview:descriptionLabel];
    [descriptionView addSubview:orderLabels];
    
    [contentView addSubview:descriptionView];
    
    
    return contentView;
    

}

- (void) addMoreMenu {
    
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
//        [storedOrders addObject:[self menuItemToDictionary:_item]];
//        
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
//        NSDictionary *menuItem = [self menuItemToDictionary:_item];
//        NSArray *items = @[menuItem];
//        order.items = [self encodeData:items withKey:@"orderItems"];
//        order.orderSent = @NO;
//        order.tableNumber = _tableNumber;
//        ;
//    }
//   
//    
//    
//    [context save:&error];
    
    [self addMenuItem:_item tableNumber:_tableNumber];
    
    [self.delegate resolveTotalPrice:[_item.price integerValue]];
    [self fetchOrderData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_arrayOrders.count-1 inSection:0];
    [_detailsTable scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
}

- (void)optionSelectedIndex:(NSInteger)index sender:(id)sender {
    OptionListTableViewController *optionsTVC = (OptionListTableViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"optionListController"];
    NSDictionary *item = (NSDictionary*)_arrayOrders[index];
//    optionsTVC.menuName = item[@"name"];
//    optionsTVC.optionList = [self decodeData:item[@"options"] forKey:@"options"];
    optionsTVC.itemDetails = item;
    [self.navigationController pushViewController:optionsTVC animated:YES];
    
    
    
    
    
}

- (void)removeSelectedIndex:(NSInteger)index {
    NSDictionary *itemToRemove = [_arrayOrders objectAtIndex:index];
    
    [_arrayOrders removeObjectAtIndex:index];
    
    [_detailsTable reloadData];
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OrderList"];
    [request setReturnsObjectsAsFaults:NO];
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
    }
    
    
    [self.delegate resolveTotalPrice:-[itemToRemove[@"price"] integerValue]];
    
}



@end
