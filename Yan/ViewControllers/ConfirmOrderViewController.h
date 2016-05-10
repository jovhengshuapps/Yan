//
//  ConfirmOrderViewController.h
//  Yan
//
//  Created by Joshua Jose Pecson on 28/04/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "CoreViewController.h"

@interface ConfirmOrderViewController : CoreViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray *arrayOrderList;
@property (strong, nonatomic) NSString *tableNumber;
@end
