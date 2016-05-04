//
//  ConfirmOrderViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 28/04/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "ConfirmOrderViewController.h"

@interface ConfirmOrderViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTable;

@end

@implementation ConfirmOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _mainTable.allowsSelection = NO;
    
    CGFloat totalValue = 0.0f;
    
    for (NSDictionary *item in _arrayOrderList) {
        totalValue += ([item[@"price"] floatValue] * [item[@"quantity"] floatValue]);
    }
    
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, KEYWINDOW.frame.size.width+5.0f, 110.0f)];
    footerView.backgroundColor = UIColorFromRGB(0xDFDFDF);
    
    UIView *totalView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, footerView.bounds.size.width, 44.0f)];
    totalView.backgroundColor = UIColorFromRGB(0x333333);
    
    UILabel *labelTotal = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 30.0f, 44.0f)];
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
    labelTotalValue.text = [NSString stringWithFormat:@"PHP: %.2f",totalValue];
    [totalView addSubview:labelTotalValue];
    
    [footerView addSubview:totalView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(20.0f, footerView.bounds.size.height - 44.0f - 10.0f, footerView.bounds.size.width - 20.0f - 20.0f, 44.0f)];
    [button setTitle:@"Confirm Orders" forState:UIControlStateNormal];
    
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
    
    [self showTitleBar:@"Orders: Table 9"];
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
    return 44.0f;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 44.0f;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.bounds.size.width, 44.0f)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:headerView.frame];
    label.center = headerView.center;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"LucidaGrande" size:22.0f];
    label.textColor = [UIColor blackColor];
    if (_arrayOrderList.count) {
        label.text = @"You have no orders yet.";
    }
    else {
        label.text = @"Your Orders";
    }
    
    [headerView addSubview:label];
    
    return headerView;
}


//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.bounds.size.width, [self tableView:tableView heightForFooterInSection:section])];
//    footerView.backgroundColor = [UIColor whiteColor];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 30.0f, footerView.bounds.size.height)];
//    label.textAlignment = NSTextAlignmentLeft;
//    label.font = [UIFont fontWithName:@"LucidaGrande" size:22.0f];
//    label.textColor = UIColorFromRGB(0x8A8A8A);
//    label.text = @"Sub-total:";
//    [footerView addSubview:label];
//    
//    CGFloat totalValue = 0.0f;
//    
//    for (NSDictionary *item in _arrayOrderList) {
//        totalValue += ([item[@"price"] floatValue] * [item[@"quantity"] floatValue]);
//    }
//    
//    
//    UILabel *value = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 30.0f, footerView.bounds.size.height)];
//    value.textAlignment = NSTextAlignmentLeft;
//    value.font = [UIFont fontWithName:@"LucidaGrande" size:22.0f];
//    value.textColor = UIColorFromRGB(0x8A8A8A);
//    value.text = @"Sub-total:";
//    [footerView addSubview:value];
//    
//    return footerView;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.contentView.bounds.size.width - 35.0f, 0.0f, 32.0f, 32.0f)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"LucidaGrande" size:22.0f];
        label.textColor = [UIColor blackColor];
        label.tag = 1;
        cell.accessoryView = label;
    }
    
    NSDictionary *item = _arrayOrderList[indexPath.row];
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
    
    cell.textLabel.attributedText = attrString;
    
    return cell;
}


@end
