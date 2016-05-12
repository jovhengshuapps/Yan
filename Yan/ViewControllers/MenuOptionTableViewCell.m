//
//  MenuOptionTableViewCell.m
//  Yan
//
//  Created by Joshua Jose Pecson on 02/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "MenuOptionTableViewCell.h"
#import "Config.h"

@interface MenuOptionTableViewCell ()

@property (strong, nonatomic) IBOutlet  UIButton *buttonRemoveMenu;
@property (strong, nonatomic) IBOutlet  UIButton *buttonMenuOption;
@end

@implementation MenuOptionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)layoutSubviews {
    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.contentView.frame.size.height-2.0f, KEYWINDOW.frame.size.width, 2.0f)];
    bottomBorder.backgroundColor = UIColorFromRGB(0xFFFFFF);
    [self.contentView addSubview:bottomBorder];
}


- (IBAction)removeMenuPressed:(id)sender {
    
    [_delegateOptionCell removeSelectedIndex:_index];
}
- (IBAction)menuOptionPressed:(id)sender {
    [_delegateOptionCell optionSelectedIndex:_index sender:sender];
}

@end
