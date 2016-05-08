//
//  CustomPickerViewController.h
//  Yan
//
//  Created by Joshua Jose Pecson on 05/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  CustomPickerViewControllerDelegate <NSObject>

-(void)selectedItem:(NSString*)item;

@end
@interface CustomPickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong,nonatomic) NSArray *choices;

@property (assign,nonatomic) id<CustomPickerViewControllerDelegate> delegatePicker;

@end
