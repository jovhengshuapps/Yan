//
//  CoreViewController.h
//  Yan
//
//  Created by Joshua Jose Pecson on 3/31/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "Config.h"

@interface CoreViewController : UIViewController <AlertViewDelegate>
@property (strong, nonatomic) UIView *titleBarView;

- (void) showTitleBar:(NSString*)title;
- (void) hideTitleBar;
- (BOOL) userLoggedIn;
- (void) isFromRegistration:(BOOL)fromRegistration;

@end
