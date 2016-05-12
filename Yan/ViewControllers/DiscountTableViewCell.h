//
//  DiscountTableViewCell.h
//  Yan
//
//  Created by Joshua Jose Pecson on 12/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"

@interface DiscountTableViewCell : UITableViewCell
@property (strong, nonatomic, nullable) NSString *discountTitle;
@property (strong, nonatomic, nullable) NSString *discountSubTitle;
@property (strong, nonatomic, nullable) NSString *discountDesc;
@property (strong, nonnull) NSArray *options;
@property (nonatomic, copy, nonnull) void (^tapHandler)(_Nonnull id sender);
@property (weak, nonatomic, nullable) IBOutlet CustomButton *button;

@end
