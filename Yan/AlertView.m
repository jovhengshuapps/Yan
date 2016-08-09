//
//  AlertView.m
//  Yan
//
//  Created by Joshua Jose Pecson on 4/3/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "AlertView.h"

@interface  AlertView ()

@property (strong, nonatomic) id instance;
@property (strong, nonatomic) UIView *background;
@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) AVPlayer *moviePlayer;
@property (strong, nonatomic) AVPlayerViewController *moviePlayerController;

@end

@implementation AlertView
@synthesize delegate = _delegate;
@synthesize message = _message;
@synthesize buttonsArray = _buttonsArray;
@synthesize videoURLstring = _videoURLstring;

- (instancetype) initAlertWithMessage:(nullable NSString*)aMessage delegate:(nullable id)aDelegate buttons:(nullable NSArray*)aButtonsArray {
    id object = [self init];
    if (!object) {
        return nil;
    }
    
    //initialize
    
    _delegate = aDelegate;
    _message = aMessage;
    _buttonsArray = aButtonsArray;
    _instance = object;
    
    [object setupAlertView:aDelegate:aMessage:aButtonsArray];
    
    return object;
}

- (instancetype) initVideoAd:(nullable NSURL*)videoURL delegate:(nullable id)aDelegate {
    id object = [self init];
    if (!object) {
        return nil;
    }

    //initialize
    
    _delegate = aDelegate;
    _videoURLstring = videoURL;
    _instance = object;
    
    [object setupVideoAd:aDelegate:videoURL];
    
    return object;
}


- (nonnull instancetype) initAlertWithWebURL:(nullable NSURL*)awebURL delegate:(nullable id)aDelegate {
    id object = [self init];
    if (!object) {
        return nil;
    }
    
    //initialize
    
    _delegate = aDelegate;
    _webURL = awebURL;
    _instance = object;
    
    [object setupWebView:aDelegate :awebURL];
    
    return object;
    
}

- (nonnull instancetype) initAlertWithWebURL:(nullable NSString*)awebURL delegate:(nullable id)aDelegate buttons:(nullable NSArray*)aButtonsArray {
    id object = [self init];
    if (!object) {
        return nil;
    }
    
    //initialize
    
    _delegate = aDelegate;
    _message = awebURL;
    _instance = object;
    _buttonsArray = aButtonsArray;
    
    [object setupWebView:aDelegate :awebURL :aButtonsArray];
    
    return object;
    
}


//- (nonnull instancetype) initWithImageGIF:(nullable NSURL*)url duration:(CGFloat)duration delegate:(nullable id)aDelegate {
//    id object = [self init];
//    if (!object) {
//        return nil;
//    }
//    
//    //initialize
//    
//    _delegate = aDelegate;
//    _imageGIFURL = url;
//    _instance = object;
//    
//    [object setupImage:aDelegate :url :duration];
//    
//    return object;
//}


