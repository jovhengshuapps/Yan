//
//  WaiterOptionTableViewCell.h
//  Yan
//
//  Created by Joshua Jose Pecson on 08/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WaiterOptionTableViewCellDelegate <NSObject>

- (void)optionKey:(NSString*)key checked:(BOOL)isChecked;

@end

@interface WaiterOptionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelText;
@property (assign, nonatomic) BOOL isChecked;

@property (assign, nonatomic) id<WaiterOptionTableViewCellDelegate> delegateOption;

@end
