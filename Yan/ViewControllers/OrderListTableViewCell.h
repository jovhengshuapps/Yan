//
//  OrderListTableViewCell.h
//  Yan
//
//  Created by Joshua Jose Pecson on 15/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *labelItemNamePrice;
@property (strong, nonatomic) IBOutlet UILabel *labelItemQuantity;
@end
