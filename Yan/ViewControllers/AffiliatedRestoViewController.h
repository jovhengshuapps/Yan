//
//  AffiliatedRestoViewController.h
//  Yan
//
//  Created by Joshua Jose Pecson on 4/18/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "CoreViewController.h"
#import "RestaurantCell.h"

typedef enum {
    AffiliatedRestaurantsAll,
    AffiliatedRestaurantsRecents,
    AffiliatedRestaurantsFavorites
} AffiliatedRestaurants;

@interface AffiliatedRestoViewController : CoreViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, RestaurantCellDelegate>

@property (assign, nonatomic) AffiliatedRestaurants showAffiliatedRestaurant;

@end
