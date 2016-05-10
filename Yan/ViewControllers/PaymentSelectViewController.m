//
//  PaymentSelectViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 10/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "PaymentSelectViewController.h"
#import "PaymentSelectionTableViewCell.h"
#import "PayScreenViewController.h"

@interface PaymentSelectViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (strong, nonatomic) NSArray *arrayOptions;
@property (assign, nonatomic) NSInteger selectedOptionIndex;
@property (assign, nonatomic) BOOL expand;

@end

@implementation PaymentSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, KEYWINDOW.frame.size.width+5.0f, 120.0f)];
    footerView.backgroundColor = UIColorFromRGB(0xDFDFDF);
    
    UIView *totalView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, footerView.bounds.size.width, 44.0f)];
    totalView.backgroundColor = UIColorFromRGB(0x333333);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(20.0f, footerView.bounds.size.height - 44.0f - 44.0f - 10.0f - 10.0f, footerView.bounds.size.width - 20.0f - 20.0f, 44.0f)];
    [button setTitle:@"Proceed to Payment" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(proceedPayment) forControlEvents:UIControlEventTouchUpInside];
   
    
    button.titleLabel.font = [UIFont fontWithName:@"LucidaGrande" size:20.0f];
    button.titleLabel.textColor = UIColorFromRGB(0xFFFFFF);
    
    [button setBackgroundColor:UIColorFromRGB(0x000000)];
    [footerView addSubview:button];
    
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setFrame:CGRectMake(20.0f, footerView.bounds.size.height - 44.0f - 10.0f, footerView.bounds.size.width - 20.0f - 20.0f, 44.0f)];
    [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelPayment) forControlEvents:UIControlEventTouchUpInside];
    
    
    cancel.titleLabel.font = [UIFont fontWithName:@"LucidaGrande" size:20.0f];
    cancel.titleLabel.textColor = UIColorFromRGB(0xFFFFFF);
    
    [cancel setBackgroundColor:UIColorFromRGB(0x363636)];
    [footerView addSubview:cancel];
    
    [_mainTable setTableFooterView:footerView];
    
    self.arrayOptions = @[@"Pay Cash/CC to Restaurant Rep.", @"Push bill to other user", @"Pay with GC/Discount"];
    self.selectedOptionIndex = -1;
    self.expand = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showTitleBar:@"PAYMENT"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) proceedPayment {
    
    PayScreenViewController *paymentSelect = (PayScreenViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"payScreenView"];
    paymentSelect.tableNumber = _tableNumber;
    [self.navigationController pushViewController:paymentSelect animated:YES];
}

- (void) cancelPayment {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Table Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayOptions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_expand) {
        return 54.0f;
    }else {
        if (_selectedOptionIndex == -1 && indexPath.row == 0) {
            return 54.0f;
        }
        else if (_selectedOptionIndex == indexPath.row) {
            return 54.0f;
        }
    }
    
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(15.0f, 5.0f, tableView.bounds.size.width-30.0f, 44.0f)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:headerView.frame];
    label.center = headerView.center;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont fontWithName:@"LucidaGrande" size:14.0f];
    label.textColor = [UIColor blackColor];
        label.text = @"Select your Option:";
    
    [headerView addSubview:label];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PaymentSelectionTableViewCell *cell = (PaymentSelectionTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"paymentCell"];
    
    cell.containerView.layer.borderWidth = 2.0f;
    
    cell.labelOption.text = _arrayOptions[indexPath.row];
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    if (_expand) {
        cell.hidden = NO;
        cell.arrowImage.hidden = YES;
    }
    else {
        if (_selectedOptionIndex == -1 && indexPath.row == 0) {
            cell.hidden = NO;
            cell.arrowImage.hidden = NO;
        }
        else if (_selectedOptionIndex == indexPath.row) {
            cell.hidden = NO;
            cell.arrowImage.hidden = NO;
        }
        else {
            cell.hidden = YES;
        }
    }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedOptionIndex = indexPath.row;
    self.expand = !_expand;
    
    [self.mainTable reloadData];
}

@end
