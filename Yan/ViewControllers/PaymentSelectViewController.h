//
//  PaymentSelectViewController.h
//  Yan
//
//  Created by Joshua Jose Pecson on 10/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "CoreViewController.h"

@interface PaymentSelectViewController : CoreViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong,nonatomic) NSString *tableNumber;
@end
