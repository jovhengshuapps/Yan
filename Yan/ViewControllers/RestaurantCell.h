//
//  RestaurantCell.h
//  Yan
//
//  Created by Joshua Jose Pecson on 06/08/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RestaurantCellDelegate <NSObject>

- (void)saveToFavorites:(id)sender;

@end

@interface RestaurantCell : UITableViewCell

@property (strong, nonatomic) NSString *restaurantName;
@property (strong, nonatomic) NSString *restaurantDetails;
@property (assign, nonatomic) id<RestaurantCellDelegate> cellDelegate;

- (void) setName:(NSString*)name andDetails:(NSString*)details;

@end
