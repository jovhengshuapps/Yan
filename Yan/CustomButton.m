//
//  CustomButton.m
//  Yan
//
//  Created by Joshua Jose Pecson on 4/20/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    
//    [super drawRect:rect];
//    
//    
//}

- (void)didAddSubview:(UIView *)subview {
    
    self.layer.cornerRadius = 5.0f;
    self.titleLabel.font = [UIFont fontWithName:@"LucidaGrande" size:20.0f];
    self.titleLabel.textColor = [UIColor whiteColor];
    
}



@end
