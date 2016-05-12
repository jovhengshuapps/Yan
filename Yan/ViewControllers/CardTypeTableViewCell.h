//
//  CardTypeTableViewCell.h
//  Yan
//
//  Created by Joshua Jose Pecson on 12/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardTypeTableViewCell : UITableViewCell
@property (strong, nonatomic, nonnull) IBOutlet UILabel *labelOption;
@property (strong, nonatomic, nonnull) IBOutlet UIImageView *arrowImage;
@property (strong, nonatomic, nonnull) IBOutlet UIView *containerView;
@property (nonatomic, copy, nonnull) void (^tapHandler)(_Nonnull id sender);

@end
