//
//  DatePickerViewController.h
//  Yan
//
//  Created by Joshua Jose Pecson on 30/04/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  DatePickerViewControllerDelegate <NSObject>

-(void)dateSelected:(NSString*)dateString;

@end

@interface DatePickerViewController : UIViewController
@property (strong,nonatomic) id<DatePickerViewControllerDelegate> delegate;
@end
