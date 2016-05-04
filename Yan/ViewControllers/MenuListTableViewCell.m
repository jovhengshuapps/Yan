//
//  MenuListTableViewCell.m
//  Yan
//
//  Created by Joshua Jose Pecson on 02/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "MenuListTableViewCell.h"
#import "Config.h"

@interface MenuListTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel  *labelMenuName;
@property (strong, nonatomic) IBOutlet  UILabel *labelPrice;
@property (strong, nonatomic) IBOutlet  UIButton *buttonAddMenu;
@end

@implementation MenuListTableViewCell

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


- (void) setMenuName:(NSString*)name withPrice:(NSString*)price {
    
    _labelMenuName.text = [name uppercaseString];
    _labelPrice.text = [NSString stringWithFormat:@"PHP %@",[price uppercaseString]];
    
    CGSize nameSize = [_labelMenuName.text sizeWithAttributes:TextAttributes(_labelMenuName.font.fontName, 0x000000, _labelMenuName.font.pointSize)];
    CGSize priceSize = [_labelPrice.text sizeWithAttributes:TextAttributes(_labelPrice.font.fontName, 0x000000, _labelPrice.font.pointSize)];
    
    CGRect frame = _labelMenuName.frame;
    frame.size.width = nameSize.width;
    _labelMenuName.frame = frame;
    
    frame = _labelPrice.frame;
    frame.origin.x = _labelMenuName.bounds.origin.x + _labelMenuName.bounds.size.width + 8.0f;
    frame.size.width = priceSize.width;
    _labelPrice.frame = frame;
}

- (IBAction)addMenuPressed:(id)sender {
    [_delegateMenuCell addThisMenu:_menu];
}

@end
