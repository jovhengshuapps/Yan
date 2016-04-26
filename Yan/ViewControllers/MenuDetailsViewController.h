//
//  MenuDetailsViewController.h
//  Yan
//
//  Created by Joshua Jose Pecson on 26/04/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "CoreViewController.h"

@interface MenuDetailsViewController : CoreViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSDictionary *item;

@end
