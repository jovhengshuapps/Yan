//
//  Account+CoreDataProperties.h
//  Yan
//
//  Created by Joshua Jose Pecson on 27/04/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Account.h"

NS_ASSUME_NONNULL_BEGIN

@interface Account (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSString *token;
@property (nullable, nonatomic, retain) NSString *fullname;
@property (nullable, nonatomic, retain) NSString *birthday;
@property (nullable, nonatomic, retain) NSString *identifier;
@property (nullable, nonatomic, retain) NSString *current_tableNumber;
@property (nullable, nonatomic, retain) NSString *current_restaurantID;
@property (nullable, nonatomic, retain) NSString *current_restaurantName;

@end

NS_ASSUME_NONNULL_END
