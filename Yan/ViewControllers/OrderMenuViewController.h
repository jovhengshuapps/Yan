//
//  OrderMenuViewController.h
//  Yan
//
//  Created by IOS Developer on 05/04/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "CoreViewController.h"
#import "MenuListViewController.h"
#import "TableNumberViewController.h"

@interface OrderMenuViewController : CoreViewController <UITableViewDataSource, UITableViewDelegate, MenuListDelegate, TableNumberViewControllerDelegate>

@property(strong,nonatomic) NSArray *categories;
@end
