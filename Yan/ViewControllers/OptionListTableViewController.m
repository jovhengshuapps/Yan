//
//  OptionListTableViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 05/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "OptionListTableViewController.h"
#import "OptionListTableViewCell.h"

@interface OptionListTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) CustomPickerViewController *pickerController;
@property (strong, nonnull) FPPopoverController *popover;
@property (strong, nonatomic) NSArray *options;
@property (strong, nonatomic) NSMutableString *selectedOptions;


@end

@implementation OptionListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.mainTableView.allowsSelection = NO;
    self.options = (NSArray*)[self decodeData:self.itemDetails[@"options"] forKey:@"options"];
    
//    NSLog(@"item:%@",self.options);
    self.selectedOptions = [NSMutableString stringWithString:@""];
    
    for (NSDictionary *item in self.options) {
        if ([item[@"options"] rangeOfString:@","].location != NSNotFound) {
            [self.selectedOptions appendString:[NSString stringWithFormat:@"%@:%@,",item[@"name"],[item[@"options"] componentsSeparatedByString:@","][0]]];
        }
        else {
            [self.selectedOptions appendString:[NSString stringWithFormat:@"%@:%@,",item[@"name"],item[@"options"]]];
        }
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showTitleBar:[self.itemDetails[@"name"] uppercaseString]];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OrderList"];
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    
    NSArray *result = [NSArray arrayWithArray:[context executeFetchRequest:request error:&error]];
    
    OrderList *order = (OrderList*)result[0];
    NSMutableArray *newOrderList = [NSMutableArray new];
    NSArray *decodedList = (NSArray*)[self decodeData:order.items forKey:@"orderItems"];
    
    
    [newOrderList addObjectsFromArray:decodedList];
    
    for (NSInteger index = 0; index < decodedList.count; index++) {
        NSMutableDictionary *bundle = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)decodedList[index]];
        if ([bundle[@"identifier"] integerValue] == [self.itemDetails[@"identifier"] integerValue]) {
            
            NSMutableArray *details = [NSMutableArray arrayWithArray:(NSArray*)bundle[@"details"]];
            for (NSInteger i = 0; i < details.count; i++) {
                NSDictionary *item = (NSDictionary*)details[i];
                if ([item[@"itemnumber"] isEqualToNumber:self.itemDetails[@"itemnumber"]]) {
//                    NSLog(@"%@-ITEM:%@",self.selectedOptions,item);
                    NSMutableDictionary *updatedItem = [item mutableCopy];
                    [updatedItem setObject:self.selectedOptions forKey:@"option_choices"];
                    [details replaceObjectAtIndex:i withObject:updatedItem];
                    break;
                }
            }
//            NSLog(@"details:%@",details);
            [bundle setObject:details forKey:@"details"];
            [newOrderList replaceObjectAtIndex:index withObject:bundle];
        }
    }
    
    order.items = [self encodeData:newOrderList withKey:@"orderItems"];
    order.orderSent = @NO;
    order.tableNumber = self.tableNumber;
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OptionListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuOptionCell"];
    
    cell.optionLabel = self.options[indexPath.row][@"name"];
    NSMutableArray *choices = [NSMutableArray array];
    if ([self.options[indexPath.row][@"options"] rangeOfString:@","].location != NSNotFound) {
        [choices setArray:[self.options[indexPath.row][@"options"] componentsSeparatedByString:@","]];
    }
    else {
        [choices setArray:@[self.options[indexPath.row][@"options"]]];
    }
    cell.optionChoices = choices;
    UIButton *button = cell.buttonChoices;
    cell.tapHandler = ^(id sender) {
        // do something
        _pickerController = (CustomPickerViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"pickerView"];
        _pickerController.delegatePicker = self;
        _pickerController.choices = choices;
        _pickerController.button = button;
        
//        _pickerController.modalPresentationStyle = UIModalPresentationPopover;
//        _pickerController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionLeft;
//        
//        [self presentViewController:_pickerController animated:YES completion:^{
//            
//        }];
        
        
        self.popover = [[FPPopoverController alloc] initWithViewController:_pickerController];
        
        self.popover.tint = FPPopoverDefaultTint;
        self.popover.border = NO;
        self.popover.delegate = self;
        
//        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//        {
//            self.popover.contentSize = CGSizeMake(300, 500);
//        }
        self.popover.arrowDirection = FPPopoverArrowDirectionUp;
        
        //sender is the UIButton view
        [self.popover presentPopoverFromView:sender];
    };

    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Choose your options:";
}


- (void)selectedItem:(NSString *)item withButton:(UIButton *)button{
    CGPoint buttonPosition = [button convertPoint:CGPointZero toView:self.mainTableView];
    NSIndexPath *indexPath = [self.mainTableView indexPathForRowAtPoint:buttonPosition];
    OptionListTableViewCell *cell = (OptionListTableViewCell*)[self.mainTableView cellForRowAtIndexPath:indexPath];
//    NSLog(@"key:%@ value:%@",cell.optionLabel,item);
    
    NSMutableArray *optionComponents = [[self.selectedOptions componentsSeparatedByString:@","] mutableCopy];
    
    if (optionComponents.count > 0) {
        BOOL isNewEntry = YES;
        for (NSInteger index = 0; index < optionComponents.count; index++) {
            NSString *option = (NSString*)optionComponents[index];
            if ([option containsString:[NSString stringWithFormat:@"%@:",cell.optionLabel]]) {
                isNewEntry = NO;
                [optionComponents replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%@:%@",cell.optionLabel,item]];
//                NSLog(@"options:%@",optionComponents);
                break;
            }
        }
        
        if (isNewEntry) {
            
            [self.selectedOptions appendFormat:@"%@:%@,",cell.optionLabel,item];
        }
        else {
            [self.selectedOptions setString:@""];
            for (NSString *option in optionComponents) {
                if (option.length > 0) {
                    [self.selectedOptions appendFormat:@"%@,",option];
                }
            }
        }
        
    }
    else {
        [self.selectedOptions appendFormat:@"%@:%@,",cell.optionLabel,item];
    }
    
    
//    NSLog(@"options;%@",self.selectedOptions);
    
    [button setTitle:item forState:UIControlStateNormal];
    [self.popover dismissPopoverAnimated:YES];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (void)popoverControllerDidDismissPopover:(FPPopoverController *)popoverController {
//    NSLog(@"dismiss");
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
