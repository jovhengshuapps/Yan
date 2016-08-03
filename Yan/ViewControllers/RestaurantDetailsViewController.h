//
//  RestaurantDetailsViewController.h
//  Yan
//
//  Created by Joshua Jose Pecson on 4/20/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "CoreViewController.h"

@interface RestaurantDetailsViewController : CoreViewController <MKMapViewDelegate>
@property (strong, nonatomic) Restaurant *restaurantDetails;
@property (strong, nonatomic) NSString *reservedTableNumber;
@end
