//
//  RestaurantsListTableViewController.h
//  Yan
//
//  Created by Joshua Jose Pecson on 13/08/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "CoreViewController.h"
#import "RestaurantCell.h"

@interface RestaurantsListTableViewController : CoreViewController <UITableViewDataSource, UITableViewDelegate, RestaurantCellDelegate>
@property (assign, nonatomic) BOOL showFavoritesOnly;
@end
