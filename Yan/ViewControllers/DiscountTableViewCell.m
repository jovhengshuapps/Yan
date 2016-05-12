//
//  DiscountTableViewCell.m
//  Yan
//
//  Created by Joshua Jose Pecson on 12/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "DiscountTableViewCell.h"

@interface DiscountTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *labelDiscountTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelDiscountSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelDiscountDesc;

@end
@implementation DiscountTableViewCell

@synthesize options = _options;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _labelDiscountTitle.text = _discountTitle;
    _labelDiscountSubTitle.text = _discountSubTitle;
    _labelDiscountDesc.text = _discountDesc;
}

- (NSArray *)options {
    return _options;
}

- (void)setOptions:(NSArray *)options {
    [self.button setTitle:options[0] forState:UIControlStateNormal];
    _options = options;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)buttonPressed:(id)sender {
    if (self.tapHandler) {
        _tapHandler(sender);
    }
}

@end
