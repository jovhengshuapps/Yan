//
//  MenuListTableViewCell.h
//  Yan
//
//  Created by Joshua Jose Pecson on 02/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuListTableViewCellDelegate <NSObject>

- (void)addThisMenu:(NSDictionary*)menu;

@end


@interface MenuListTableViewCell : UITableViewCell
@property (strong, nonatomic) NSDictionary *menu;
@property (assign, nonatomic) id<MenuListTableViewCellDelegate> delegateMenuCell;
- (void) setMenuName:(NSString*)name withPrice:(NSString*)price;
@end