- (void)setupAlertView:(nullable id)aDelegate :(nullable NSString*)aMessage :(nullable NSArray*)aButtonsArray {
    
    CGFloat defaultHeight =  KEYWINDOW.bounds.size.height - 40.0f;
//    CGFloat maxHeight = KEYWINDOW.bounds.size.height - 60.0f;
    CGFloat buttonHeight = 30.0f;
    
    _background = [[UIView alloc] initWithFrame:KEYWINDOW.bounds];
    _background.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
    _background.center = KEYWINDOW.center;
    
    
    _container = [[UIView alloc ] initWithFrame:CGRectMake(0.0f, 0.0f, _background.frame.size.width - 20.0f, defaultHeight)];
    _container.center = _background.center;
    _container.backgroundColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    
    _container.layer.borderColor = [UIColorFromRGB(0x959595) CGColor];
    _container.layer.borderWidth = 2.0f;
    
    [_background addSubview:_container];
    
    _background.userInteractionEnabled = NO;
    _container.userInteractionEnabled = NO;
    
    //setup text
    UITextView *contentText = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, _container.frame.size.width - 20.0f, _container.frame.size.height - (28.0f + buttonHeight))];
    contentText.text = _message;
    contentText.textColor = UIColorFromRGB(0x333333);
    contentText.font = [UIFont fontWithName:@"LucidaGrande" size:24.0f];
    contentText.textAlignment = NSTextAlignmentCenter;
    contentText.editable = NO;
    contentText.backgroundColor = [UIColor clearColor];
    [_container addSubview:contentText];
    
    
    
    //setup buttons
    if (_buttonsArray == nil || [_buttonsArray count] < 1) {
        //default button close
        UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
        close.backgroundColor = UIColorFromRGB(0x959595);
        
        close.layer.borderColor = [UIColorFromRGB(0x959595) CGColor];
        close.layer.borderWidth = 1.0f;
        
        close.layer.cornerRadius = 5.0f;
        
        [close setTitle:@"CLOSE" forState:UIControlStateNormal];
        [close setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [close setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateHighlighted];
        
        close.frame = CGRectMake(10.0f, contentText.bounds.size.height + contentText.bounds.origin.y + 8.0f, contentText.bounds.size.width, buttonHeight);
        
        [close addTarget:_instance action:@selector(closeAlertView) forControlEvents:UIControlEventTouchUpInside];
        
        [_container addSubview:close];
    }
    else {
        for (NSInteger i = 0; i < _buttonsArray.count; i++) {
            if (![[_buttonsArray objectAtIndex:i] isKindOfClass:[NSString class]]) {
                break;
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = UIColorFromRGB(0x959595);
            
            button.layer.borderColor = [UIColorFromRGB(0x959595) CGColor];
            button.layer.borderWidth = 1.0f;
            
            [button setTitle:[_buttonsArray objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateHighlighted];
            
            CGFloat buttonWidth = contentText.bounds.size.width/(_buttonsArray.count);
            
            button.frame = CGRectMake(10.0f + ((buttonWidth + 5.0f) * i), contentText.bounds.size.height + contentText.bounds.origin.y + 8.0f, buttonWidth - (5.0f * i), buttonHeight);
            button.tag = i;
            
            [button addTarget:_instance action:@selector(clickedAtIndex:) forControlEvents:UIControlEventTouchUpInside];
            
            [_container addSubview:button];
            
        }
    }
    
    UITapGestureRecognizer *tapClose = [[UITapGestureRecognizer alloc] initWithTarget:_instance action:@selector(closeAlertView)];
    [_background addGestureRecognizer:tapClose];
    
    
    _container.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [KEYWINDOW addSubview:_background];
    
    [self showAlertView];
}

- (void)setupVideoAd:(nullable id)aDelegate :(nullable NSURL*)videoURL {
    
    CGFloat height = KEYWINDOW.bounds.size.height - 60.0f;
    CGFloat buttonHeight = 30.0f;
    
    _background = [[UIView alloc] initWithFrame:KEYWINDOW.bounds];
    _background.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
    _background.center = KEYWINDOW.center;
    
    
    _container = [[UIView alloc ] initWithFrame:CGRectMake(0.0f, 0.0f, _background.frame.size.width - 30.0f, height)];
    _container.center = _background.center;
    _container.backgroundColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    
    _container.layer.borderColor = [UIColorFromRGB(0x959595) CGColor];
    _container.layer.borderWidth = 2.0f;
    
    [_background addSubview:_container];
    
    _background.userInteractionEnabled = NO;
    _container.userInteractionEnabled = NO;
    
    //setup video
   
    AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:videoURL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayerFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];

    _moviePlayer = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    _moviePlayerController = [[AVPlayerViewController alloc] init];
    [_moviePlayerController.view setFrame:CGRectMake(10, 10, _container.bounds.size.width - 20.0f, _container.bounds.size.height - 10.0f - buttonHeight)];
    _moviePlayerController.player = _moviePlayer;
    _moviePlayerController.showsPlaybackControls = NO;
    [_container addSubview:_moviePlayerController.view];
    
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    close.backgroundColor = [UIColor clearColor];//UIColorFromRGB(0x959595);
    
    [close setTitle:@"Skip" forState:UIControlStateNormal];
    [close setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [close setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    close.frame = CGRectMake(10.0f, _moviePlayerController.view.bounds.size.height + _moviePlayerController.view.bounds.origin.y + 8.0f, _moviePlayerController.view.bounds.size.width, buttonHeight);
    
    [close addTarget:_instance action:@selector(closeAlertView) forControlEvents:UIControlEventTouchUpInside];
    
    [_container addSubview:close];
    
//    UITapGestureRecognizer *tapClose = [[UITapGestureRecognizer alloc] initWithTarget:_instance action:@selector(closeAlertView)];
//    [_background addGestureRecognizer:tapClose];
    
    
    _container.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [KEYWINDOW addSubview:_background];
    
    [self showAlertView];
}

- (void)setupWebView:(nullable id)aDelegate :(nullable NSURL*)awebURL {
    
    CGFloat height = KEYWINDOW.bounds.size.height;
    
    _background = [[UIView alloc] initWithFrame:KEYWINDOW.bounds];
    _background.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
    _background.center = KEYWINDOW.center;
    
    
    _container = [[UIView alloc ] initWithFrame:CGRectMake(5.0f, 35.0f, _background.frame.size.width - 10.0f, height - 50.0f)];
//    _container.center = _background.center;
    _container.backgroundColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    
    _container.layer.borderColor = [UIColorFromRGB(0x959595) CGColor];
    _container.layer.borderWidth = 2.0f;
    
    [_background addSubview:_container];
    
    _background.userInteractionEnabled = NO;
    _container.userInteractionEnabled = NO;
    
    //setup video
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _container.frame.size.width, _container.frame.size.height)];
    [webView loadRequest:[NSURLRequest requestWithURL:awebURL]];
    [webView setDelegate:self];
    [_container addSubview:webView];
    
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    [close setImage:[UIImage imageNamed:@"plus-icon-resized"] forState:UIControlStateNormal];
    [close setFrame:CGRectMake(0.0f, 20.0f, 28.0f, 28.0f)];
    close.transform = CGAffineTransformMakeRotation(M_PI_4);
    
    [close addTarget:_instance action:@selector(closeAlertView) forControlEvents:UIControlEventTouchUpInside];
    
    [_background addSubview:close];
    
    //    UITapGestureRecognizer *tapClose = [[UITapGestureRecognizer alloc] initWithTarget:_instance action:@selector(closeAlertView)];
    //    [_background addGestureRecognizer:tapClose];
    
    
    _container.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [KEYWINDOW addSubview:_background];
    
    [self showAlertView];
}

- (void)setupWebView:(nullable id)aDelegate :(nullable NSString*)urlString :(nullable NSArray*)aButtonsArray {
    
    CGFloat height = KEYWINDOW.bounds.size.height;
    
    _background = [[UIView alloc] initWithFrame:KEYWINDOW.bounds];
    _background.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
    _background.center = KEYWINDOW.center;
    
    
    _container = [[UIView alloc ] initWithFrame:CGRectMake(5.0f, 35.0f, _background.frame.size.width - 10.0f, height - 50.0f)];
    //    _container.center = _background.center;
    _container.backgroundColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    
    _container.layer.borderColor = [UIColorFromRGB(0x959595) CGColor];
    _container.layer.borderWidth = 2.0f;
    
    [_background addSubview:_container];
    
    _background.userInteractionEnabled = NO;
    _container.userInteractionEnabled = NO;
    
    //setup video
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _container.frame.size.width, _container.frame.size.height)];
    [webView loadHTMLString:urlString baseURL:nil];
    [webView setDelegate:self];
    [_container addSubview:webView];
    
    
    
    
    //setup buttons
    if (_buttonsArray == nil) {
        
        UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
        [close setImage:[UIImage imageNamed:@"plus-icon-resized"] forState:UIControlStateNormal];
        [close setFrame:CGRectMake(0.0f, 20.0f, 28.0f, 28.0f)];
        close.transform = CGAffineTransformMakeRotation(M_PI_4);
        
        [close addTarget:_instance action:@selector(closeAlertView) forControlEvents:UIControlEventTouchUpInside];
        
        [_background addSubview:close];
    }
    else {
        webView.frame = CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.frame.size.width, webView.frame.size.height - 40.0f);
        for (NSInteger i = 0; i < _buttonsArray.count; i++) {
            if (![[_buttonsArray objectAtIndex:i] isKindOfClass:[NSString class]]) {
                break;
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = UIColorFromRGB(0x959595);
            
            button.layer.borderColor = [UIColorFromRGB(0x959595) CGColor];
            button.layer.borderWidth = 1.0f;
            
            [button setTitle:[_buttonsArray objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateHighlighted];
            
            CGFloat buttonWidth = (_container.bounds.size.width - 15.0f)/(_buttonsArray.count);
            
            button.frame = CGRectMake(10.0f + ((buttonWidth + 5.0f) * i), webView.bounds.size.height + webView.bounds.origin.y + 8.0f, buttonWidth - (5.0f * i), 28.0f);
            button.tag = i;
            
            [button addTarget:_instance action:@selector(clickedAtIndex:) forControlEvents:UIControlEventTouchUpInside];
            
            [_container addSubview:button];
            
        }
    }
    
    
    
    //    UITapGestureRecognizer *tapClose = [[UITapGestureRecognizer alloc] initWithTarget:_instance action:@selector(closeAlertView)];
    //    [_background addGestureRecognizer:tapClose];
    
    
    _container.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [KEYWINDOW addSubview:_background];
    
    [self showAlertView];
}



