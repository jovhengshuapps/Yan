//
//  Notification+CoreDataProperties.h
//  Yan
//
//  Created by Joshua Jose Pecson on 26/06/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Notification.h"

NS_ASSUME_NONNULL_BEGIN

@interface Notification (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *body_text;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *reservation_time;

@end

NS_ASSUME_NONNULL_END
