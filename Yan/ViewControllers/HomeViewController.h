//
//  HomeViewController.h
//  Yan
//
//  Created by Joshua Jose Pecson on 4/4/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "CoreViewController.h"

typedef enum {
    HomeViewDefault,
    HomeViewRegistrationComplete,
    HomeViewNotification
} HomeView_ViewToShow;


@interface HomeViewController : CoreViewController

@property (assign, nonatomic) HomeView_ViewToShow viewToShow;

@end
