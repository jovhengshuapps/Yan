//
//  MenuOptionTableViewCell.h
//  Yan
//
//  Created by Joshua Jose Pecson on 02/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuOptionTableViewCellDelegate <NSObject>

- (void)optionSelectedIndex:(NSInteger)index sender:(id)sender;
- (void)removeSelectedIndex:(NSInteger)index;

@end
@interface MenuOptionTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel  *labelMenuName;
@property (weak, nonatomic) IBOutlet UILabel *labelMenuOptions;
@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) id<MenuOptionTableViewCellDelegate> delegateOptionCell;

@end
