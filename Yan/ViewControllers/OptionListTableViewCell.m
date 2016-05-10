//
//  OptionListTableViewCell.m
//  Yan
//
//  Created by Joshua Jose Pecson on 05/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "OptionListTableViewCell.h"
#import "Config.h"

@interface OptionListTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) CustomPickerViewController *detailController;
@end

@implementation OptionListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _labelTitle.text = _optionLabel;
    [_buttonChoices setTitle:(_selectedOption.length)?_selectedOption:_optionChoices[0] forState:UIControlStateNormal];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)buttonChoicesPressed:(id)sender {
    
    if (self.tapHandler) {
        _tapHandler(sender);
    }
    
}


@end
