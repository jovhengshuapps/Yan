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
#import "DiscountViewController.h"
#import "CardDateTableViewCell.h"
#import "CardTextTableViewCell.h"
#import "CardTypeTableViewCell.h"


@interface PaymentSelectViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (strong, nonatomic) NSArray *arrayOptions;
@property (assign, nonatomic) NSInteger selectedOptionIndex;
@property (assign, nonatomic) BOOL expand;
@property (strong, nonatomic, nonnull) FPPopoverController *popover;
@property (strong, nonatomic) UITextField *textfield;

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
    
    self.arrayOptions = @[@"Pay Cash to Restaurant Rep.", @"Pay CreditCard to Restaurant Rep.", @"Push bill to other user", @"Pay with GC/Discount"];
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
    
//    PayScreenViewController *paymentSelect = (PayScreenViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"payScreenView"];
//    paymentSelect.tableNumber = _tableNumber;
//    [self.navigationController pushViewController:paymentSelect animated:YES];
    
    if (self.selectedOptionIndex == 2) {
        NSString *name = @"Jay Medina";
        AlertView *alert = [[AlertView alloc] initAlertWithMessage:[NSString stringWithFormat:@"Your request has been sent to %@ to join bill.\n\nPlease wait for his approval.",name] delegate:self buttons:@[@"CLOSE"]];
        [alert showAlertView];
    }
    else {
        DiscountViewController *discountView = (DiscountViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"discountView"];
        discountView.tableNumber = _tableNumber;
        [self.navigationController pushViewController:discountView animated:YES];
    }
    

}

