//
//  RestaurantCell.m
//  Yan
//
//  Created by Joshua Jose Pecson on 06/08/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "RestaurantCell.h"

@interface RestaurantCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLogo;
@property (weak, nonatomic) IBOutlet UILabel *labelRestaurantName;
@property (weak, nonatomic) IBOutlet UILabel *labelRestaurantDetails;
@property (weak, nonatomic) IBOutlet UIButton *buttonFavorites;

@end

@implementation RestaurantCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.imageViewLogo.image = [UIImage imageNamed:@"yan-new-logo"];
    self.imageViewLogo.backgroundColor=[UIColor clearColor];
    self.imageViewLogo.tag = 45;
    self.imageViewLogo.contentMode = UIViewContentModeScaleAspectFit;
    self.labelRestaurantName.text = self.restaurantName;
    self.labelRestaurantDetails.text = self.restaurantDetails;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)layoutSubviews {
    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.contentView.frame.size.height-2.0f, self.window.frame.size.width, 2.0f)];
    bottomBorder.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bottomBorder];
}

- (void) setName:(NSString*)name andDetails:(NSString*)details {
    
}

- (IBAction)buttonFavoritesPressed:(id)sender {
    [_cellDelegate saveToFavorites:sender];
}

@end