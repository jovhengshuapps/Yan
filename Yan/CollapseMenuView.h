//
//  CollapseMenuView.h
//  Yan
//
//  Created by IOS Developer on 05/04/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CollapseMenuViewDelegate <NSObject>

- (void) selectedIndex:(NSInteger)index;
- (void) collapsedMenuShown:(BOOL)shown;

@end

@interface CollapseMenuView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) id delegate;
@property (strong, nonatomic) NSDictionary *content;

- (instancetype) initWithContent:(NSDictionary*)datasource;

@end
