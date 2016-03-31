//
//  RootViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 3/31/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@property (strong, nonatomic) DrawerTableViewController *drawerViewController;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setLeftViewAnimationSpeed:0.5f];
    [self setLeftViewEnabledWithWidth:250.0f presentationStyle:LGSideMenuPresentationStyleSlideAbove alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnNone];
    
    _drawerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"drawer"];
    
    [_drawerViewController.tableView reloadData];
    [self.leftView addSubview:_drawerViewController.tableView];
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"navigation"];
    
    self.rootViewController = navigationController;
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    
    window.rootViewController = self;
    
    [UIView transitionWithView:window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
    
}


- (void)leftViewWillLayoutSubviewsWithSize:(CGSize)size
{
    [super leftViewWillLayoutSubviewsWithSize:size];
    
    
    
    
}

@end
