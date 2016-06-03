//
//  OrderListTableViewCell.m
//  Yan
//
//  Created by Joshua Jose Pecson on 15/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "OrderListTableViewCell.h"

@implementation OrderListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)duplicateThisItem:(id)sender {
    [self.delegateCell duplicateSelectedIndex:_index];
}
- (IBAction)removeThisItem:(id)sender {
    [self.delegateCell removeSelectedIndex:_index];
}

@end
