//
//  CardDateTableViewCell.h
//  Yan
//
//  Created by Joshua Jose Pecson on 12/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardDateTableViewCell : UITableViewCell
@property (strong, nonatomic, nonnull) IBOutlet UILabel *labelMonth;
@property (strong, nonatomic, nonnull) IBOutlet UIImageView *arrowMonth;
@property (strong, nonatomic, nonnull) IBOutlet UIView *containerViewMonth;
@property (nonatomic, copy, nonnull) void (^tapHandlerMonth)(_Nonnull id sender);

@property (strong, nonatomic, nonnull) IBOutlet UILabel *labelYear;
@property (strong, nonatomic, nonnull) IBOutlet UIImageView *arrowYear;
@property (strong, nonatomic, nonnull) IBOutlet UIView *containerViewYear;
@property (nonatomic, copy, nonnull) void (^tapHandlerYear)(_Nonnull id sender);

@end