//- (void)setupImage:(nullable id)aDelegate :(nullable NSURL*)imageURL :(CGFloat)duration {
//    
//    CGFloat height = KEYWINDOW.bounds.size.height - 60.0f;
//    CGFloat buttonHeight = 30.0f;
//    
//    _background = [[UIView alloc] initWithFrame:KEYWINDOW.bounds];
//    _background.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
//    _background.center = KEYWINDOW.center;
//    
//    
//    _container = [[UIView alloc ] initWithFrame:CGRectMake(0.0f, 0.0f, _background.frame.size.width - 30.0f, height)];
//    _container.center = _background.center;
//    _container.backgroundColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
//    
//    _container.layer.borderColor = [UIColorFromRGB(0x959595) CGColor];
//    _container.layer.borderWidth = 2.0f;
//    
//    [_background addSubview:_container];
//    
//    _background.userInteractionEnabled = NO;
//    _container.userInteractionEnabled = NO;
//    
//    //setup imageView
//    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, _container.bounds.size.width - 20.0f, _container.bounds.size.height - 10.0f - buttonHeight)];
//    imageView.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:imageURL]];
//    [_container addSubview:imageView];
//    
//    
//    
//    
//    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
//    close.backgroundColor = [UIColor clearColor];//UIColorFromRGB(0x959595);
//    
//    [close setTitle:@"Skip" forState:UIControlStateNormal];
//    [close setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [close setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//    
//    close.frame = CGRectMake(10.0f, _moviePlayerController.view.bounds.size.height + _moviePlayerController.view.bounds.origin.y + 8.0f, _moviePlayerController.view.bounds.size.width, buttonHeight);
//    
//    [close addTarget:_instance action:@selector(closeAlertView) forControlEvents:UIControlEventTouchUpInside];
//    
//    [_container addSubview:close];
//    
//    //    UITapGestureRecognizer *tapClose = [[UITapGestureRecognizer alloc] initWithTarget:_instance action:@selector(closeAlertView)];
//    //    [_background addGestureRecognizer:tapClose];
//    
//    
//    _container.transform = CGAffineTransformMakeScale(0.1, 0.1);
//    [KEYWINDOW addSubview:_background];
//    
////    [self showAlertViewWithDuration:duration];
//}

