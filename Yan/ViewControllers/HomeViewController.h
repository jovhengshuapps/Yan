//
//  HomeViewController.h
//  Yan
//
//  Created by Joshua Jose Pecson on 4/4/16.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "CoreViewController.h"
#import <GoogleSignIn/GoogleSignIn.h>

typedef enum {
    HomeViewDefault,
    HomeViewRegistrationComplete,
    HomeViewNotification,
    HomeViewLogin
} HomeView_ViewToShow;


@interface HomeViewController : CoreViewController <FBSDKLoginButtonDelegate, GIDSignInUIDelegate, GIDSignInDelegate>

@property (assign, nonatomic) HomeView_ViewToShow viewToShow;

@end
