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

@interface AlertView : UIView <AVPlayerViewControllerDelegate>

@property(nullable,nonatomic,weak) id  delegate;
@property(nullable,nonatomic,copy) NSString *message;
@property(nullable, nonatomic, copy) NSString *videoURLstring;
@property(nullable, nonatomic,copy) NSArray *buttonsArray;

- (instancetype) initAlertWithMessage:(nullable NSString*)aMessage delegate:(nullable id)aDelegate buttons:(nullable NSArray*)aButtonsArray;

- (instancetype) initVideoAd:(nullable NSString*)videoURL delegate:(nullable id)aDelegate;

- (void) showAlertView;

@end
@protocol AlertViewDelegate <NSObject>
@required

- (void)alertView:(AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)videoAdPlayer:(AVPlayer*)player controller:(AVPlayerViewController*)controller;

- (void) alertViewDismissed:(AlertView*)alertView;

@end