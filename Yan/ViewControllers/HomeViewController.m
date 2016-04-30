//
//  HomeViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 4/4/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"

@interface HomeViewController()
@property (weak, nonatomic) IBOutlet UIView *viewDefaultHome;
@property (weak, nonatomic) IBOutlet UIView *viewRegistrationComplete;
@property (weak, nonatomic) IBOutlet UIView *viewNotificationReminder;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    
    UIBarButtonItem *menuBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"app-menu.png"] style:UIBarButtonItemStyleDone target:self action:@selector(openMenu)];
    
    [[self navigationItem] setLeftBarButtonItem:menuBarItem];
    
    
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    
    [notification addObserver:self selector:@selector(changeView:) name:ChangeHomeViewToShow object:nil];
    
    _viewDefaultHome.hidden = NO;
    
    
    [super viewDidLoad];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification postNotificationName:ChangeHomeViewToShow object:nil];
    
}

- (void) changeView:(NSNotification*)notification {
    if ([notification.object isEqualToString:@"HomeViewNotification"]) {
        self.viewToShow = HomeViewNotification;
        _viewDefaultHome.hidden = YES;
        _viewRegistrationComplete.hidden = YES;
        _viewNotificationReminder.hidden = NO;
    }
    else if ([notification.object isEqualToString:@"HomeViewRegistrationComplete"]) {
        self.viewToShow = HomeViewRegistrationComplete;

        _viewDefaultHome.hidden = YES;
        _viewRegistrationComplete.hidden = NO;
        _viewNotificationReminder.hidden = YES;
    }
    else {
        _viewDefaultHome.hidden = NO;
        _viewRegistrationComplete.hidden = YES;
        _viewNotificationReminder.hidden = YES;
    }
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if (![identifier isEqualToString:@"showLogin"]) {
        
        //check if logged in
        if (![self userLoggedIn]) {
            [self.navigationController performSegueWithIdentifier:@"showLogin" sender:self];
            return NO;
        }
        else {
            return YES;
        }
    }
    return YES;
}


@end
