//
//  DiscountViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 12/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "DiscountViewController.h"
#import "PayScreenViewController.h"
#import "DiscountTableViewCell.h"

@interface DiscountViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonnull) NSArray *discounts;
@property (strong, nonnull) FPPopoverController *popover;
@property (strong, nonatomic) NSMutableDictionary *discountDetails;
@end

@implementation DiscountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, KEYWINDOW.frame.size.width+5.0f, 120.0f)];
    footerView.backgroundColor = UIColorFromRGB(0xDFDFDF);
    
    UIView *totalView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, footerView.bounds.size.width, 44.0f)];
    totalView.backgroundColor = UIColorFromRGB(0x333333);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(20.0f, footerView.bounds.size.height - 44.0f - 44.0f - 10.0f - 10.0f, footerView.bounds.size.width - 20.0f - 20.0f, 44.0f)];
    [button setTitle:@"Proceed to Final Bill" forState:UIControlStateNormal];
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
    
    [_mainTableView setTableFooterView:footerView];
    
    self.discounts = @[
                          @{@"title":@"Senior Citizen",
                            @"subtitle":@"How many Senior Citizen are with you on the table?",
                            @"desc":@"*Senior Citizen ID will be verified before billout",
                            @"options":@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"]
                            },
                          @{@"title":@"Gift Certificate",
                            @"subtitle":@"How much is your discount?",
                            @"desc":@"*Only one(1) GCs is allowed per transaction\n*Discountwillbe verified before billout",
                            @"options":@[@"0\%",@"10\%",@"20\%",@"30\%",@"40\%",@"50\%",@"60\%",@"70\%",@"80\%",@"90\%",@"100\%"]
                            }
                          ];
    
    self.discountDetails = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"senior",@"0%",@"gc", nil];
    
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
    paymentSelect.discountDetails = @{@"senior":_discountDetails[@"senior"],
                                      @"gc":_discountDetails[@"gc"]};
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
    return _discounts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(15.0f, 5.0f, tableView.bounds.size.width-30.0f, 44.0f)];
    headerView.backgroundColor = UIColorFromRGB(0xDFDFDF);
    
    UILabel *label = [[UILabel alloc] initWithFrame:headerView.frame];
    label.center = headerView.center;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont fontWithName:@"LucidaGrande" size:14.0f];
    label.textColor = [UIColor blackColor];
    label.text = @"Select your Discount Options:";
    
    [headerView addSubview:label];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DiscountTableViewCell *cell = (DiscountTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"discountCell"];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.discountTitle = _discounts[indexPath.row][@"title"];
    cell.discountSubTitle = _discounts[indexPath.row][@"subtitle"];
    cell.discountDesc = _discounts[indexPath.row][@"desc"];
    cell.options = _discounts[indexPath.row][@"options"];
    if ([_discounts[indexPath.row][@"title"] isEqualToString:@"Senior Citizen"]) {
        cell.button.tag = 1;
    }
    else {
        cell.button.tag = 2;
    }
    UIButton *button = cell.button;
    cell.tapHandler = ^(id sender) {
        // do something
        CustomPickerViewController *pickerController = (CustomPickerViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"pickerView"];
        pickerController.delegatePicker = self;
        pickerController.choices = _discounts[indexPath.row][@"options"];
        pickerController.button = button;
        
        self.popover = [[FPPopoverController alloc] initWithViewController:pickerController];
        
        self.popover.tint = FPPopoverDefaultTint;
        self.popover.border = NO;
        self.popover.delegate = self;
        
        self.popover.arrowDirection = FPPopoverArrowDirectionRight;
        
        //sender is the UIButton view
        [self.popover presentPopoverFromView:sender];
    };
    
    return cell;
}
- (void)selectedItem:(NSString *)item withButton:(UIButton *)button{
    [button setTitle:item forState:UIControlStateNormal];
    if (button.tag == 1) {
        [self.discountDetails setObject:item forKey:@"senior"];
    }
    else if (button.tag == 2){
        [self.discountDetails setObject:item forKey:@"gc"];
    }
    [self.popover dismissPopoverAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [_mainTableView reloadData];
}

@end
