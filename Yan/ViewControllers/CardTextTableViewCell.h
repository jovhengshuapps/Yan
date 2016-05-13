//
//  CardTextTableViewCell.h
//  Yan
//
//  Created by Joshua Jose Pecson on 12/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardTextTableViewCell : UITableViewCell

@property (strong, nonatomic, nonnull) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic, nonnull) IBOutlet UITextField *textField;
@property (strong, nonatomic, nonnull) IBOutlet UIView *containerView;
@end
