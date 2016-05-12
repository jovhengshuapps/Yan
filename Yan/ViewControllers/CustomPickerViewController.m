//
//  CustomPickerViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 05/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "CustomPickerViewController.h"
#import "Config.h"

@interface CustomPickerViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet CustomButton *doneButton;

@end

@implementation CustomPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_pickerView selectRow:0 inComponent:0 animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonPressed:(id)sender {
    NSInteger row = [_pickerView selectedRowInComponent:0];
//    [self dismissViewControllerAnimated:YES completion:^{        
//        [_delegatePicker selectedItem:_choices[row] withButton:_button];
//    }];
    
    
    [self dismissPopoverAnimated:YES completion:^{
        [_delegatePicker selectedItem:_choices[row] withButton:_button];
    }];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _choices.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return (NSString*)_choices[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"selected:%@",_choices[row]);
}




@end
