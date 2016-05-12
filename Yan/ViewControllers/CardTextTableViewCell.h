//
//  CardTextTableViewCell.h
//  Yan
//
//  Created by Joshua Jose Pecson on 12/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardTextTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelOption;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@end