- (void) cancelPayment {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Table Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!_expand && _selectedOptionIndex == 1) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (!_expand && _selectedOptionIndex == 1) {
        return 4;
    }
    return _arrayOptions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_expand) {
        return 54.0f;
    }else {
        if (indexPath.section == 1) {
            return 75.0f;
        }
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
    headerView.backgroundColor = UIColorFromRGB(0xDFDFDF);
    
    UILabel *label = [[UILabel alloc] initWithFrame:headerView.frame];
    label.center = headerView.center;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont fontWithName:@"LucidaGrande" size:14.0f];
    label.textColor = [UIColor blackColor];
    if (section == 0) {
        label.text = @"Select your Option:";
    }
    else if (section == 1) {
        label.text = @"All fields are required";
    }
    
    [headerView addSubview:label];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
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
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            CardTypeTableViewCell *cell = (CardTypeTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cardTypeCell"];
            
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.containerView.layer.borderWidth = 2.0f;
            
            cell.labelOption.text = @"Visa";
            
            cell.titleLabel.text = @"Credit Card";
            
            id objSender = cell.containerView;
            
            cell.tapHandler = ^(id sender) {
                // do something
                CustomPickerViewController *pickerController = (CustomPickerViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"pickerView"];
                pickerController.delegatePicker = self;
                pickerController.choices = @[@"Visa",@"MasterCard"];
                pickerController.button = objSender;
                
                self.popover = [[FPPopoverController alloc] initWithViewController:pickerController];
                
                self.popover.tint = FPPopoverDefaultTint;
                self.popover.border = NO;
                self.popover.delegate = self;
                
                self.popover.arrowDirection = FPPopoverArrowDirectionUp;
                
                //sender is the UIButton view
                [self.popover presentPopoverFromView:sender];
            };
            
            return cell;
        }
        else if (indexPath.row == 3) {
            
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDate *currentDate = [NSDate date];
            NSDateComponents *comps = [[NSDateComponents alloc] init];
            
            [comps setYear:30];
            NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
            NSInteger currentYear = [calendar component:NSCalendarUnitYear fromDate:currentDate];
            NSInteger maximumYear = [calendar component:NSCalendarUnitYear fromDate:maxDate];
            
            NSMutableArray *arrayYears = [NSMutableArray new];
            for (NSInteger year = currentYear; year <= maximumYear; year++) {
                [arrayYears addObject:[NSString stringWithFormat:@"%li",(long)year]];
            }
            
            CardDateTableViewCell *cell = (CardDateTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cardDateCell"];
            
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.containerViewMonth.layer.borderWidth = 2.0f;
            
            cell.titleLabel.text = @"Card Expiration";
            
            cell.labelMonth.text = @"01";
            
            
            id objSenderM = cell.containerViewMonth;
            
            cell.tapHandlerMonth = ^(id sender) {
                // do something
                CustomPickerViewController *pickerController = (CustomPickerViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"pickerView"];
                pickerController.delegatePicker = self;
//                pickerController.choices = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"];
                pickerController.components = 2;
                pickerController.dictionaryChoices = @{@"0":@[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"],
                                                       @"1":arrayYears
                                                       };
                pickerController.button = objSenderM;
                
                self.popover = [[FPPopoverController alloc] initWithViewController:pickerController];
                
                self.popover.tint = FPPopoverDefaultTint;
                self.popover.border = NO;
                self.popover.delegate = self;
                
                self.popover.arrowDirection = FPPopoverArrowDirectionUp;
                
                //sender is the UIButton view
                [self.popover presentPopoverFromView:sender];
            };
            cell.containerViewYear.layer.borderWidth = 2.0f;
            
            cell.labelYear.text = [NSString stringWithFormat:@"%li",(long)currentYear];
            
            id objSenderY = cell.containerViewYear;
            
            cell.tapHandlerYear = ^(id sender) {
                // do something
                CustomPickerViewController *pickerController = (CustomPickerViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"pickerView"];
                pickerController.delegatePicker = self;
//                pickerController.choices = arrayYears;
                pickerController.components = 2;
                pickerController.dictionaryChoices = @{@"0":@[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"],
                                                       @"1":arrayYears
                                                       };
                pickerController.button = objSenderY;
                
                self.popover = [[FPPopoverController alloc] initWithViewController:pickerController];
                
                self.popover.tint = FPPopoverDefaultTint;
                self.popover.border = NO;
                self.popover.delegate = self;
                
                self.popover.arrowDirection = FPPopoverArrowDirectionUp;
                
                //sender is the UIButton view
                [self.popover presentPopoverFromView:sender];
            };
            
            return cell;
        }
        else {
            
            CardTextTableViewCell *cell = (CardTextTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cardTextCell"];
            
            cell.containerView.layer.borderWidth = 2.0f;
            
            cell.contentView.backgroundColor = [UIColor clearColor];
            
            cell.textField.delegate = self;
            
            if (indexPath.row == 1) {
                cell.titleLabel.text = @"Cardholder Name";
            }
            else if (indexPath.row == 2) {
                cell.titleLabel.text = @"Card Number";
            }
            
            return cell;
        }
    }
    
    
    return nil;
}

- (void)selectedItem:(NSString *)item withButton:(UIButton *)button {
    //hack
    if ([item rangeOfString:@"|"].location != NSNotFound) {
        NSString *month = [item substringToIndex:[item rangeOfString:@"|"].location];
        NSString *year = [item substringFromIndex:[item rangeOfString:@"|"].location+1];
        NSLog(@"[%@]m:%@ y:%@",item,month,year);
        CardDateTableViewCell *cell = [_mainTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
        cell.labelMonth.text = month;
        cell.labelYear.text = year;
    }
    else {
        
        UIView *view = (UIView*)button;
        
        for (UIView *subviews in [view subviews]) {
            if([subviews isKindOfClass:[UILabel class]]){
                ((UILabel*)subviews).text = item;
                break;
            }
            
        }
    }
    
    
    [self.popover dismissPopoverAnimated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        self.selectedOptionIndex = indexPath.row;
        self.expand = !_expand;
        
        [self.mainTable reloadData];
        if (self.selectedOptionIndex == 1) {
            
            _mainTable.contentSize = CGSizeMake(_mainTable.contentSize.width, _mainTable.contentSize.height + 150.0f);
        }
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;
    float scrollOffset = scrollView.contentOffset.y;
    
    if ((scrollOffset < -30) || (scrollOffset + scrollViewHeight > scrollContentSizeHeight+30))
    {
        //bouncing
        [self.textfield resignFirstResponder];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.textfield = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
