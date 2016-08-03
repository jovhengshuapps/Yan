//
//  CustomPickerViewController.h
//  Yan
//
//  Created by Joshua Jose Pecson on 05/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPPopoverController.h"

@protocol  CustomPickerViewControllerDelegate <NSObject>

-(void)selectedItem:(NSString*)item withButton:(UIButton*)button;

@end
@interface CustomPickerViewController : FPPopoverController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIButton *button;

@property (strong,nonatomic) NSArray *choices;

@property (assign,nonatomic) id<CustomPickerViewControllerDelegate> delegatePicker;


//if multiple
@property (assign, nonatomic) NSInteger components;

@property (strong, nonatomic) NSDictionary *dictionaryChoices; //components as key

@end
