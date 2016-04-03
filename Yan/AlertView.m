//
//  AlertView.m
//  Yan
//
//  Created by Joshua Jose Pecson on 4/3/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "AlertView.h"

@implementation AlertView

+ (instancetype) showAlertWithMessage:(nullable NSString*)message delegate:(nullable id)delegate buttons:(nullable NSArray*)buttonArray {
    id object = [[self alloc] init];
    if (!object) {
        return nil;
    }
    
    //initialize
    [self setupAlertView];
    
    
    return object;
}

- (void)setupAlertView {
    
    
    [self showAlertView];
}

- (void) showAlertView {
    
}



@end
