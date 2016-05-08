//
//  WaiterOptionTableViewCell.m
//  Yan
//
//  Created by Joshua Jose Pecson on 08/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "WaiterOptionTableViewCell.h"


#define UIColorFromRGB(rgbValue)                                        [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface WaiterOptionTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *controlButton;
@end

@implementation WaiterOptionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _labelText.font = [UIFont fontWithName:@"LucidaGrande" size:20.0f];
    _labelText.textColor = UIColorFromRGB(0x363636);
    _labelText.textAlignment = NSTextAlignmentLeft;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_controlButton setHighlighted:_isChecked];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)controlButtonPressed:(id)sender {
    self.isChecked = !_isChecked;
    [self.delegateOption optionKey:_labelText.text checked:_isChecked];
}

@end
