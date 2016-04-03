//
//  RootViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 3/31/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)awakeFromNib
{
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"navigation"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"drawer"];
    self.menuViewSize = CGSizeMake(190.0f, self.view.bounds.size.height);
    self.limitMenuViewSize = YES;
}


@end
