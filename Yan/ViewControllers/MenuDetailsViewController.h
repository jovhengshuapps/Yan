//
//  MenuDetailsViewController.h
//  Yan
//
//  Created by Joshua Jose Pecson on 26/04/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "CoreViewController.h"
#import "MenuOptionTableViewCell.h"


@interface MenuDetailsViewController : CoreViewController <UITableViewDataSource, UITableViewDelegate, MenuOptionTableViewCellDelegate>

@property (strong, nonatomic) MenuItem *item;
@property (strong, nonatomic) NSString *tableNumber;

@end
