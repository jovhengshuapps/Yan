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
    NSString *text = [NSString stringWithFormat:@"%@ PHP%@",[name uppercaseString],price];
    
    CGFloat nameSize = _labelMenuName.font.pointSize;
    CGFloat priceSize = nameSize / 2.0f;
    
    NSArray *components = [text componentsSeparatedByString:@" PHP"];
    NSRange nameRange = [text rangeOfString:[components objectAtIndex:0]];
    NSRange priceRange = [text rangeOfString:[components objectAtIndex:1]];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attrString beginEditing];
    [attrString addAttribute: NSFontAttributeName
                       value:[UIFont fontWithName:@"LucidaGrande" size:nameSize]
                       range:nameRange];
    
    [attrString addAttribute: NSFontAttributeName
                       value:[UIFont fontWithName:@"LucidaGrande" size:priceSize]
                       range:priceRange];
    
    [attrString endEditing];
    
    _labelMenuName.attributedText = attrString;
    
}

- (IBAction)addMenuPressed:(id)sender {
    [_delegateMenuCell addThisMenu:_menu];
}

@end
