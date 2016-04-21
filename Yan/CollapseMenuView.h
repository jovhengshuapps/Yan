//
//  CollapseMenuView.h
//  Yan
//
//  Created by IOS Developer on 05/04/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CollapseMenuViewPositionTop,
    CollapseMenuViewPositionBottom
} CollapseMenuViewPosition;

@protocol CollapseMenuViewDelegate <NSObject>

- (void) selectedIndex:(NSInteger)index;
- (void) collapsedMenuShown:(BOOL)shown;

@end

@interface CollapseMenuView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) id delegate;
@property (strong, nonatomic) NSDictionary *content;
@property (assign, nonatomic) CollapseMenuViewPosition position;
@property (assign, nonatomic) CGFloat cellHeight;

- (instancetype) initWithPosition:(CollapseMenuViewPosition) position;
- (instancetype) initWithPosition:(CollapseMenuViewPosition)position content:(NSDictionary*)datasource;

@end
