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
    if (_components > 1) {
        NSMutableString *item = [NSMutableString stringWithString:@""];
        for (NSInteger component = 1; component <= _components; component++) {
            component--;
            NSInteger row = [_pickerView selectedRowInComponent:component];
            NSString *key = [NSString stringWithFormat:@"%li",(long)component];
            [item appendString:(NSString*)_dictionaryChoices[key][row]];
            component++;
            if (component >= _components) {
                break;
            }
            [item appendString:@"|"];
        }
        
        [_delegatePicker selectedItem:item withButton:_button];
        
    }
    else {
        NSInteger row = [_pickerView selectedRowInComponent:0];
        
        
        [self dismissPopoverAnimated:YES completion:^{
            [_delegatePicker selectedItem:_choices[row] withButton:_button];
        }];
    }
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (_components > 1) {
        return _components;
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (_components > 1) {
        NSString *key = [NSString stringWithFormat:@"%li",(long)component];
        return [_dictionaryChoices[key] count];
    }
    return _choices.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (_components > 1) {
        NSString *key = [NSString stringWithFormat:@"%li",(long)component];
        return (NSString*)_dictionaryChoices[key][row];
        
    }
    return (NSString*)_choices[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (_components > 1) {
        NSString *key = [NSString stringWithFormat:@"%li",(long)component];
        NSLog(@"selected:%@",(NSString*)_dictionaryChoices[key][row]);
        
    }
    else {
        NSLog(@"selected:%@",_choices[row]);
        
    }
}




@end
