//
//  ReserveRestoViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 4/19/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "ReserveRestoViewController.h"
#import "RestaurantDetailsViewController.h"

@interface ReserveRestoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textFieldDate;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTime;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNumberPerson;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTableNumber;

@end

@implementation ReserveRestoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
    
    [button addTarget:self action:@selector(showRestaurantDetails) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *detailsItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [[self navigationItem] setRightBarButtonItem:detailsItem];

    [self addDoneToolbar:_textFieldNumberPerson];
    [self addDoneToolbar:_textFieldTableNumber];

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showTitleBar:@"RESERVATION"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    [_textFieldTableNumber resignFirstResponder];
    [_textFieldNumberPerson resignFirstResponder];
    
    if ([segue.identifier isEqualToString:@"reserveDatePicker"]) {
        DatePickerViewController *destNav = segue.destinationViewController;
        destNav.delegate = self;
        destNav.datePickerMode = UIDatePickerModeDate;
        destNav.todayValidation = YES;
        
        // This is the important part
        UIPopoverPresentationController *popPC = destNav.popoverPresentationController;
        popPC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"reserveTimePicker"]) {
        DatePickerViewController *destNav = segue.destinationViewController;
        destNav.delegate = self;
        destNav.datePickerMode = UIDatePickerModeTime;
        destNav.todayValidation = YES;
        
        // This is the important part
        UIPopoverPresentationController *popPC = destNav.popoverPresentationController;
        popPC.delegate = self;
    }
}
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

-(void)dateSelected:(NSString*)dateString mode:(UIDatePickerMode)mode {
    if (mode == UIDatePickerModeDate) {
        self.textFieldDate.text = dateString;
    }
    else if (mode == UIDatePickerModeTime) {
        self.textFieldTime.text = dateString;
    }
}

- (void) showRestaurantDetails {
    
    RestaurantDetailsViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"restaurantDetails"];
    details.restaurantDetails = _restaurantDetails;
    details.reservedTableNumber = _textFieldTableNumber.text;
    [self.navigationController pushViewController:details animated:YES];
}



@end
