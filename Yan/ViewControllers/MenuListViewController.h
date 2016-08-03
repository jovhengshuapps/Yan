//
//  MenuListViewController.h
//  Yan
//
//  Created by Joshua Jose Pecson on 26/04/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "CoreViewController.h"
#import "MenuListTableViewCell.h"

@class MenuItem;
@protocol MenuListDelegate <NSObject>

- (void) selectedItem:(MenuItem*)item;
- (void) addThisMenuToOrder:(MenuItem*)menu;

@end
@interface MenuListViewController : CoreViewController <UITableViewDataSource, UITableViewDelegate, MenuListTableViewCellDelegate>

@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSArray *menuList;
@property (assign, nonatomic) id<MenuListDelegate> delegate;

@end