- (void) showAlertView {
    
    [UIView animateWithDuration:0.1f animations:^{
        _container.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
    } completion:^(BOOL finished) {
        _background.userInteractionEnabled = YES;
        _container.userInteractionEnabled = YES;
        
        if (_moviePlayerController && _moviePlayer) {
           
            [_moviePlayer play];
        }
    }];
    
}


//- (void) showAlertViewWithDuration:(CGFloat)duration {
//    
//    [UIView animateWithDuration:0.1f animations:^{
//        _container.transform = CGAffineTransformMakeScale(1.0, 1.0);
//        
//    } completion:^(BOOL finished) {
//        _background.userInteractionEnabled = YES;
//        _container.userInteractionEnabled = YES;
//        
//        NSTimer *timer = [NSTimer timerWithTimeInterval:duration*100.0f target:self selector:@selector(timerEnded) userInfo:nil repeats:NO];
//        
//        [timer fire];
//        
//    }];
//    
//}

- (void)timerEnded {
//    [_delegate imageGIFEnded:_instance];
}

- (void) dismissAlertView {
    [self closeAlertView];
}

- (void) closeAlertView {
    _background.userInteractionEnabled = NO;
    _container.userInteractionEnabled = NO;
    if (_moviePlayerController && _moviePlayer) {
        [_moviePlayer pause];
        _moviePlayer = nil;
        _moviePlayerController = nil;
    }
    [UIView animateWithDuration:0.1f animations:^{
        _container.transform = CGAffineTransformMakeScale(0.1, 0.1);
        
    } completion:^(BOOL finished) {
        if ([_delegate respondsToSelector:@selector(alertViewDismissed:)]) {
            [_delegate alertViewDismissed:_instance];
        }
        [_background removeFromSuperview];
    }];
}

- (void) clickedAtIndex:(UIButton*)sender {
    NSInteger index = sender.tag;
    if ([_delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [_delegate alertView:_instance clickedButtonAtIndex:index];
    }
    if (index == 0) {
        [self closeAlertView];
    }
}

- (void) videoPlayerFinished:(NSNotification*)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification.name object:nil];
    if ([_delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [_delegate videoAdPlayer:_instance];
    }
    
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"start");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"finish");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"error:%@",[error description]);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}


@end
