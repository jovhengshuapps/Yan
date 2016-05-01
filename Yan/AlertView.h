//
//  AlertView.h
//  Yan
//
//  Created by Joshua Jose Pecson on 4/3/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "Config.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface AlertView : UIView

@property(nullable,nonatomic,weak) id  delegate;
@property(nullable,nonatomic,copy) NSString *message;
@property(nullable, nonatomic, copy) NSString *videoURLstring;
@property(nullable, nonatomic,copy) NSArray *buttonsArray;

- (nonnull instancetype) initAlertWithMessage:(nullable NSString*)aMessage delegate:(nullable id)aDelegate buttons:(nullable NSArray*)aButtonsArray;

- (nonnull instancetype) initVideoAd:(nullable NSString*)videoURL delegate:(nullable id)aDelegate;

- (void) showAlertView;
- (void) dismissAlertView;

@end
@protocol AlertViewDelegate <NSObject>
@required

- (void)alertView:(nonnull AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@optional
- (void)videoAdPlayer:(nonnull AlertView*)alertView;

- (void) alertViewDismissed:(nonnull AlertView*)alertView;

@end