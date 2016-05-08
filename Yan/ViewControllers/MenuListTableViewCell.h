//
//  MenuListTableViewCell.h
//  Yan
//
//  Created by Joshua Jose Pecson on 02/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuItem.h"

@protocol MenuListTableViewCellDelegate <NSObject>

- (void)addThisMenu:(MenuItem*)menu;

@end


@interface MenuListTableViewCell : UITableViewCell
@property (strong, nonatomic) MenuItem *menu;
@property (assign, nonatomic) id<MenuListTableViewCellDelegate> delegateMenuCell;
- (void) setMenuName:(NSString*)name withPrice:(NSString*)price;
@end
