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

@interface AlertView : UIView <UIWebViewDelegate, UITextFieldDelegate>

@property(nullable,nonatomic,weak) id  delegate;
@property(nullable,nonatomic,copy) NSString *message;
@property(nullable,nonatomic,copy) NSString *textBoxText;
@property(nullable, nonatomic, copy) NSURL *videoURLstring;
@property(nullable, nonatomic,copy) NSArray *buttonsArray;
@property(nullable, nonatomic) NSURL *imageGIFURL;
@property(nullable, nonatomic) NSURL *webURL;

- (nonnull instancetype) initAlertWithMessage:(nullable NSString*)aMessage delegate:(nullable id)aDelegate buttons:(nullable NSArray*)aButtonsArray;

- (nonnull instancetype) initVideoAd:(nullable NSURL*)videoURL delegate:(nullable id)aDelegate;

- (nonnull instancetype) initAlertWithWebURL:(nullable NSURL*)awebURL delegate:(nullable id)aDelegate;

- (nonnull instancetype) initAlertWithWebURL:(nullable NSString*)awebURL delegate:(nullable id)aDelegate buttons:(nullable NSArray*)aButtonsArray;

- (nonnull instancetype) initAlertWithTextbox:(nullable NSString*)text Message:(nullable NSString*)aMessage delegate:(nullable id)aDelegate;

//- (nonnull instancetype) initWithImageGIF:(nullable NSURL*)url duration:(CGFloat)duration delegate:(nullable id)aDelegate;

- (void) showAlertView;
- (void) dismissAlertView;
//- (void) showAlertViewWithDuration:(CGFloat)duration;

@end
@protocol AlertViewDelegate <NSObject>
@optional

- (void)alertView:(nonnull AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)videoAdPlayer:(nonnull AlertView*)alertView;

- (void) alertViewDismissed:(nonnull AlertView*)alertView;

- (void) imageGIFEnded:(nonnull AlertView*)alertView;

@end
