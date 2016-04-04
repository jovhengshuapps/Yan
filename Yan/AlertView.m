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

@end

@implementation AlertView
@synthesize delegate = _delegate;
@synthesize message = _message;
@synthesize buttonsArray = _buttonsArray;

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


- (void)setupAlertView:(nullable id)aDelegate :(nullable NSString*)aMessage :(nullable NSArray*)aButtonsArray {
    
    CGFloat defaultHeight =  300.0f;
    CGFloat maxHeight = KEYWINDOW.bounds.size.height - 60.0f;
    CGFloat buttonHeight = 30.0f;
    
    _background = [[UIView alloc] initWithFrame:KEYWINDOW.bounds];
    _background.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
    _background.center = KEYWINDOW.center;
    
    
    _container = [[UIView alloc ] initWithFrame:CGRectMake(0.0f, 0.0f, _background.frame.size.width - 60.0f, defaultHeight)];
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
        
        close.layer.borderColor = [UIColorFromRGB(0x727272) CGColor];
        close.layer.borderWidth = 1.0f;
        
        close.layer.cornerRadius = 5.0f;
        
        [close setTitle:@"Close" forState:UIControlStateNormal];
        [close setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [close setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateHighlighted];
        
        close.frame = CGRectMake(10.0f, contentText.bounds.size.height + contentText.bounds.origin.y + 8.0f, contentText.bounds.size.width, buttonHeight);
        
        [close addTarget:_instance action:@selector(closeAlertView) forControlEvents:UIControlEventTouchUpInside];
        
        [_container addSubview:close];
    }
    else {
        NSLog(@"buttons;%@",self.buttonsArray);
        for (NSInteger i = 0; i < _buttonsArray.count; i++) {
            if (![[_buttonsArray objectAtIndex:i] isKindOfClass:[NSString class]]) {
                break;
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = UIColorFromRGB(0xFFAE42);
            
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
    
    
    
    _container.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [KEYWINDOW addSubview:_background];
    
    [self showAlertView];
}

- (void) showAlertView {
    [UIView animateWithDuration:0.1f animations:^{
        _container.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
    } completion:^(BOOL finished) {
        _background.userInteractionEnabled = YES;
        _container.userInteractionEnabled = YES;
    }];
    
}

- (void) closeAlertView {
    _background.userInteractionEnabled = NO;
    _container.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.1f animations:^{
        _container.transform = CGAffineTransformMakeScale(0.1, 0.1);
        
    } completion:^(BOOL finished) {
        [_background removeFromSuperview];
    }];
}

- (void) clickedAtIndex:(UIButton*)sender {
    NSInteger index = sender.tag;
    [_delegate alertView:_instance clickedButtonAtIndex:index];
}

@end
