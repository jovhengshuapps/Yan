//
//  DatePickerViewController.h
//  Yan
//
//  Created by Joshua Jose Pecson on 30/04/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  DatePickerViewControllerDelegate <NSObject>

-(void)dateSelected:(NSString*)dateString mode:(UIDatePickerMode)mode;

@end

@interface DatePickerViewController : UIViewController
@property (strong,nonatomic) id<DatePickerViewControllerDelegate> delegate;
@property (assign, nonatomic) UIDatePickerMode datePickerMode;
@property (assign, nonatomic) BOOL birthdayValidation;
@property (assign, nonatomic) BOOL todayValidation;
@property (strong, nonatomic) NSArray *disabledDates;
@end
