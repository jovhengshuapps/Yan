//
//  MenuItem.m
//  Yan
//
//  Created by Joshua Jose Pecson on 05/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "MenuItem.h"
#import "AppDelegate.h"

@implementation MenuItem

// Insert code here to add functionality to your managed object subclass
//
//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
//    NSEntityDescription *entity =
//    [NSEntityDescription entityForName:@"MenuItem"  inManagedObjectContext:context];
//    
//    
//    //checkDB
//    
//    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"MenuItem"];
//    
//    [request setPredicate:[NSPredicate predicateWithFormat:@"name == %@ AND price == %@ AND  desc == %@ AND image == %@ AND identifier == %@ AND restaurantID == 5", object[@"name"], object[@"price"], object[@"desc"], object[@"image"], object[@"id"]]];
//    NSError *error = nil;
//    
//    NSArray *result = [context executeFetchRequest:request error:&error];
//    
//
//    
//    
//    self = [super initWithEntity:entity insertIntoManagedObjectContext:nil];
//    NSArray * attributeNameArray =
//    [[NSArray alloc] initWithArray:self.entity.attributesByName.allKeys];
//    
//    for (NSString * attributeName in attributeNameArray) {
//        [self setValue:[aDecoder decodeObjectForKey:attributeName] forKey:attributeName];
//    }
//    return self;
//}
//
//- (void)encodeWithCoder:(NSCoder *)coder {
//    [coder encodeObject:self forKey:@"orderItems"];
//}

@end
