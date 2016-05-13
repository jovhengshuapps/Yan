//
//  CardDateTableViewCell.m
//  Yan
//
//  Created by Joshua Jose Pecson on 12/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "CardDateTableViewCell.h"

@implementation CardDateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.arrowMonth.transform = CGAffineTransformMakeRotation(-M_PI_2);
    
    UITapGestureRecognizer *tapMonth = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureMonth)];
    
    [self.containerViewMonth addGestureRecognizer:tapMonth];
    
    
    self.arrowYear.transform = CGAffineTransformMakeRotation(-M_PI_2);
    
    UITapGestureRecognizer *tapYear = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureYear)];
    
    [self.containerViewYear addGestureRecognizer:tapYear];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) tapGestureMonth {
    
    if (self.tapHandlerMonth) {
        _tapHandlerMonth(_containerViewMonth);
    }
}


- (void) tapGestureYear {
    
    if (self.tapHandlerYear) {
        _tapHandlerYear(_containerViewYear);
    }
}

@end
