//
//  Reservation+CoreDataProperties.h
//  Yan
//
//  Created by Joshua Jose Pecson on 05/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Reservation.h"

NS_ASSUME_NONNULL_BEGIN

@interface Reservation (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *fullName;
@property (nullable, nonatomic, retain) NSString *reservationDate;
@property (nullable, nonatomic, retain) NSString *reservationTime;
@property (nullable, nonatomic, retain) NSString *numberOfPerson;
@property (nullable, nonatomic, retain) NSString *tableNumber;

@end

NS_ASSUME_NONNULL_END
