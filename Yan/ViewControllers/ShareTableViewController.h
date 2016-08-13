//
//  ShareTableViewController.h
//  Yan
//
//  Created by Joshua Jose Pecson on 10/05/2016.
//  Copyright © 2016 JoVhengshua Apps. All rights reserved.
//

#import "CoreViewController.h"


@interface ShareTableViewController : CoreViewController <FBSDKSharingDelegate>

@property (strong, nonatomic) NSString *tableNumber;
@property (strong, nonatomic) NSString *restaurant;
@property (strong, nonatomic) NSString *restaurantURL;
@property (strong, nonatomic) UIImage *imageLogo;
@property (strong, nonatomic) NSString *imageLogoURL;

@end
