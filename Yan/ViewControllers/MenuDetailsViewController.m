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

@property (strong, nonatomic) NSArray *arrayOrders;

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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImage:) name:@"MenuImageFromURL" object:nil];
        
        [self getImageFromURL:_item.image completionNotification:@"MenuImageFromURL"];

    }
    
    [self.itemImage setFrame:CGRectMake(0.0f, 0.0f, _detailsTable.bounds.size.width, 330.0f)];
    
    [_detailsTable setTableHeaderView:self.itemImage];
    
    
    
    self.detailsTable.contentSize = CGSizeMake(self.detailsTable.contentSize.width, self.detailsTable.contentSize.height + 110.0f); //allowance for the menu and checkout
    
    [self fetchOrderData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) updateImage:(NSNotification*)notification {
    self.itemImage.image = notification.object;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) fetchOrderData {
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OrderList"];
    
    NSError *error = nil;
    
    _arrayOrders = [NSArray arrayWithArray:[context executeFetchRequest:request error:&error]];
    
    [_detailsTable reloadData];
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
    cell.labelMenuName.text = [((OrderList*)_arrayOrders[indexPath.row]).itemName uppercaseString];
    cell.index = indexPath.row;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 150.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _detailsTable.bounds.size.width, [self tableView:tableView heightForHeaderInSection:section])];
    
    UIView *nameHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, contentView.bounds.size.width, 44.0f)];
    nameHeaderView.backgroundColor = UIColorFromRGB(0xDFDFDF);
    nameHeaderView.layer.borderColor = [UIColor whiteColor].CGColor;
    nameHeaderView.layer.borderWidth = 1.0f;
    
    UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 0.0f, nameHeaderView.bounds.size.width - 15.0f - 40.0f, 44.0f)];
    NSString *text = [NSString stringWithFormat:@"%@ PHP%@",[_item.name uppercaseString],_item.price];
    
    CGFloat nameSize = labelName.frame.size.height - 10.0f;
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
    
    labelName.attributedText = attrString;
    
    UIButton *addMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addMoreButton addTarget:self action:@selector(addMoreMenu) forControlEvents:UIControlEventTouchUpInside];
    [addMoreButton setImage:[UIImage imageNamed:@"plus-icon-resized"] forState:UIControlStateNormal];
    [addMoreButton setFrame:CGRectMake(labelName.bounds.origin.y + labelName.bounds.size.width, 0.0f, 32.0f, 32.0f)];
    
    [nameHeaderView addSubview:labelName];
    [nameHeaderView addSubview:addMoreButton];
    
    [contentView addSubview:nameHeaderView];
    
    UIView *descriptionView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, nameHeaderView.bounds.size.height + 3.0f, contentView.bounds.size.width, 100.0f)];
    descriptionView.backgroundColor = UIColorFromRGB(0xDFDFDF);
    descriptionView.layer.borderColor = [UIColor whiteColor].CGColor;
    descriptionView.layer.borderWidth = 1.0f;
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(35.0f, 0.0f, descriptionView.bounds.size.width - 35.0f - 10.0f, 80.0f)];
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.text = _item.desc;
    descriptionLabel.font = [UIFont fontWithName:@"LucidaGrande" size:18.0f];
    descriptionLabel.textColor = UIColorFromRGB(0x333333);
    
    UILabel *orderLabels = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, descriptionLabel.frame.size.height, descriptionView.bounds.size.width - 5.0f - 10.0f, 20.0f)];
    orderLabels.text = @"Your Orders:";
    orderLabels.font = [UIFont fontWithName:@"LucidaGrande" size:18.0f];
    orderLabels.textColor = UIColorFromRGB(0x333333);
    
    [descriptionView addSubview:descriptionLabel];
    [descriptionView addSubview:orderLabels];
    
    [contentView addSubview:descriptionView];
    
    
    return contentView;
    

}

- (void) addMoreMenu {
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    OrderList *order = [[OrderList alloc] initWithEntity:[NSEntityDescription entityForName:@"OrderList" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
    
    
    order.itemName = _item.name;
    order.itemPrice = _item.price;
    order.itemOptions = _item.options;
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
    
    [self fetchOrderData];
    [_detailsTable setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
}

- (void)optionSelectedIndex:(NSInteger)index {
    OptionListTableViewController *optionsTVC = (OptionListTableViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"optionListController"];
    optionsTVC.menuName = ((OrderList*)_arrayOrders[index]).itemName;
    optionsTVC.optionList = [self decodeData:((OrderList*)_arrayOrders[index]).itemOptions forKey:@"options"];
    [self.navigationController pushViewController:optionsTVC animated:YES];
    
}

- (void)removeSelectedIndex:(NSInteger)index {
    OrderList *item = ((OrderList*)_arrayOrders[index]);
    
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    [context deleteObject:item];
    
    NSError *error = nil;
    [context save:&error];
}



@end
