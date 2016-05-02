//
//  MenuOptionTableViewCell.h
//  Yan
//
//  Created by Joshua Jose Pecson on 02/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuOptionTableViewCellDelegate <NSObject>

- (void)optionSelectedIndex:(NSInteger)index inMenu:(NSDictionary*)menu;

@end
@interface MenuOptionTableViewCell : UITableViewCell
@property (strong, nonatomic) NSDictionary *menu;
@property (assign, nonatomic) id<MenuOptionTableViewCellDelegate> delegateOptionCell;

@end
