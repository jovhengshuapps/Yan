//
//  OrderListTableViewCell.h
//  Yan
//
//  Created by Joshua Jose Pecson on 15/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol OrderListTableViewCellDelegate <NSObject>

- (void)duplicateSelectedIndex:(NSInteger)index;
- (void)removeSelectedIndex:(NSInteger)index;

@end

@interface OrderListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelItemOptions;
@property (strong, nonatomic) IBOutlet UILabel *labelItemNamePrice;
@property (strong, nonatomic) IBOutlet UILabel *labelItemQuantity;
@property (weak, nonatomic) IBOutlet UIButton *duplicateButton;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) id<OrderListTableViewCellDelegate> delegateCell;
@end
