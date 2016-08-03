//
//  PayScreenViewController.h
//  Yan
//
//  Created by Joshua Jose Pecson on 10/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "CoreViewController.h"

@interface PayScreenViewController : CoreViewController <AlertViewDelegate>
@property (strong, nonatomic) NSString *tableNumber;
@property (strong, nonatomic) NSDictionary *discountDetails;
@property (strong, nonatomic) NSString *paymentType;
@end
