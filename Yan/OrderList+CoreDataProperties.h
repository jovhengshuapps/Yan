//
//  OrderList+CoreDataProperties.h
//  Yan
//
//  Created by Joshua Jose Pecson on 05/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "OrderList.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderList (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *items;
@property (nullable, nonatomic, retain) NSString *tableNumber;
@property (nullable, nonatomic, retain) NSNumber *orderSent;
@property (nullable, nonatomic, retain) NSString *orderSubmitID;
@property (nullable, nonatomic, retain) NSString *user_id;
@property (nullable, nonatomic, retain) NSString *restaurant_id;
@property (nullable, nonatomic, retain) NSString *user_name;

@end

NS_ASSUME_NONNULL_END
