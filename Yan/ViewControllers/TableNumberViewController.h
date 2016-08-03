//
//  TableNumberViewController.h
//  Yan
//
//  Created by Joshua Jose Pecson on 08/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TableNumberViewControllerDelegate <NSObject>

- (void)setTableNumber:(NSString*)tableNumber;

@end

@interface TableNumberViewController : UIViewController

@property (strong, nonatomic) NSString *tableNumber;
@property (assign, nonatomic) id<TableNumberViewControllerDelegate> delegate;

@end
