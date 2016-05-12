//
//  CardTypeTableViewCell.m
//  Yan
//
//  Created by Joshua Jose Pecson on 12/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "CardTypeTableViewCell.h"

@implementation CardTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.arrowImage.transform = CGAffineTransformMakeRotation(-M_PI_2);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    
    [self.containerView addGestureRecognizer:tap];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) tapGesture {
    
    if (self.tapHandler) {
        _tapHandler(_containerView);
    }
}

@end
