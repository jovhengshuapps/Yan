//
//  MenuDetailsViewController.h
//  Yan
//
//  Created by Joshua Jose Pecson on 26/04/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "CoreViewController.h"
#import "MenuOptionTableViewCell.h"

@protocol MenuDetailsViewControllerDelegate <NSObject>

- (void)resolveTotalPrice:(NSInteger)price;

@end
@interface MenuDetailsViewController : CoreViewController <UITableViewDataSource, UITableViewDelegate, MenuOptionTableViewCellDelegate>

@property (strong, nonnull, nonatomic) MenuItem *item;
@property (strong, nonnull, nonatomic) NSString *tableNumber;
@property (assign, nonnull, nonatomic) id<MenuDetailsViewControllerDelegate> delegate;

@end
