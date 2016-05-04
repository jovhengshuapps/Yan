//
//  OrderMenuViewController.h
//  Yan
//
//  Created by IOS Developer on 05/04/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "CoreViewController.h"
//#import "CollapseMenuView.h"
#import "MenuListViewController.h"

@interface OrderMenuViewController : CoreViewController </*CollapseMenuViewDelegate*/UITableViewDataSource, UITableViewDelegate, MenuListDelegate>

@property(strong,nonatomic) NSArray *categories;
@end
