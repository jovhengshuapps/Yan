//
//  MenuDetailsViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 26/04/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "MenuDetailsViewController.h"

@interface MenuDetailsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *detailsTable;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;

@property (strong, nonatomic) NSArray *arrayOrders;

@end

@implementation MenuDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSData *imageData = nil;
    if (imageData) {
        
        self.itemImage.image = [UIImage imageWithData:imageData];
    }
    else {
        self.itemImage.image = [UIImage imageNamed:@"yan-logo"];
    }
    
    [self.itemImage setFrame:CGRectMake(0.0f, 0.0f, _detailsTable.bounds.size.width, 330.0f)];
    
    [_detailsTable setTableHeaderView:self.itemImage];
    
    [_detailsTable reloadData];
    
    self.detailsTable.contentSize = CGSizeMake(self.detailsTable.contentSize.width, self.detailsTable.contentSize.height + 110.0f); //allowance for the menu and checkout
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



# pragma mark Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayOrders.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"menuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [detailButton addTarget:self action:@selector(optionButtonTapped:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        [detailButton setImage:[UIImage imageNamed:@"option-icon-resized"] forState:UIControlStateNormal];
        [detailButton setFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
        cell.accessoryView = detailButton;
        
        UIButton *removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [removeButton addTarget:self action:@selector(removeButtonTapped:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        [removeButton setImage:[UIImage imageNamed:@"remove-icon-resized"] forState:UIControlStateNormal];
        [removeButton setFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
        [cell.imageView addSubview:removeButton];
    }
        
    cell.textLabel.text = [_item[@"name"] uppercaseString];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 150.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _detailsTable.bounds.size.width, [self tableView:tableView heightForHeaderInSection:section])];
    
    UIView *nameHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, contentView.bounds.size.width, 44.0f)];
    
    UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 0.0f, nameHeaderView.bounds.size.width - 15.0f - 40.0f, 44.0f)];
    NSString *text = [NSString stringWithFormat:@"%@ PHP%@",[_item[@"name"] uppercaseString],_item[@"price"]];
    
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
    [addMoreButton addTarget:self action:@selector(optionButtonTapped:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [addMoreButton setImage:[UIImage imageNamed:@"plus-icon-resized"] forState:UIControlStateNormal];
    [addMoreButton setFrame:CGRectMake(labelName.bounds.origin.y + labelName.bounds.size.width, 0.0f, 32.0f, 32.0f)];
    
    [nameHeaderView addSubview:labelName];
    [nameHeaderView addSubview:addMoreButton];
    
    [contentView addSubview:nameHeaderView];
    
    UIView *descriptionView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, nameHeaderView.bounds.size.height + 3.0f, contentView.bounds.size.width, 100.0f)];
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(35.0f, 0.0f, descriptionView.bounds.size.width - 35.0f - 10.0f, 80.0f)];
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.text = _item[@"desc"];
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





- (void) optionButtonTapped: (UIControl *) button withEvent: (UIEvent *) event
{
    NSIndexPath * indexPath = [_detailsTable indexPathForRowAtPoint: [[[event touchesForView: button] anyObject] locationInView: _detailsTable]];
    if ( indexPath == nil )
        return;
    
//    [_detailsTable.delegate tableView: _detailsTable accessoryButtonTappedForRowWithIndexPath: indexPath];
}

- (void) removeButtonTapped: (UIControl *) button withEvent: (UIEvent *) event
{
    NSIndexPath * indexPath = [_detailsTable indexPathForRowAtPoint: [[[event touchesForView: button] anyObject] locationInView: _detailsTable]];
    if ( indexPath == nil )
        return;
    
//    [_detailsTable.delegate tableView: _detailsTable accessoryButtonTappedForRowWithIndexPath: indexPath];
}

@end
