//
//  AlertView.h
//  Yan
//
//  Created by Joshua Jose Pecson on 4/3/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "Config.h"

@interface AlertView : UIView

@property(nullable,nonatomic,weak) id  delegate;
@property(nullable,nonatomic,copy) NSString *message;
@property(nullable, nonatomic,copy) NSArray *buttonsArray;

- (instancetype) initAlertWithMessage:(nullable NSString*)aMessage delegate:(nullable id)aDelegate buttons:(nullable NSArray*)aButtonsArray;

- (void) showAlertView;

@end
@protocol AlertViewDelegate <NSObject>
@optional

- (void)alertView:(AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end