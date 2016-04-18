//
//  HomeViewController.m
//  Yan
//
//  Created by Joshua Jose Pecson on 4/4/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "RegistrationCompleteViewController.h"

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
    
    //check if logged in
    if (![self userLoggedIn]) {
        [self.navigationController performSegueWithIdentifier:@"showLogin" sender:self];
    }
    
    [super viewDidLoad];
    
    
    
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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"regCompleteOrderButton"]) {
        
        NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
        [notification postNotificationName:ChangeHomeViewToShow object:nil];
    }
}

@end
