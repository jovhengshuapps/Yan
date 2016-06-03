//
//  ConfirmOrderViewController.h
//  Yan
//
//  Created by Joshua Jose Pecson on 28/04/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "CoreViewController.h"
#import "OrderListTableViewCell.h"

@interface ConfirmOrderViewController : CoreViewController <UITableViewDataSource, UITableViewDelegate, OrderListTableViewCellDelegate>
@property (strong, nonatomic) NSString *tableNumber;
@end
